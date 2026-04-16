import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../models/database.dart';
import 'face_service.dart';
import 'geo_service.dart';
import 'totp_service.dart';
import 'crypto_service.dart';
import 'sntp_service.dart';
import 'spoof_log_service.dart';
import 'sync_service.dart';
import '../utils/constants.dart';

/// Orchestrates the complete 5-phase authentication state machine.
///
/// Phase 1 (QR capture)     → handled by checkout_screen before calling here
/// Phase 2 (Triple-Lock)    → GPS + Face run in parallel here
/// Phase 3 (Intent branch)  → long-leave detection, approval flag
/// Phase 4 (Crypto commit)  → HMAC sign + local SQLite write
/// Phase 5 (Dispatch)       → immediate sync attempt + WorkManager outbox
class GateEventService {
  final AppDatabase      db;
  final SpoofLogService  spoofLog;

  GateEventService(this.db) : spoofLog = SpoofLogService(db);

  // ── Main entry point ──────────────────────────────────────────────────────

  Future<EventResult> processExit({
    required String      studentId,
    required QrPayload   qr,
    required String      imagePath,
    required String      reason,
    DateTime?            expectedReturn,
  }) async {
    return _process(
      studentId      : studentId,
      qr             : qr,
      imagePath      : imagePath,
      status         : 'OUT',
      reason         : reason,
      expectedReturn : expectedReturn,
    );
  }

  Future<EventResult> processReturn({
    required String    studentId,
    required QrPayload qr,
    required String    imagePath,
  }) async {
    return _process(
      studentId : studentId,
      qr        : qr,
      imagePath : imagePath,
      status    : 'IN',
      reason    : 'Return',
    );
  }

  // ── State machine ─────────────────────────────────────────────────────────

