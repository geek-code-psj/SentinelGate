/// All SentinelGate configuration constants.
/// Edit this file before deployment.
class AppConstants {

  // ── Server endpoints ──────────────────────────────────────────────────────
  /// Primary: Local campus intranet server (fast, used on campus WiFi)
  static const String intranetBaseUrl = 'http://192.168.1.100:3000/api/v1';

  /// Fallback: Cloud server (used on 4G when intranet is unreachable)
  static const String cloudBaseUrl = 'https://sentinelgate.yourdomain.com/api/v1';

  // ── Geofence ──────────────────────────────────────────────────────────────
  /// Default gate radius in metres. Server can override per gate.
  static const double defaultGateRadiusMeters = 50.0;

  /// GPS accuracy must be within this to pass geofence check.
  /// Prevents passing with a poor GPS fix.
  static const double maxAcceptableGpsAccuracy = 100.0;

  /// Demo toggle for weak/indoor GPS environments.
  /// Keep false for production deployment.
  static const bool demoLimitedGpsMode = true;

  /// Demo-only GPS accuracy cap (metres).
  static const double demoMaxAcceptableGpsAccuracy = 250.0;

  /// Demo-only extra radius (metres) added to each gate geofence.
  static const double demoRadiusPaddingMeters = 35.0;

  // ── Face / Liveness ───────────────────────────────────────────────────────
  /// Minimum composite liveness score (0.0–1.0) to pass PAD check
  static const double minLivenessScore = 0.65;

  /// Minimum eye open probability (both eyes)
  static const double minEyeOpenProb = 0.4;

  /// Max allowed head rotation (degrees) — beyond this = likely holding a photo
  static const double maxHeadYawDeg = 25.0;
  static const double maxHeadPitchDeg = 20.0;

  // ── TOTP / QR ─────────────────────────────────────────────────────────────
  /// QR token validity window in seconds (matches server rotation interval)
  static const int totpWindowSeconds = 30;

  /// QR format: sentinelgate://{gateId}/{totpToken}/{sessionNonce}
  static const String qrScheme = 'sentinelgate://';

  // ── Leave duration thresholds ─────────────────────────────────────────────
  /// If expected absence > this, warden approval doc is required
  static const int longLeaveThresholdHours = 5;

  // ── Sync ──────────────────────────────────────────────────────────────────
  static const int maxSyncRetries = 5;
  static const String syncTaskName = 'sg_background_sync';
  static const int syncIntervalMinutes = 15;

  // ── HMAC ──────────────────────────────────────────────────────────────────
  /// Server rejects requests with timestamp older than this (anti-replay)
  static const int hmacTimestampToleranceSeconds = 60;

  // ── Leave reasons ─────────────────────────────────────────────────────────
  static const List<String> leaveReasons = [
    'Market',
    'Home',
    'Medical',
    'Academic',
    'Sports',
    'Other',
  ];

  static const List<String> longLeaveReasons = ['Home'];
}
