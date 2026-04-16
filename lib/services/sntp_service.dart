import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

/// SNTP Clock Synchronisation Service.
///
/// Why: Students can set phone time forward/backward to generate a valid TOTP
/// at the wrong moment, or to slip outside the 60-second HMAC window.
///
/// Fix: On every app open and every WorkManager tick, we fetch the server's
/// UTC millisecond timestamp. We compute:
///   clockDeltaMs = serverNow - phoneNow   (corrected for round-trip latency)
///   trueTime = DateTime.now() + Duration(milliseconds: clockDeltaMs)
///
/// All timestamps that go into signed payloads use [SntpService.now()].
class SntpService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const _kDelta    = 'sg_clock_delta_ms';
  static const _kLastSync = 'sg_clock_last_sync';
  static const _maxStalenessMs = 15 * 60 * 1000; // 15 minutes
  static const List<String> _timePaths = [
    '/sync/time',
    '/time',
    '/health',
  ];

  static int  _deltaMs = 0;
  static bool _synced  = false;

  /// Returns server-corrected UTC now.
  static DateTime now() =>
      DateTime.now().toUtc().add(Duration(milliseconds: _deltaMs));

  /// Unix milliseconds — used inside HMAC canonical strings.
  static int nowMs() => now().millisecondsSinceEpoch;

  /// ISO-8601 UTC string — stored in DB and sent to server.
  static String nowIso() => now().toIso8601String();

  static int  get deltaMs  => _deltaMs;
  static bool get isSynced => _synced;

  // ── Sync ──────────────────────────────────────────────────────────────────

  /// Try intranet first, fall back to cloud.
  /// Called from Phase 0 (background sync) and on every app launch.
  static Future<SntpResult> sync() async {
    var result = await _syncFrom(AppConstants.intranetBaseUrl);
    if (!result.success) {
      result = await _syncFrom(AppConstants.cloudBaseUrl);
    }
    if (!result.success) {
      result = await _syncFrom(AppConstants.backendRootUrl);
    }
    if (!result.success) {
      result = await _loadCache();
    }
    return result;
  }

  static Future<SntpResult> _syncFrom(String baseUrl) async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ));
      final root = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

      for (final path in _timePaths) {
        final t1 = DateTime.now().millisecondsSinceEpoch;
        final res = await dio.get('$root$path');
        final t4 = DateTime.now().millisecondsSinceEpoch;

        if (res.statusCode != 200) {
          continue;
        }

        final serverMs = _parseServerMs(res.data);
        if (serverMs == null) {
          continue;
        }

        final rtt = t4 - t1;
        final delta = (serverMs + rtt ~/ 2) - t4;

        _deltaMs = delta;
        _synced = true;

        await _storage.write(key: _kDelta, value: delta.toString());
        await _storage.write(key: _kLastSync, value: t4.toString());

        debugPrint('[SNTP] Synced via $path (delta=${delta}ms, rtt=${rtt}ms)');
        return SntpResult(success: true, deltaMs: delta, rttMs: rtt);
      }

      return SntpResult.fail('No valid server time response: $baseUrl');
    } catch (_) {
      return SntpResult.fail('Unreachable: $baseUrl');
    }
  }

  static int? _parseServerMs(dynamic data) {
    if (data is! Map) return null;

    final asMap = Map<String, dynamic>.from(data);
    final msValue = asMap['server_utc_ms'] ?? asMap['serverUtcMs'];
    if (msValue is num) return msValue.toInt();
    if (msValue is String) {
      final parsed = int.tryParse(msValue);
      if (parsed != null) return parsed;
    }

    final iso = asMap['ts'] ?? asMap['timestamp'] ?? asMap['server_time'];
    if (iso is String) {
      final dt = DateTime.tryParse(iso);
      if (dt != null) return dt.toUtc().millisecondsSinceEpoch;
    }

    return null;
  }

  static Future<SntpResult> _loadCache() async {
    final deltaStr    = await _storage.read(key: _kDelta);
    final lastSyncStr = await _storage.read(key: _kLastSync);
    if (deltaStr == null || lastSyncStr == null) {
      _deltaMs = 0; _synced = false;
      return SntpResult.fail('No cache — using phone time');
    }
    final age = DateTime.now().millisecondsSinceEpoch - int.parse(lastSyncStr);
    _deltaMs  = int.parse(deltaStr);
    _synced   = age < _maxStalenessMs;
    return SntpResult(success: _synced, deltaMs: _deltaMs, rttMs: 0, fromCache: true);
  }

  /// Load persisted delta at startup before network is available.
  static Future<void> loadCached() => _loadCache();
}

class SntpResult {
  final bool   success;
  final int    deltaMs;
  final int    rttMs;
  final bool   fromCache;
  final String? error;
  const SntpResult({
    required this.success,
    required this.deltaMs,
    required this.rttMs,
    this.fromCache = false,
    this.error,
  });
  factory SntpResult.fail(String e) =>
      SntpResult(success: false, deltaMs: 0, rttMs: 0, error: e);
}
