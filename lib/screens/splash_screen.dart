import 'package:flutter/material.dart';
import '../services/crypto_service.dart';
import '../services/sntp_service.dart';
import '../services/sync_service.dart';
import '../utils/app_theme.dart';

/// Phase 0: Background sync fires here on every app launch.
///  1. Load cached SNTP delta (instant — from secure storage)
///  2. Check enrollment
///  3. Background sync: refresh SNTP, pull zones, push pending events
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _fade;
  String _status = 'Initialising...';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    _boot();
  }

  Future<void> _boot() async {
    // Phase 0a: Load cached clock delta immediately (no network needed)
    _setStatus('Syncing clock...');
    await SntpService.loadCached();

    // Try a fresh SNTP sync before showing the dashboard.
    // If the network is slow/unavailable, fall back to cached delta.
    try {
      await SntpService.sync().timeout(const Duration(seconds: 8));
    } catch (_) {
      // Keep the cached/device time path; user can still proceed.
    }

    // Phase 0b: Check enrollment
    final enrolled = await CryptoService.isEnrolled();
    if (!enrolled) {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // Phase 0c: Background sync (non-blocking; failures are silent)
    _setStatus('Syncing data...');
    SyncService.runBackgroundSync().catchError((_) {});

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.pushReplacementNamed(context, '/face-gate');
  }

  void _setStatus(String s) {
    if (mounted) setState(() => _status = s);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_outlined, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text('SentinelGate',
                style: TextStyle(color: Colors.white, fontSize: 28,
                    fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 6),
              const Text('Campus Security System',
                style: TextStyle(color: Colors.white60, fontSize: 13)),
              const SizedBox(height: 48),
              const SizedBox(width: 24, height: 24,
                child: CircularProgressIndicator(color: Colors.white54, strokeWidth: 2)),
              const SizedBox(height: 16),
              Text(_status,
                style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
