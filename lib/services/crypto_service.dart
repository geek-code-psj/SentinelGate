import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'sntp_service.dart';

/// All cryptographic operations for SentinelGate.
///
/// Key storage: Android KeyStore via flutter_secure_storage AES-GCM.
/// The 256-bit device secret is provisioned ONCE at enrollment and is
/// NEVER transmitted over the network — ever.
///
/// Signing: HMAC-SHA256 over a canonical string:
///   METHOD\nPATH\nBODY_SHA256_HEX\nSNTP_TIMESTAMP_MS\nNONCE
///
/// The server reconstructs the same canonical string and verifies.
/// Any alteration to GPS coords, liveness score, etc. → signature mismatch.
class CryptoService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
  );

  static const _kSecret     = 'sg_device_secret_v1';
  static const _kStudentId  = 'sg_student_id';
  static const _kEnrolled   = 'sg_enrolled';
  static const _kHmacSecret = 'sg_hmac_secret';
  static const _kDeviceId  = 'sg_device_id';

  static final _hmac   = Hmac.sha256();
  static final _sha256 = Sha256();
  static final _rng    = Random.secure();

  // ── Enrollment ─────────────────────────────────────────────────────────────

  /// Generate and vault the device secret. Called ONCE at enrollment.
  static Future<void> provisionSecret() async {
    if (await _storage.read(key: _kSecret) != null) return;
    final bytes = List<int>.generate(32, (_) => _rng.nextInt(256));
    await _storage.write(key: _kSecret, value: base64Url.encode(bytes));
  }

  static Future<void> saveStudentId(String id) =>
      _storage.write(key: _kStudentId, value: id);

  static Future<String?> getStudentId() => _storage.read(key: _kStudentId);

  static Future<void> setEnrolled() =>
      _storage.write(key: _kEnrolled, value: 'true');

  static Future<bool> isEnrolled() async =>
      (await _storage.read(key: _kEnrolled)) == 'true';

  /// Save the HMAC secret received from server during enrollment
  static Future<void> saveHmacSecret(String secret) =>
      _storage.write(key: _kHmacSecret, value: secret);

  /// Get the HMAC secret (for signing requests)
  static Future<String?> getHmacSecret() => _storage.read(key: _kHmacSecret);

  /// Save the device ID received from server during enrollment
  static Future<void> saveDeviceId(String id) =>
      _storage.write(key: _kDeviceId, value: id);

  /// Get the device ID (for x-device-id header)
  static Future<String?> getDeviceId() => _storage.read(key: _kDeviceId);

  static Future<void> clearAll() => _storage.deleteAll();

  // ── HMAC-SHA256 Signing ────────────────────────────────────────────────────

  /// Signs a payload before it is transmitted to the server.
  ///
  /// Uses SNTP-corrected time — students cannot spoof the timestamp by
  /// changing their phone clock.
  static Future<SignedPayload> sign({
    required String method,       // 'POST', 'GET', etc.
    required String path,         // '/api/v1/events'
    required Map<String, dynamic> body,
  }) async {
    // 0. Get device ID for header
    final deviceId = await _storage.read(key: _kDeviceId);
    if (deviceId == null) throw StateError('Device not enrolled - no device ID');

    // 1. Hash body
    final bodyJson  = jsonEncode(body);
    final bodyHash  = await _sha256.hash(utf8.encode(bodyJson));
    final bodyHex   = _bytesToHex(bodyHash.bytes);

    // 2. SNTP timestamp — NOT phone time
    final timestamp = SntpService.nowMs().toString();

    // 3. Cryptographically random nonce (UUID v4)
    final nonce = const Uuid().v4();

    // 4. Canonical string — ordering is load-bearing; server must match exactly
    final canonical = '$method\n$path\n$bodyHex\n$timestamp\n$nonce';

    // 5. HMAC-SHA256 with server-provided secret
    final keyHex = await _storage.read(key: _kHmacSecret);
    if (keyHex == null) throw StateError('Device not enrolled - no HMAC secret');
    final key = SecretKey(utf8.encode(keyHex));  // Server sends hex string
    final mac = await _hmac.calculateMac(utf8.encode(canonical), secretKey: key);
    final sigHex = _bytesToHex(mac.bytes);

    return SignedPayload(
      deviceId : deviceId,
      signature : sigHex,
      timestamp : timestamp,
      nonce     : nonce,
      bodyHex   : bodyHex,
    );
  }

  // ── Hashing ────────────────────────────────────────────────────────────────

  /// SHA-256 of face landmark bytes.
  /// This is ALL that ever leaves the device for biometric purposes — not the image.
  static Future<String> hashBytes(List<int> bytes) async {
    final hash = await _sha256.hash(bytes);
    return _bytesToHex(hash.bytes);
  }

  static String _bytesToHex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

class SignedPayload {
  final String deviceId;
  final String signature;
  final String timestamp;  // SNTP-corrected Unix ms
  final String nonce;
  final String bodyHex;

  const SignedPayload({
    required this.deviceId,
    required this.signature,
    required this.timestamp,
    required this.nonce,
    required this.bodyHex,
  });

  /// HTTP headers appended to every authenticated request.
  Map<String, String> get headers => {
    'Content-Type'       : 'application/json',
    'x-device-id'        : deviceId,
    'x-request-sig'      : signature,
    'x-request-ts'       : timestamp,
    'x-request-nonce'    : nonce,
  };
}
