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
    if (!raw.startsWith(AppConstants.qrScheme)) return null;

    final path   = raw.substring(AppConstants.qrScheme.length);
    final parts  = path.split('/');
    if (parts.length < 4) return null;

    final gateId     = parts[0];
    final totpValue  = parts[1];
    final nonce      = parts[2];
    final expiresAt  = int.tryParse(parts[3]);

    if (gateId.isEmpty || totpValue.isEmpty || nonce.isEmpty || expiresAt == null) {
      return null;
    }

    return QrPayload(
      gateId    : gateId,
      totpValue : totpValue,
      nonce     : nonce,
      expiresAt : expiresAt,
    );
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

    // Warn if token is about to expire (< 5 seconds left)
    final remaining = qr.expiresAt - now;
    if (remaining < 5000) {
      return 'QR code expires in ${(remaining / 1000).ceil()}s. '
             'Proceed quickly or ask warden to refresh.';
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
