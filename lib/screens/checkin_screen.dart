import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/face_service.dart';
import '../services/gate_event_service.dart';
import '../services/totp_service.dart';
import '../services/crypto_service.dart';
import '../models/database.dart';
import '../utils/app_theme.dart';

const int _sQr     = 0;
const int _sFace   = 1;
const int _sResult = 2;

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});
  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  int _step = _sQr;

  QrPayload? _qr;
  bool       _qrDone = false;
  bool       _handlingQr = false;
  DateTime?  _lastQrHintAt;
  final MobileScannerController _qrScannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  CameraController? _cam;
  bool              _camReady  = false;
  bool              _capturing = false;
  FaceResult?       _faceResult;

  EventResult? _result;
  bool         _processing = false;

  final _db = AppDatabase();

  @override
  void dispose() {
    _qrScannerController.dispose();
    _cam?.dispose();
    FaceService.dispose();
    super.dispose();
  }

  Future<void> _restartQrScanner() async {
    try {
      await _qrScannerController.start();
    } catch (_) {}
  }

  void _showQrHint(String message) {
    final now = DateTime.now();
    if (_lastQrHintAt != null && now.difference(_lastQrHintAt!) < const Duration(seconds: 2)) {
      return;
    }
    _lastQrHintAt = now;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _initCamera() async {
    await FaceService.init();
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cam = CameraController(front, ResolutionPreset.medium, enableAudio: false);
    await _cam!.initialize();
    if (mounted) setState(() => _camReady = true);
  }

  // ── QR Step ───────────────────────────────────────────────────────────────

  Widget _buildQr() {
    return Column(children: [
      const _Header(title: 'Scan Gate QR Code',
          sub: 'Point your camera at the warden\'s rotating QR code'),
      const SizedBox(height: 20),
      Container(
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: _qrDone ? AppTheme.success : AppTheme.success, width: 2),
        ),
        clipBehavior: Clip.hardEdge,
        child: _qrDone
            ? Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.check_circle, color: AppTheme.success, size: 52),
                  const SizedBox(height: 8),
                  Text('Gate: ${_qr!.gateId}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ]),
              )
            : MobileScanner(
                controller: _qrScannerController,
                onDetect: (capture) {
                  if (_qrDone || _handlingQr) return;
                  _handlingQr = true;

                  QrPayload? valid;
                  bool sawNonEmptyRaw = false;
                  String? lastValidationError;
                  for (final code in capture.barcodes) {
                    final raw = code.rawValue?.trim() ?? '';
                    if (raw.isEmpty) continue;
                    sawNonEmptyRaw = true;
                    final parsed = TotpService.parseQr(raw);
                    if (parsed == null) continue;
                    final err = TotpService.validate(parsed);
                    if (err == null) {
                      valid = parsed;
                      break;
                    }
                    lastValidationError = err;
                  }

                  if (valid == null) {
                    if (lastValidationError != null) {
                      _showQrHint(lastValidationError);
                    } else if (sawNonEmptyRaw) {
                      _showQrHint('QR detected but format not supported. Please use the live gate QR.');
                    }
                    _handlingQr = false;
                    return;
                  }

                  _qrScannerController.stop();
                  setState(() {
                    _qr = valid;
                    _qrDone = true;
                  });
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      setState(() => _step = _sFace);
                      _initCamera();
                    }
                  });
                },
              ),
      ),
      const SizedBox(height: 16),
      _Box(
        color: const Color(0xFFE8F5E9),
        textColor: AppTheme.success,
        icon: Icons.login,
        message: 'Checking back in? Scan the gate QR code and pass face verification '
                 'to mark yourself as inside campus.',
      ),
    ]);
  }

  // ── Face Step ─────────────────────────────────────────────────────────────

  Widget _buildFace() {
    return Column(children: [
      const _Header(title: 'Face Verification',
          sub: 'Look directly at the camera to confirm it\'s you'),
      const SizedBox(height: 20),
      Container(
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.black),
        clipBehavior: Clip.hardEdge,
        child: Stack(fit: StackFit.expand, children: [
          if (_camReady)
            CameraPreview(_cam!)
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          Center(
            child: Container(
              width: 180, height: 220,
              decoration: BoxDecoration(
                border: Border.all(
                    color: _faceResult?.passed == true ? AppTheme.success : Colors.white70,
                    width: 2),
                borderRadius: BorderRadius.circular(110),
              ),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      if (_faceResult != null) _FaceChip(result: _faceResult!),
      const SizedBox(height: 16),
      if (!_processing)
        ElevatedButton.icon(
          onPressed: _camReady && !_capturing ? _verify : null,
          icon: _capturing
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.face),
          label: Text(_capturing ? 'Verifying...' : 'Verify & Check In'),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
        ),
      if (_processing)
        const Padding(
          padding: EdgeInsets.all(16),
          child: Column(children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Verifying location · Signing record...'),
          ]),
        ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () {
          setState(() {
            _step = _sQr;
            _qrDone = false;
            _qr = null;
            _faceResult = null;
          });
          _handlingQr = false;
          _restartQrScanner();
        },
        child: const Text('Back'),
      ),
    ]);
  }

  Future<void> _verify() async {
    if (_capturing || !_camReady) return;
    setState(() { _capturing = true; _faceResult = null; });
    try {
      final xFile = await _cam!.takePicture();
      final face  = await FaceService.analyse(xFile.path);
      setState(() { _faceResult = face; _capturing = false; });
      if (!face.passed) return;

      setState(() => _processing = true);
      final studentId = await CryptoService.getStudentId();
      if (studentId == null || _qr == null) {
        setState(() => _processing = false);
        return;
      }

      final svc    = GateEventService(_db);
      final result = await svc.processReturn(
          studentId : studentId,
          qr        : _qr!,
          imagePath : xFile.path);

      setState(() { _result = result; _processing = false; _step = _sResult; });
    } catch (e) {
      setState(() {
        _faceResult = FaceResult.fail(FailReason.error, 'Error: $e');
        _capturing  = false;
        _processing = false;
      });
    }
  }

  // ── Result Step ───────────────────────────────────────────────────────────

  Widget _buildResult() {
    final ok = _result?.success ?? false;
    return Column(children: [
      const SizedBox(height: 32),
      Icon(
        ok ? Icons.check_circle_outline : Icons.error_outline,
        size: 80,
        color: ok ? AppTheme.success : AppTheme.danger,
      ),
      const SizedBox(height: 20),
      Text(
        ok ? 'Welcome Back!' : 'Check-in Failed',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
            color: ok ? AppTheme.success : AppTheme.danger),
      ),
      const SizedBox(height: 16),
      _Box(
        color: ok ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        textColor: ok ? AppTheme.success : AppTheme.danger,
        icon: ok ? Icons.check : Icons.error_outline,
        message: ok
            ? 'Your return is recorded. Status updated to INSIDE CAMPUS. '
              'Warden dashboard has been updated.'
            : (_result?.failMessage ?? 'Unknown error'),
      ),
      const SizedBox(height: 32),
      ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done')),
      if (!ok) ...[
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            setState(() {
              _step = _sQr;
              _qrDone = false;
              _qr = null;
              _faceResult = null;
              _result = null;
            });
            _handlingQr = false;
            _restartQrScanner();
          },
          child: const Text('Try Again'),
        ),
      ],
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return to Campus'),
        leading: _step < _sResult
            ? IconButton(icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context))
            : const SizedBox.shrink(),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(
              key: ValueKey(_step),
              child: [_buildQr(), _buildFace(), _buildResult()][_step],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Local widgets ─────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String title;
  final String sub;
  const _Header({required this.title, required this.sub});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(sub, style: const TextStyle(fontSize: 13, color: Colors.grey)),
    ]);
  }
}

class _FaceChip extends StatelessWidget {
  final FaceResult result;
  const _FaceChip({required this.result});
  @override
  Widget build(BuildContext context) {
    final ok = result.passed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: (ok ? AppTheme.success : AppTheme.danger).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(ok ? Icons.check : Icons.close,
            color: ok ? AppTheme.success : AppTheme.danger, size: 18),
        const SizedBox(width: 8),
        Text(result.displayMessage,
            style: TextStyle(
                color: ok ? AppTheme.success : AppTheme.danger,
                fontWeight: FontWeight.w600, fontSize: 13)),
      ]),
    );
  }
}

class _Box extends StatelessWidget {
  final Color    color;
  final Color    textColor;
  final IconData icon;
  final String   message;
  const _Box({required this.color, required this.textColor,
      required this.icon, required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: textColor, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(message, style: TextStyle(fontSize: 12, color: textColor))),
      ]),
    );
  }
}
