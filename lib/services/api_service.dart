import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../models/database.dart';
import '../utils/constants.dart';
import 'crypto_service.dart';

/// Handles all server communication.
///
/// Priority order:
///   1. Campus intranet (fast, low-latency, no data charges)
///   2. Cloud server over 4G/5G (fallback when off-campus or intranet down)
///   3. Offline SQLite outbox (fallback when both unreachable)
///
/// Every request carries HMAC-SHA256 signature headers.
class ApiService {
  static Dio? _intranet;
  static Dio? _cloud;

  static Dio get _intra => _intranet ??= _makeDio(AppConstants.intranetBaseUrl);
  static Dio get _cld   => _cloud    ??= _makeDio(AppConstants.cloudBaseUrl);

  static Dio _makeDio(String base) => Dio(BaseOptions(
    baseUrl        : base,
    connectTimeout : const Duration(seconds: 8),
    receiveTimeout : const Duration(seconds: 20),
    headers        : {'Accept': 'application/json'},
  ));

  // ── Device Enrollment ───────────────────────────────────────────────────────

  /// Call backend to enroll this device and get HMAC secret.
  static Future<ApiResult> enrollDevice({
    required String rollNumber,
    required String deviceFingerprint,
    required String platform,
    required String model,
  }) async {
    final body = {
      'roll_number': rollNumber,
      'device_fingerprint': deviceFingerprint,
      'platform': platform,
      'model': model,
    };

    // Enrollment does NOT require HMAC signature (no secret yet)
    try {
      var res = await _intra.post('/auth/enroll', data: jsonEncode(body));
      if (res.statusCode == 200 || res.statusCode == 201) return ApiResult.ok(res.data);
      res = await _cld.post('/auth/enroll', data: jsonEncode(body));
      if (res.statusCode == 200 || res.statusCode == 201) return ApiResult.ok(res.data);
      return ApiResult.err('Enrollment failed: ${res.statusCode}');
    } on DioException catch (e) {
      return ApiResult.err(_dioMsg(e));
    }
  }

  // ── Gate Event Upload ──────────────────────────────────────────────────────

  static Future<ApiResult> uploadEvent(GateEvent e) async {
    final body = _eventBody(e);
    final signed = await CryptoService.sign(method: 'POST', path: '/auth/event', body: body);

    // Try intranet first, then cloud
    var result = await _post(_intra, '/auth/event', body, signed.headers);
    if (!result.ok) result = await _post(_cld, '/auth/event', body, signed.headers);
    return result;
  }

  // ── Spoof Attempt Upload ───────────────────────────────────────────────────

  static Future<ApiResult> uploadSpoofAttempt(SpoofAttempt a) async {
    final body   = _spoofBody(a);
    final signed = await CryptoService.sign(method: 'POST', path: '/sync/spoof', body: body);
    var result   = await _post(_intra, '/sync/spoof', body, signed.headers);
    if (!result.ok) result = await _post(_cld, '/sync/spoof', body, signed.headers);
    return result;
  }

  // ── Geofence Zones Fetch ───────────────────────────────────────────────────

  static Future<ApiResult> fetchZones({String? since}) async {
    // Call /sync/delta to get geofences and gate modes
    final path = since != null ? '/sync/delta?since=$since' : '/sync/delta';
    final signed = await CryptoService.sign(method: 'GET', path: path, body: {});
    var result = await _get(_intra, path, signed.headers);
    if (!result.ok) result = await _get(_cld, path, signed.headers);
    return result;
  }

  // ── Server Time Endpoint ───────────────────────────────────────────────────

  static Future<ApiResult> fetchTime() async {
    var result = await _get(_intra, '/sync/time', {});
    if (!result.ok) result = await _get(_cld, '/sync/time', {});
    return result;
  }

  // ── Leave Request (Phase 3) ─────────────────────────────────────────────────

  static Future<ApiResult> submitLeaveRequest({
    required String gateId,
    required String reason,
    required int expectedReturnTs,
    String? approvalDocB64,
  }) async {
    final body = {
      'gate_id': gateId,
      'reason': reason,
      'expected_return_ts': expectedReturnTs,
      if (approvalDocB64 != null) 'approval_doc_b64': approvalDocB64,
    };
    final signed = await CryptoService.sign(method: 'POST', path: '/leave/request', body: body);
    var result = await _post(_intra, '/leave/request', body, signed.headers);
    if (!result.ok) result = await _post(_cld, '/leave/request', body, signed.headers);
    return result;
  }