  Future<EventResult> _process({
    required String    studentId,
    required QrPayload qr,
    required String    imagePath,
    required String    status,
    required String    reason,
    DateTime?          expectedReturn,
  }) async {

    // ── Phase 2A: TOTP expiry re-check (SNTP time) ────────────────────────
    final totpError = TotpService.validate(qr);
    if (totpError != null) {
      await spoofLog.log(
        studentId  : studentId,
        gateId     : qr.gateId,
        failedStep : 'TOTP',
        reason     : totpError,
      );
      return EventResult.fail(AuthPhase.totp, totpError);
    }

    // ── Phase 2B: GPS Geofence (runs first — cheapest check) ─────────────
    GeoFix gps;
    try {
      gps = await GeoService.getPosition();
    } catch (e) {
      return EventResult.fail(AuthPhase.gps, e.toString());
    }

    final zone = await db.getZoneForGate(qr.gateId);
    if (zone == null) {
      return EventResult.fail(AuthPhase.gps,
          'Gate zone not downloaded. Open the app on campus Wi-Fi first.');
    }

    final geoCheck = GeoService.checkZone(
      lat        : gps.lat,
      lng        : gps.lng,
      accuracy   : gps.accuracy,
      zoneLat    : zone.centerLat,
      zoneLng    : zone.centerLng,
      zoneRadius : zone.radiusMeters,
    );

    if (!geoCheck.inside) {
      await spoofLog.log(
        studentId  : studentId,
        gateId     : qr.gateId,
        failedStep : 'GPS',
        reason     : geoCheck.message,
        gpsLat     : gps.lat,
        gpsLng     : gps.lng,
      );
      return EventResult.fail(AuthPhase.gps, geoCheck.message);
    }

    // ── Phase 2C: Face Liveness PAD ───────────────────────────────────────
    final face = await FaceService.analyse(imagePath);

    if (!face.passed) {
      await spoofLog.log(
        studentId  : studentId,
        gateId     : qr.gateId,
        failedStep : 'FACE',
        reason     : face.failMessage ?? 'Liveness failed',
        gpsLat     : gps.lat,
        gpsLng     : gps.lng,
        faceScore  : face.livenessScore,
      );
      return EventResult.fail(AuthPhase.face, face.displayMessage);
    }

    // ── Phase 3: Intent Branch — short vs. long leave ─────────────────────
    bool   requiresApproval   = false;
    int?   expectedDurationMs;
    String? expectedReturnIso;

    if (status == 'OUT' && expectedReturn != null) {
      final now            = SntpService.now();
      expectedDurationMs   = expectedReturn.difference(now).inMilliseconds;
      expectedReturnIso    = expectedReturn.toUtc().toIso8601String();

      final hours          = expectedDurationMs / (1000 * 60 * 60);
      if (hours > AppConstants.longLeaveThresholdHours) {
        requiresApproval = true;
        // Caller must handle APPROVAL_REQUIRED state and collect document
      }
    }

    // ── Phase 4: Cryptographic signing + local DB write ───────────────────
    final eventId   = const Uuid().v4();
    final trueNow   = SntpService.nowIso();
    final phoneNow  = DateTime.now().toUtc().toIso8601String();
    final deltaMs   = SntpService.deltaMs;
    final totpHashVal  = await TotpService.hashTotp(qr.totpValue);

    final payload = {
      'event_id'          : eventId,
      'student_id'        : studentId,
      'status'            : status,
      'reason'            : reason,
      'expected_return'   : expectedReturnIso,
      'expected_duration' : expectedDurationMs,
      'requires_approval' : requiresApproval,
      'gps_lat'           : gps.lat,
      'gps_lng'           : gps.lng,
      'gps_accuracy'      : gps.accuracy,
      'geofence_id'       : qr.geofenceId,
      'gate_id'           : qr.gateId,
      'totp_value'        : totpHashVal,
      'totp_window'       : 30,
      'true_timestamp'    : trueNow,
      'clock_delta_ms'    : deltaMs,
      'embedding_hash'    : face.embeddingHash,
      'liveness_score'    : face.livenessScore,
    };

    final signed = await CryptoService.sign(
      method : 'POST',
      path   : '/auth/event',
      body   : payload,
    );

    // Write to local DB immediately — UI goes green before network call
    await db.insertGateEvent(GateEventsCompanion(
      eventId           : Value(eventId),
      studentId         : Value(studentId),
      status            : Value(status),
      reason            : Value(reason),
      expectedReturnIso : Value(expectedReturnIso),
      expectedDurationMs: Value(expectedDurationMs),
      requiresApproval  : Value(requiresApproval),
      gpsLat            : Value(gps.lat),
      gpsLng            : Value(gps.lng),
      gpsAccuracy       : Value(gps.accuracy),
      gateId            : Value(qr.gateId),
      geofenceId        : Value(qr.geofenceId),
      trueTimestamp     : Value(trueNow),
      phoneTimestamp    : Value(phoneNow),
      clockDeltaMs      : Value(deltaMs),
      faceConfidence    : Value(face.livenessScore),
      embeddingHash     : Value(face.embeddingHash),
      totpHash          : Value(totpHashVal),
      hmacSignature     : Value(signed.signature),
      nonce             : Value(signed.nonce),
      syncStatus        : Value(requiresApproval ? 'PENDING_APPROVAL' : 'PENDING'),
    ));

    // ── Phase 5: Network dispatch (fire-and-forget; WorkManager is backup) ─
    if (!requiresApproval) {
      SyncService.trySyncNow(eventId).catchError((_) {});
    }

    return EventResult.success(
      eventId          : eventId,
      requiresApproval : requiresApproval,
      livenessScore    : face.livenessScore,
      gpsDistance      : geoCheck.distance,
      gpsAccuracy      : gps.accuracy,
      clockDeltaMs     : deltaMs,
    );
  }
}

// ── Result types ──────────────────────────────────────────────────────────────

enum AuthPhase { totp, gps, face, crypto, db }

class EventResult {
  final bool      success;
  final String?   eventId;
  final bool      requiresApproval;
  final double    livenessScore;
  final double    gpsDistance;
  final double    gpsAccuracy;
  final int       clockDeltaMs;
  final AuthPhase? failedPhase;
  final String?    failMessage;

  const EventResult._({
    required this.success,
    this.eventId,
    this.requiresApproval = false,
    this.livenessScore    = 0,
    this.gpsDistance      = 0,
    this.gpsAccuracy      = 0,
    this.clockDeltaMs     = 0,
    this.failedPhase,
    this.failMessage,
  });

  factory EventResult.success({
    required String eventId,
    required bool   requiresApproval,
    required double livenessScore,
    required double gpsDistance,
    required double gpsAccuracy,
    required int    clockDeltaMs,
  }) => EventResult._(
    success          : true,
    eventId          : eventId,
    requiresApproval : requiresApproval,
    livenessScore    : livenessScore,
    gpsDistance      : gpsDistance,
    gpsAccuracy      : gpsAccuracy,
    clockDeltaMs     : clockDeltaMs,
  );

  factory EventResult.fail(AuthPhase phase, String message) => EventResult._(
    success      : false,
    failedPhase  : phase,
    failMessage  : message,
  );
}
