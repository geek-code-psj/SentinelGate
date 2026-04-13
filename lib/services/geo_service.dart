import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import '../utils/constants.dart';

/// GPS geofence validation.
/// All checks run entirely on-device using downloaded zone boundaries.
/// The raw GPS coordinates are included in the signed payload sent to server.
class GeoService {

  // ── Permissions ─────────────────────────────────────────────────────────────

  static Future<GeoPermStatus> requestPermissions() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return GeoPermStatus.serviceDisabled;
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever) return GeoPermStatus.deniedForever;
    if (perm == LocationPermission.denied)        return GeoPermStatus.denied;
    return GeoPermStatus.granted;
  }

  // ── Position ─────────────────────────────────────────────────────────────────

  /// Fetch current position. High accuracy. 10-second timeout.
  static Future<GeoFix> getPosition() async {
    try {
      final pos = await Geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(const Duration(seconds: 10));
      return GeoFix(
        lat      : pos.latitude,
        lng      : pos.longitude,
        accuracy : pos.accuracy,
        time     : pos.timestamp,
      );
    } on LocationServiceDisabledException {
      throw const GeoException('Location services are off. Enable GPS and retry.');
    } on PermissionDeniedException {
      throw const GeoException('Location permission denied.');
    } on TimeoutException {
      throw const GeoException('GPS fix timed out. Move to an open area and retry.');
    } catch (e) {
      throw GeoException('GPS fix failed. Move to open area: $e');
    }
  }

  // ── Geofence check ───────────────────────────────────────────────────────────

  /// Point-in-circle check using Haversine formula.
  ///
  /// Rejects if GPS accuracy is worse than 2× zone radius —
  /// this prevents a student in the dormitory (200m away) from passing
  /// by relying on a wide GPS uncertainty cone.
  static GeoCheck checkZone({
    required double lat,
    required double lng,
    required double accuracy,
    required double zoneLat,
    required double zoneLng,
    required double zoneRadius,
  }) {
    final isDemoMode = AppConstants.demoLimitedGpsMode;
    final maxAccuracy = isDemoMode
        ? AppConstants.demoMaxAcceptableGpsAccuracy
        : AppConstants.maxAcceptableGpsAccuracy;
    final effectiveRadius = isDemoMode
        ? (zoneRadius + AppConstants.demoRadiusPaddingMeters)
        : zoneRadius;

    // Reject grossly inaccurate fixes
    if (accuracy > maxAccuracy) {
      return GeoCheck(
        inside   : false,
        distance : -1,
        message  : isDemoMode
            ? 'GPS still too inaccurate for demo (±${accuracy.toStringAsFixed(0)}m). '
              'Move slightly outdoors and retry.'
            : 'GPS too inaccurate (±${accuracy.toStringAsFixed(0)}m). '
              'Move to open sky and retry.',
      );
    }

    final d = _haversine(lat, lng, zoneLat, zoneLng);

    return GeoCheck(
      inside   : d <= effectiveRadius,
      distance : d,
      message  : d <= effectiveRadius
          ? isDemoMode
              ? 'Within demo gate zone (${d.toStringAsFixed(0)}m)'
              : 'Within gate zone (${d.toStringAsFixed(0)}m)'
          : 'Too far from gate (${d.toStringAsFixed(0)}m). '
            'You must be within ${effectiveRadius.toStringAsFixed(0)}m.',
    );
  }

  static double _haversine(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0;
    final dLat = _rad(lat2 - lat1);
    final dLng = _rad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
              cos(_rad(lat1)) * cos(_rad(lat2)) *
              sin(dLng / 2) * sin(dLng / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  static double _rad(double deg) => deg * pi / 180.0;
}

enum GeoPermStatus { granted, denied, deniedForever, serviceDisabled }

class GeoFix {
  final double   lat;
  final double   lng;
  final double   accuracy;
  final DateTime time;
  const GeoFix({required this.lat, required this.lng,
                required this.accuracy, required this.time});
}

class GeoCheck {
  final bool   inside;
  final double distance;
  final String message;
  const GeoCheck({required this.inside, required this.distance, required this.message});
}

class GeoException implements Exception {
  final String message;
  const GeoException(this.message);
  @override
  String toString() => message;
}