  // ── Leave Status Polling ───────────────────────────────────────────────────

  static Future<ApiResult> pollLeaveStatus(String leaveId) async {
    final signed = await CryptoService.sign(method: 'GET', path: '/leave/status/$leaveId', body: {});
    var result = await _get(_intra, '/leave/status/$leaveId', signed.headers);
    if (!result.ok) result = await _get(_cld, '/leave/status/$leaveId', signed.headers);
    return result;
  }

  // ── Warden Approval Document Upload ─────────────────────────────────────────

  static Future<ApiResult> uploadApprovalDoc({
    required String leaveId,
    required List<int> docBytes,
    required String mimeType,
  }) async {
    final body = {
      'approval_doc_b64': base64Encode(docBytes),
    };
    final signed = await CryptoService.sign(
      method: 'POST',
      path: '/leave/upload-doc/$leaveId',
      body: body,
    );
    var result = await _post(_intra, '/leave/upload-doc/$leaveId', body, signed.headers);
    if (!result.ok) result = await _post(_cld, '/leave/upload-doc/$leaveId', body, signed.headers);
    return result;
  }

  // ── HTTP helpers ──────────────────────────────────────────────────────────

  static Future<ApiResult> _post(
    Dio dio, String path, Map<String, dynamic> body, Map<String, String> headers,
  ) async {
    try {
      final r = await dio.post(path,
          data: jsonEncode(body),
          options: Options(headers: headers));
      if (r.statusCode == 200 || r.statusCode == 201) return ApiResult.ok(r.data);
      return ApiResult.err('HTTP ${r.statusCode}');
    } on DioException catch (e) {
      return ApiResult.err(_dioMsg(e));
    }
  }

  static Future<ApiResult> _get(
    Dio dio, String path, Map<String, String> headers,
  ) async {
    try {
      final r = await dio.get(path, options: Options(headers: headers));
      if (r.statusCode == 200) return ApiResult.ok(r.data);
      return ApiResult.err('HTTP ${r.statusCode}');
    } on DioException catch (e) {
      return ApiResult.err(_dioMsg(e));
    }
  }

  static String _dioMsg(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout';
      case DioExceptionType.connectionError:
        return 'Unreachable';
      default:
        if (e.response?.statusCode == 401) return 'HMAC rejected';
        if (e.response?.statusCode == 409) return 'Replay detected';
        return e.message ?? 'Unknown error';
    }
  }

  // ── Payload builders ──────────────────────────────────────────────────────

  static Map<String, dynamic> _eventBody(GateEvent e) => {
    'event_id'          : e.eventId,
    'student_id'        : e.studentId,
    'status'            : e.status,
    'reason'            : e.reason,
    'expected_return'   : e.expectedReturnIso,
    'expected_duration' : e.expectedDurationMs,
    'requires_approval' : e.requiresApproval,
    'gps'               : {
      'lat'      : e.gpsLat,
      'lng'      : e.gpsLng,
      'accuracy' : e.gpsAccuracy,
    },
    'gate_id'           : e.gateId,
    'true_timestamp'    : e.trueTimestamp,
    'clock_delta_ms'    : e.clockDeltaMs,
    'biometric'         : {'liveness_score': e.faceConfidence},
    'integrity'         : {'hmac': e.hmacSignature, 'nonce': e.nonce},
  };

  static Map<String, dynamic> _spoofBody(SpoofAttempt a) => {
    'attempt_id'   : a.attemptId,
    'student_id'   : a.studentId,
    'gate_id'      : a.gateId,
    'failed_step'  : a.failedStep,
    'reason'       : a.failureReason,
    'gps'          : {'lat': a.gpsLat, 'lng': a.gpsLng},
    'face_score'   : a.faceScore,
    'timestamp'    : a.timestamp,
  };
}

class ApiResult {
  final bool    ok;
  final dynamic data;
  final String? error;
  const ApiResult._({required this.ok, this.data, this.error});
  factory ApiResult.ok(dynamic d)  => ApiResult._(ok: true,  data: d);
  factory ApiResult.err(String e)  => ApiResult._(ok: false, error: e);
}
