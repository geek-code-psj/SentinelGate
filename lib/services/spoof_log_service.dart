import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../models/database.dart';
import 'sntp_service.dart';

/// Silently logs failed authentication attempts to local DB.
///
/// Per the spec: "If either fails, the app halts the UI but silently logs
/// a 'Spoof Attempt' to the local database to be sent to the backend later."
///
/// This data feeds the ST-GNN anomaly detection backend for identifying
/// coordinated proxy fraud rings.
class SpoofLogService {
  final AppDatabase db;
  const SpoofLogService(this.db);

  Future<void> log({
    String?  studentId,
    String?  gateId,
    required String failedStep,    // 'GPS' | 'FACE' | 'TOTP' | 'HMAC'
    required String reason,
    double?  gpsLat,
    double?  gpsLng,
    double?  faceScore,
  }) async {
    await db.logSpoofAttempt(SpoofAttemptsCompanion(
      attemptId    : Value(const Uuid().v4()),
      studentId    : Value(studentId),
      gateId       : Value(gateId),
      failedStep   : Value(failedStep),
      failureReason: Value(reason),
      gpsLat       : Value(gpsLat),
      gpsLng       : Value(gpsLng),
      faceScore    : Value(faceScore),
      timestamp    : Value(SntpService.nowIso()),
      synced       : const Value(false),
    ));
  }
}
