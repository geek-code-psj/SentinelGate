import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../services/crypto_service.dart';
import '../services/face_service.dart';
import '../utils/app_theme.dart';

class StartupFaceGateScreen extends StatefulWidget {
  const StartupFaceGateScreen({super.key});

  @override
  State<StartupFaceGateScreen> createState() => _StartupFaceGateScreenState();
}

class _StartupFaceGateScreenState extends State<StartupFaceGateScreen> {
  CameraController? _cam;
  bool _camReady = false;
  bool _busy = false;
  bool _hasBaseline = false;
  String? _msg;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    _hasBaseline = await CryptoService.hasFaceBaseline();
    await FaceService.init();
    final cams = await availableCameras();
    if (cams.isEmpty) {
      if (mounted) {
        setState(() => _msg = 'No camera found on this device.');
      }
      return;
    }

    final front = cams.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cams.first,
    );

    _cam = CameraController(front, ResolutionPreset.medium, enableAudio: false);
    await _cam!.initialize();
    if (mounted) {
      setState(() => _camReady = true);
    }
  }

  Future<void> _capture() async {
    if (!_camReady || _busy) return;
    setState(() {
      _busy = true;
      _msg = null;
    });

    try {
      final file = await _cam!.takePicture();
      final result = await FaceService.analyse(file.path);
      if (!result.passed) {
        setState(() {
          _busy = false;
          _msg = result.displayMessage;
        });
        return;
      }

      final template = result.embeddingTemplate;
      if (template == null || template.isEmpty) {
        setState(() {
          _busy = false;
          _msg = 'Could not read enough face landmarks. Try again.';
        });
        return;
      }

      if (!_hasBaseline) {
        await CryptoService.saveFaceTemplate(template);
        await CryptoService.saveFaceBaselineHash(result.embeddingHash ?? '');
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }

      final baseline = await CryptoService.getFaceTemplate();
      if (baseline == null || baseline.isEmpty) {
        await CryptoService.saveFaceTemplate(template);
        await CryptoService.saveFaceBaselineHash(result.embeddingHash ?? '');
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }

      final dist = _templateDistance(template, baseline);
      final matched = dist <= 0.12;

      if (!matched) {
        setState(() {
          _busy = false;
          _msg = 'Face did not match enrolled profile. Please align and retry.';
        });
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        _busy = false;
        _msg = 'Face check failed: $e';
      });
    }
  }

  double _templateDistance(List<double> a, List<double> b) {
    final n = min(a.length, b.length);
    double sum = 0;
    int used = 0;

    for (int i = 0; i < n; i++) {
      if (a[i] < 0 || b[i] < 0) continue;
      final d = a[i] - b[i];
      sum += d * d;
      used++;
    }

    if (used < 6) return 999;
    return sqrt(sum / used);
  }

  @override
  void dispose() {
    _cam?.dispose();
    FaceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _hasBaseline ? 'Face Verification' : 'Face Enrollment';
    final sub = _hasBaseline
        ? 'Verify your face to open SentinelGate.'
        : 'Capture your face once to create local baseline.';

    return Scaffold(
      appBar: AppBar(title: const Text('SentinelGate')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(sub, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 18),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _camReady
                      ? CameraPreview(_cam!)
                      : const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              if (_msg != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(_msg!,
                      style: const TextStyle(color: AppTheme.danger, fontSize: 13)),
                ),
              ElevatedButton.icon(
                onPressed: _camReady && !_busy ? _capture : null,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.face),
                label: Text(_busy
                    ? 'Processing...'
                    : (_hasBaseline ? 'Verify Face' : 'Capture & Save Face')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

