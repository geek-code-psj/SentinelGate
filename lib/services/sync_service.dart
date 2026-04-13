import 'dart:math';
import 'package:drift/drift.dart';
import '../models/database.dart';
import '../utils/constants.dart';
import 'api_service.dart';
import 'sntp_service.dart';

/// Transactional Outbox background sync.
///
/// Flow:
///   1. Gate event written to local SQLite immediately (offline-safe).
///   2. WorkManager fires this service every 15 min (or immediately on network restore).
///   3. All PENDING / FAILED events are uploaded with exponential backoff.
///   4. On success → SYNCED. On failure → FAILED + retryCount++.
///   5. After [maxRetries], event is abandoned (still stored locally).
///
/// LWW Conflict Resolution:
///   If two conflicting events exist (offline + reconnected scenario),
///   the backend uses the SNTP-corrected [trueTimestamp] to determine
///   which event wins — Last-Write-Wins based on cryptographic time.
class SyncService {
  static const syncTaskName = AppConstants.syncTaskName;

  static AppDatabase? _db;
  static AppDatabase get db => _db ??= AppDatabase();

  // ── Phase 0: Background sync (called by WorkManager) ──────────────────────

  static Future<void> runBackgroundSync() async {
    // Phase 0a: Refresh SNTP delta
    await SntpService.sync();

    // Phase 0b: Upload pending gate events
    await _syncEvents();

    // Phase 0c: Upload pending spoof logs
    await _syncSpoofLogs();

    // Phase 0d: Refresh geofence zones (delta sync)
    await _refreshZones();
  }

  // ── Event upload ──────────────────────────────────────────────────────────

  static Future<void> _syncEvents() async {
    final pending = await db.getPendingSync();
    for (final event in pending) {
      await _uploadEvent(event);
    }
  }

  static Future<void> _uploadEvent(GateEvent event) async {
    // Exponential backoff: 2^retries seconds, max 30s
    if (event.retryCount > 0) {
      final delay = Duration(seconds: min(pow(2, event.retryCount).toInt(), 30));
      await Future.delayed(delay);
    }

    final result = await ApiService.uploadEvent(event);

    if (result.ok) {
      await db.markSynced(event.eventId);
    } else {
      await db.markFailed(event.eventId, event.retryCount + 1);
    }
  }

  // ── Spoof log upload ──────────────────────────────────────────────────────

  static Future<void> _syncSpoofLogs() async {
    final unsynced = await db.getUnsyncedSpoofAttempts();
    for (final attempt in unsynced) {
      final result = await ApiService.uploadSpoofAttempt(attempt);
      if (result.ok) await db.markSpoofSynced(attempt.attemptId);
    }
  }

  // ── Geofence zone refresh ─────────────────────────────────────────────────

  static Future<void> _refreshZones() async {
    final result = await ApiService.fetchZones();
    if (!result.ok || result.data == null) return;

    final list = (result.data['zones'] as List? ?? []);
    final companions = list.map((z) => GeofenceZonesCompanion(
      zoneId       : Value(z['zone_id']  as String),
      gateId       : Value(z['gate_id']  as String),
      gateName     : Value(z['gate_name'] as String),
      centerLat    : Value((z['lat'] as num).toDouble()),
      centerLng    : Value((z['lng'] as num).toDouble()),
      radiusMeters : Value((z['radius_m'] as num).toDouble()),
      updatedAt    : Value(z['updated_at'] as String),
    )).toList();

    if (companions.isNotEmpty) await db.replaceAllZones(companions);
  }

  // ── Immediate sync (called after each event is written) ───────────────────

  static Future<void> trySyncNow(String eventId) async {
    final pending = await db.getPendingSync();
    final event   = pending.where((e) => e.eventId == eventId).firstOrNull;
    if (event != null) await _uploadEvent(event);
  }

  // ── Utility ───────────────────────────────────────────────────────────────

  static Future<int> pendingCount() => db.pendingSyncCount();
}
