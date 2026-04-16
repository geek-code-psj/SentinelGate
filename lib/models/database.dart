import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TABLE DEFINITIONS
// ─────────────────────────────────────────────────────────────────────────────

/// Student profile stored on device after enrollment
class Students extends Table {
  TextColumn get id         => text()();           // College roll number
  TextColumn get name       => text()();
  TextColumn get department => text()();
  TextColumn get faceHash   => text()();           // SHA-256 of landmark embedding
  TextColumn get deviceId   => text()();           // Hardware device fingerprint
  TextColumn get enrolledAt => text()();           // ISO-8601
  BoolColumn get isActive   => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Core gate event — every exit and entry
class GateEvents extends Table {
  TextColumn get eventId            => text()();                                   // UUID v4
  TextColumn get studentId          => text()();
  TextColumn get status             => text()();                                   // OUT | IN
  TextColumn get reason             => text()();
  TextColumn get expectedReturnIso  => text().nullable()();
  IntColumn  get expectedDurationMs => integer().nullable()();                     // milliseconds
  BoolColumn get requiresApproval   => boolean().withDefault(const Constant(false))();
  TextColumn get approvalDocPath    => text().nullable()();                        // Local path only
  RealColumn get gpsLat             => real()();
  RealColumn get gpsLng             => real()();
  RealColumn get gpsAccuracy        => real()();
  TextColumn get gateId             => text()();
  TextColumn get geofenceId         => text().nullable()();                        // From QR
  TextColumn get trueTimestamp      => text()();                                   // SNTP-corrected UTC
  TextColumn get phoneTimestamp     => text()();                                   // Raw phone UTC
  IntColumn  get clockDeltaMs       => integer()();                                // Server delta applied
  RealColumn get faceConfidence     => real()();
  TextColumn get embeddingHash      => text().nullable()();                        // SHA-256 of face landmarks
  TextColumn get totpHash           => text().nullable()();                        // SHA-256 of TOTP value
  TextColumn get hmacSignature      => text()();
  TextColumn get nonce              => text()();
  TextColumn get syncStatus         => text().withDefault(const Constant('PENDING'))();
  // PENDING | SYNCED | FAILED | PENDING_APPROVAL | APPROVED
  IntColumn  get retryCount         => integer().withDefault(const Constant(0))();
  TextColumn get syncedAt           => text().nullable()();
  BoolColumn get isSpoofAttempt     => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {eventId};
}

/// Spoof attempt log (silent, sent to server later for security analysis)
class SpoofAttempts extends Table {
  TextColumn get attemptId     => text()();       // UUID
  TextColumn get studentId     => text().nullable()();
  TextColumn get gateId        => text().nullable()();
  TextColumn get failedStep    => text()();        // GPS | FACE | TOTP
  TextColumn get failureReason => text()();
  RealColumn get gpsLat        => real().nullable()();
  RealColumn get gpsLng        => real().nullable()();
  RealColumn get faceScore     => real().nullable()();
  TextColumn get timestamp     => text()();
  BoolColumn get synced        => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {attemptId};
}

/// Geofence zones downloaded from server (PostGIS polygons as centre+radius)
class GeofenceZones extends Table {
  TextColumn get zoneId       => text()();
  TextColumn get gateId       => text()();
  TextColumn get gateName     => text()();
  RealColumn get centerLat    => real()();
  RealColumn get centerLng    => real()();
  RealColumn get radiusMeters => real()();
  TextColumn get updatedAt    => text()();

  @override
  Set<Column> get primaryKey => {zoneId};
}

/// TOTP token cache (ephemeral — cleared after use or expiry)
class GateTokens extends Table {
  TextColumn get tokenId   => text()();
  TextColumn get gateId    => text()();
  TextColumn get tokenHash => text()();           // SHA-256 of raw TOTP
  TextColumn get nonce     => text()();           // Session nonce from QR
  TextColumn get expiresAt => text()();           // ISO-8601
  BoolColumn get used      => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {tokenId};
}

// ─────────────────────────────────────────────────────────────────────────────
// DATABASE
// ─────────────────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  Students,
  GateEvents,
  SpoofAttempts,
  GeofenceZones,
  GateTokens,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  // ── Student ───────────────────────────────────────────────────────────────

