import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'sntp_service.dart';
import '../utils/constants.dart';

/// Parses and validates the gate QR code.
///
/// QR format (URL scheme):
///   sentinelgate://{gateId}/{totpValue}/{sessionNonce}/{expiresAtMs}
///
/// The TOTP value rotates every 30 seconds on the server (warden's tablet).
/// On the student app we:
///   1. Parse the QR into components.
///   2. Verify expiresAtMs using SNTP-corrected time (not phone time).
///   3. Compute SHA-256 of totpValue for the signed payload.
///
/// The raw TOTP value is hashed before storage and transmission —
/// the server stores the same hash and compares.
class TotpService {
  static final _sha256 = Sha256();

  // ── Parse ──────────────────────────────────────────────────────────────────

  static QrPayload? parseQr(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;

    final fromJson = _parseJsonPayload(text);
    if (fromJson != null) return fromJson;

    final fromUri = _parseUriPayload(text);
    if (fromUri != null) return fromUri;

    final fromDelimited = _parseDelimitedPayload(text);
    if (fromDelimited != null) return fromDelimited;

    return null;
  }

  static QrPayload? _parseUriPayload(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri == null) return null;

    if (raw.startsWith(AppConstants.qrScheme) ||
        raw.startsWith(AppConstants.qrAltScheme)) {
      final allSegments = [
        if (uri.host.isNotEmpty) uri.host,
        ...uri.pathSegments,
      ];
      if (allSegments.length < 4) return null;
      return _buildPayload(
        gateId: allSegments[0],
        totpValue: allSegments[1],
        nonce: allSegments[2],
        expiresAtRaw: allSegments[3],
      );
    }

    if (uri.scheme == 'http' || uri.scheme == 'https') {
      final qp = uri.queryParameters;
      final embedded = qp['payload'] ?? qp['data'] ?? qp['qr'] ?? qp['code'];
      if (embedded != null && embedded.trim().isNotEmpty) {
        final parsedEmbedded = parseQr(Uri.decodeComponent(embedded));
        if (parsedEmbedded != null) return parsedEmbedded;
      }

      final gateId = qp['gate_id'] ?? qp['gateId'];
      final totp = qp['totp'] ?? qp['totp_token'] ?? qp['token'];
      final nonce = qp['session_nonce'] ?? qp['nonce'] ?? qp['sessionNonce'];
      final expires = qp['expires_at'] ?? qp['expiresAt'] ?? qp['exp'];
      if (gateId == null || totp == null || nonce == null || expires == null) {
        return null;
      }
      return _buildPayload(
        gateId: gateId,
        totpValue: totp,
        nonce: nonce,
        expiresAtRaw: expires,
      );
    }

    return null;
  }

  static QrPayload? _parseJsonPayload(String raw) {
    if (!raw.startsWith('{')) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      final map = Map<String, dynamic>.from(decoded);
      return _buildPayload(
        gateId: (map['gate_id'] ?? map['gateId'] ?? '').toString(),
        totpValue: (map['totp'] ?? map['totp_token'] ?? map['token'] ?? '').toString(),
        nonce: (map['session_nonce'] ?? map['sessionNonce'] ?? map['nonce'] ?? '').toString(),
        expiresAtRaw: map['expires_at'] ?? map['expiresAt'] ?? map['exp'],
      );
    } catch (_) {
      return null;
    }
  }

  static QrPayload? _parseDelimitedPayload(String raw) {
    final parts = raw.split(RegExp(r'[|,/]')).map((e) => e.trim()).toList();
    if (parts.length < 4) return null;
    return _buildPayload(
      gateId: parts[0],
      totpValue: parts[1],
      nonce: parts[2],
      expiresAtRaw: parts[3],
    );
  }

  static QrPayload? _buildPayload({
    required String gateId,
    required String totpValue,
    required String nonce,
    required dynamic expiresAtRaw,
  }) {
    final normalizedGate = gateId.trim();
    final normalizedTotp = totpValue.trim();
    final normalizedNonce = nonce.trim();
    final expiresAt = _parseExpiry(expiresAtRaw);

    if (normalizedGate.isEmpty ||
        normalizedTotp.isEmpty ||
        normalizedNonce.isEmpty ||
        expiresAt == null) {
      return null;
    }

    return QrPayload(
      gateId    : normalizedGate,
      totpValue : normalizedTotp,
      nonce     : normalizedNonce,
      expiresAt : expiresAt,
    );
  }

  static int? _parseExpiry(dynamic raw) {
    if (raw == null) return null;
    if (raw is num) {
      final value = raw.toInt();
      return value < 1000000000000 ? value * 1000 : value;
    }
    final text = raw.toString().trim();
    if (text.isEmpty) return null;
    final asInt = int.tryParse(text);
    if (asInt != null) return asInt < 1000000000000 ? asInt * 1000 : asInt;
    final asDate = DateTime.tryParse(text);
    return asDate?.toUtc().millisecondsSinceEpoch;
  }

  // ── Validate ───────────────────────────────────────────────────────────────

  /// Returns null on success, or an error string if validation fails.
  static String? validate(QrPayload qr) {
    final now = SntpService.nowMs();

    // Use SNTP time — students cannot fake this by changing phone clock
    if (now > qr.expiresAt) {
      final agoSec = ((now - qr.expiresAt) / 1000).ceil();
      return 'QR code expired ${agoSec}s ago. Ask warden to refresh.';
    }


    return null; // null = valid
  }

  // ── Hash ───────────────────────────────────────────────────────────────────

  /// SHA-256 of the raw TOTP value.
  /// This hash is what goes into the signed payload — not the raw value.
  static Future<String> hashTotp(String totpValue) async {
    final bytes = List<int>.from(totpValue.codeUnits);
    final hash  = await _sha256.hash(bytes);
    return hash.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static int msRemaining(QrPayload qr) =>
      (qr.expiresAt - SntpService.nowMs()).clamp(0, AppConstants.totpWindowSeconds * 1000);
}

class QrPayload {
  final String gateId;
  final String totpValue;
  final String nonce;
  final int    expiresAt; // Unix ms

  const QrPayload({
    required this.gateId,
    required this.totpValue,
    required this.nonce,
    required this.expiresAt,
  });
}