  Future<Student?> getStudent(String id) =>
      (select(students)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<void> upsertStudent(StudentsCompanion s) =>
      into(students).insertOnConflictUpdate(s);

  // ── Gate Events ───────────────────────────────────────────────────────────

  Future<void> insertGateEvent(GateEventsCompanion e) =>
      into(gateEvents).insert(e);

  Future<GateEvent?> getLatestEvent(String studentId) =>
      (select(gateEvents)
        ..where((e) => e.studentId.equals(studentId))
        ..orderBy([(e) => OrderingTerm.desc(e.trueTimestamp)])
        ..limit(1))
          .getSingleOrNull();

  Future<List<GateEvent>> getStudentHistory(String studentId, {int limit = 60}) =>
      (select(gateEvents)
        ..where((e) => e.studentId.equals(studentId))
        ..orderBy([(e) => OrderingTerm.desc(e.trueTimestamp)])
        ..limit(limit))
          .get();

  Future<List<GateEvent>> getPendingSync() =>
      (select(gateEvents)
        ..where((e) => e.syncStatus.isIn(['PENDING', 'FAILED']))
        ..where((e) => e.retryCount.isSmallerThanValue(5))
        ..orderBy([(e) => OrderingTerm.asc(e.trueTimestamp)]))
          .get();

  Future<void> markSynced(String eventId) =>
      (update(gateEvents)..where((e) => e.eventId.equals(eventId)))
          .write(GateEventsCompanion(
            syncStatus: const Value('SYNCED'),
            syncedAt: Value(DateTime.now().toUtc().toIso8601String()),
          ));

  Future<void> markFailed(String eventId, int retries) =>
      (update(gateEvents)..where((e) => e.eventId.equals(eventId)))
          .write(GateEventsCompanion(
            syncStatus: const Value('FAILED'),
            retryCount: Value(retries),
          ));

  Future<void> markPendingApproval(String eventId) =>
      (update(gateEvents)..where((e) => e.eventId.equals(eventId)))
          .write(const GateEventsCompanion(
            syncStatus: Value('PENDING_APPROVAL'),
          ));

  Future<void> setApprovalDocPath(String eventId, String docPath) =>
      (update(gateEvents)..where((e) => e.eventId.equals(eventId)))
          .write(GateEventsCompanion(
            approvalDocPath: Value(docPath),
          ));

  Future<void> markApproved(String eventId) =>
      (update(gateEvents)..where((e) => e.eventId.equals(eventId)))
          .write(GateEventsCompanion(
            syncStatus: const Value('APPROVED'),
            syncedAt: Value(DateTime.now().toUtc().toIso8601String()),
          ));

  // ── Spoof Attempts ────────────────────────────────────────────────────────

  Future<void> logSpoofAttempt(SpoofAttemptsCompanion attempt) =>
      into(spoofAttempts).insert(attempt);

  Future<List<SpoofAttempt>> getUnsyncedSpoofAttempts() =>
      (select(spoofAttempts)..where((a) => a.synced.equals(false))).get();

  Future<void> markSpoofSynced(String attemptId) =>
      (update(spoofAttempts)..where((a) => a.attemptId.equals(attemptId)))
          .write(const SpoofAttemptsCompanion(synced: Value(true)));

  // ── Geofence Zones ────────────────────────────────────────────────────────

  Future<List<GeofenceZone>> getAllZones() => select(geofenceZones).get();

  Future<GeofenceZone?> getZoneForGate(String gateId) =>
      (select(geofenceZones)..where((z) => z.gateId.equals(gateId)))
          .getSingleOrNull();

  Future<void> upsertZone(GeofenceZonesCompanion z) =>
      into(geofenceZones).insertOnConflictUpdate(z);

  Future<void> replaceAllZones(List<GeofenceZonesCompanion> zones) async {
    await transaction(() async {
      await delete(geofenceZones).go();
      for (final z in zones) {
        await into(geofenceZones).insert(z);
      }
    });
  }

  // ── Gate Tokens ───────────────────────────────────────────────────────────

  Future<void> cacheToken(GateTokensCompanion t) =>
      into(gateTokens).insertOnConflictUpdate(t);

  Future<GateToken?> getValidToken(String gateId) {
    final now = DateTime.now().toUtc().toIso8601String();
    return (select(gateTokens)
      ..where((t) =>
          t.gateId.equals(gateId) &
          t.used.equals(false) &
          t.expiresAt.isBiggerThanValue(now))
      ..limit(1))
        .getSingleOrNull();
  }

  Future<void> markTokenUsed(String tokenId) =>
      (update(gateTokens)..where((t) => t.tokenId.equals(tokenId)))
          .write(const GateTokensCompanion(used: Value(true)));

  Future<void> purgeExpiredTokens() async {
    final now = DateTime.now().toUtc().toIso8601String();
    await (delete(gateTokens)
      ..where((t) => t.expiresAt.isSmallerThanValue(now)))
        .go();
  }

  // ── Sync helpers ──────────────────────────────────────────────────────────

  Future<int> pendingSyncCount() async {
    final pending = await getPendingSync();
    return pending.length;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'sg_v1.db'));
    return NativeDatabase.createInBackground(file);
  });
}
