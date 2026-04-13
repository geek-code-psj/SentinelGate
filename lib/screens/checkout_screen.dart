import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/face_service.dart';
import '../services/gate_event_service.dart';
import '../services/totp_service.dart';
import '../services/approval_service.dart';
import '../services/crypto_service.dart';
import '../services/sntp_service.dart';
import '../models/database.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

// ── Step indices (Phase 1 → Phase 5) ─────────────────────────────────────────
const int _stepReason   = 0;
const int _stepQr       = 1;
const int _stepFace     = 2;
const int _stepApproval = 3;
const int _stepResult   = 4;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = _stepReason;

  // Step 0 — Reason
  String    _reason = 'Market';
  DateTime? _expectedReturn;
  final _db = AppDatabase();

  // Step 1 — QR
  QrPayload? _qr;
  bool       _qrDone = false;

  // Step 2 — Face
  CameraController? _cam;
  bool              _camReady  = false;
  bool              _capturing = false;
  FaceResult?       _faceResult;

  // Step 3 — Approval (long leave)
  File?           _approvalDoc;
  bool            _uploadingApproval = false;
  String?         _approvalError;

  // Step 4 — Result
  EventResult? _result;
  bool         _processing = false;

  @override
  void dispose() {
    _cam?.dispose();
    FaceService.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

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

  bool get _needsApproval {
    if (_expectedReturn == null) return false;
    final now = SntpService.now();
    final hours = _expectedReturn!.difference(now).inHours;
    return hours > AppConstants.longLeaveThresholdHours;
  }

  // ── Step renders ─────────────────────────────────────────────────────────

  // STEP 0: Reason selection
  Widget _buildReason() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _StepHeader(step: 1, total: 5, title: 'Reason for Exit',
          sub: 'Select your reason before proceeding to the gate'),
      const SizedBox(height: 20),
      ...AppConstants.leaveReasons.map((r) => _ReasonTile(
        label    : r,
        selected : _reason == r,
        onTap    : () => setState(() => _reason = r),
      )),
      const SizedBox(height: 16),
      _label('Expected return time (required if leave exceeds 5 hours)'),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () async {
          final now = DateTime.now();
          final date = await showDatePicker(
            context  : context,
            initialDate: now,
            firstDate: now,
            lastDate : now.add(const Duration(days: 30)),
          );
          if (date == null || !mounted) return;
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time == null) return;
          setState(() => _expectedReturn = DateTime(
              date.year, date.month, date.day, time.hour, time.minute));
        },
        icon : const Icon(Icons.schedule),
        label: Text(_expectedReturn == null
            ? 'Pick Return Date & Time'
            : '${_expectedReturn!.day}/${_expectedReturn!.month}  ${_expectedReturn!.hour.toString().padLeft(2,'0')}:${_expectedReturn!.minute.toString().padLeft(2,'0')}'),
        style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
      ),
      if (_needsApproval) ...[
        const SizedBox(height: 12),
        _InfoBox(
          icon: Icons.warning_amber_outlined,
          color: const Color(0xFFFFF8E1),
          textColor: AppTheme.warning,
          message: 'Leave > ${AppConstants.longLeaveThresholdHours} hours requires '
                   'a warden approval letter. You will be prompted to photograph it.',
        ),
      ],
      const SizedBox(height: 28),
      ElevatedButton(
        onPressed: () => setState(() => _step = _stepQr),
        child: const Text('Continue to Gate QR Scan'),
      ),
    ]);
  }

  // STEP 1: QR scan
  Widget _buildQr() {
    return Column(children: [
      _StepHeader(step: 2, total: 5, title: 'Scan Gate QR Code',
          sub: 'Point your camera at the warden\'s rotating QR code'),
      const SizedBox(height: 20),
      Container(
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _qrDone ? AppTheme.success : AppTheme.primary, width: 2),
        ),
        clipBehavior: Clip.hardEdge,
        child: _qrDone
            ? Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.check_circle, color: AppTheme.success, size: 52),
                  const SizedBox(height: 8),
                  Text('Gate: ${_qr!.gateId}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Token expires in ${(TotpService.msRemaining(_qr!) / 1000).ceil()}s',
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
              )
            : MobileScanner(onDetect: (capture) {
                if (_qrDone) return;
                final raw = capture.barcodes.firstOrNull?.rawValue ?? '';
                final payload = TotpService.parseQr(raw);
                if (payload == null) return;
                final err = TotpService.validate(payload);
                if (err != null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(err)));
                  return;
                }
                setState(() { _qr = payload; _qrDone = true; });
                Future.delayed(const Duration(milliseconds: 600), () {
                  if (mounted) {
                    setState(() => _step = _stepFace);
                    _initCamera();
                  }
                });
              }),
      ),
      const SizedBox(height: 16),
      _InfoBox(
        icon: Icons.timer_outlined,
        color: const Color(0xFFF3E5F5),
        textColor: const Color(0xFF6A1B9A),
        message: 'The QR rotates every 30 seconds. Screenshots and old codes '
                 'are rejected by cryptographic timestamp verification.',
      ),
      const SizedBox(height: 16),
      TextButton(onPressed: () => setState(() => _step = _stepReason),
          child: const Text('Back')),
    ]);
  }

  // STEP 2: Face liveness
  Widget _buildFace() {
    return Column(children: [
      _StepHeader(step: 3, total: 5, title: 'Face Verification',
          sub: 'Look directly at the camera. GPS check runs simultaneously.'),
      const SizedBox(height: 20),
      Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.black),
        clipBehavior: Clip.hardEdge,
        child: Stack(fit: StackFit.expand, children: [
          if (_camReady) CameraPreview(_cam!)
          else const Center(child: CircularProgressIndicator(color: Colors.white)),
          // Oval face guide
          Center(
            child: Container(
              width: 180, height: 220,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _faceResult?.passed == true
                      ? AppTheme.success
                      : Colors.white70,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(110),
              ),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      if (_faceResult != null) _FaceChip(result: _faceResult!),
      const SizedBox(height: 16),
      if (!_processing) ElevatedButton.icon(
        onPressed: _camReady && !_capturing ? _captureAndProcess : null,
        icon: _capturing
            ? const SizedBox(width: 18, height: 18,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.face_retouching_natural),
        label: Text(_capturing ? 'Verifying...' : 'Verify & Authenticate'),
      ),
      if (_processing) const Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text('Signing payload · Checking GPS · Writing record...'),
        ]),
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () => setState(() {
          _step = _stepQr; _qrDone = false; _qr = null; _faceResult = null;
        }),
        child: const Text('Back'),
      ),
    ]);
  }

  Future<void> _captureAndProcess() async {
    if (_capturing || !_camReady) return;
    setState(() { _capturing = true; _faceResult = null; });
    try {
      final xFile = await _cam!.takePicture();

      // Quick local face preview
      final face = await FaceService.analyse(xFile.path);
      setState(() { _faceResult = face; _capturing = false; });

      if (!face.passed) return; // User will retry

      // All checks passed — run full pipeline
      setState(() => _processing = true);
      final studentId = await CryptoService.getStudentId();
      if (studentId == null || _qr == null) return;

      final svc    = GateEventService(_db);
      final result = await svc.processExit(
        studentId      : studentId,
        qr             : _qr!,
        imagePath      : xFile.path,
        reason         : _reason,
        expectedReturn : _expectedReturn,
      );

      setState(() { _result = result; _processing = false; });

      if (result.success && result.requiresApproval) {
        setState(() => _step = _stepApproval);
      } else {
        setState(() => _step = _stepResult);
      }
    } catch (e) {
      setState(() {
        _faceResult = FaceResult.fail(FailReason.error, 'Error: $e');
        _capturing  = false;
        _processing = false;
      });
    }
  }

  // STEP 3: Warden approval document (long leave only)
  Widget _buildApproval() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _StepHeader(
        step: 4, total: 5,
        title: 'Warden Approval Required',
        sub: 'Your expected leave exceeds 5 hours. Photograph your signed approval letter.',
      ),
      const SizedBox(height: 24),
      if (_approvalDoc == null)
        OutlinedButton.icon(
          onPressed: _pickApprovalDoc,
          icon: const Icon(Icons.document_scanner),
          label: const Text('Photograph Approval Letter'),
          style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
        )
      else ...[
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.success),
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.file(_approvalDoc!, fit: BoxFit.cover, width: double.infinity),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: _pickApprovalDoc,
          icon: const Icon(Icons.refresh),
          label: const Text('Retake Photo'),
        ),
      ],
      if (_approvalError != null) ...[
        const SizedBox(height: 12),
        _InfoBox(
          icon: Icons.error_outline,
          color: const Color(0xFFFFEBEE),
          textColor: AppTheme.danger,
          message: _approvalError!,
        ),
      ],
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: _approvalDoc == null || _uploadingApproval ? null : _submitApproval,
        child: _uploadingApproval
            ? const SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Submit & Complete Checkout'),
      ),
    ]);
  }

  Future<void> _pickApprovalDoc() async {
    final file = await ApprovalService.captureDocument();
    if (file != null) setState(() { _approvalDoc = file; _approvalError = null; });
  }

  Future<void> _submitApproval() async {
    if (_approvalDoc == null || _result?.eventId == null) return;
    setState(() { _uploadingApproval = true; _approvalError = null; });

    final svc = ApprovalService(_db);
    final res = await svc.submitApproval(
        eventId: _result!.eventId!, docFile: _approvalDoc!);

    if (res.success) {
      setState(() { _uploadingApproval = false; _step = _stepResult; });
    } else {
      setState(() { _approvalError = res.error; _uploadingApproval = false; });
    }
  }

  // STEP 4: Result
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
        ok ? 'Checkout Complete' : 'Authentication Failed',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
            color: ok ? AppTheme.success : AppTheme.danger),
      ),
      const SizedBox(height: 12),
      if (ok) ...[
        _MetaRow('Reason', _reason),
        if (_expectedReturn != null)
          _MetaRow('Expected return',
              '${_expectedReturn!.day}/${_expectedReturn!.month}  '
              '${_expectedReturn!.hour.toString().padLeft(2,'0')}:'
              '${_expectedReturn!.minute.toString().padLeft(2,'0')}'),
        _MetaRow('Face confidence',
            '${(_result!.livenessScore * 100).toStringAsFixed(0)}%'),
        _MetaRow('GPS distance',
            '${_result!.gpsDistance.toStringAsFixed(0)} m from gate'),
        _MetaRow('Clock delta', '${_result!.clockDeltaMs} ms'),
        const SizedBox(height: 16),
        _InfoBox(
          icon: Icons.cloud_upload_outlined,
          color: const Color(0xFFE8F5E9),
          textColor: AppTheme.success,
          message: 'Record written locally. '
                   'Will sync to server automatically when network is available.',
        ),
      ] else ...[
        _InfoBox(
          icon: Icons.error_outline,
          color: const Color(0xFFFFEBEE),
          textColor: AppTheme.danger,
          message: _result?.failMessage ?? 'Unknown error',
        ),
      ],
      const SizedBox(height: 32),
      ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done')),
      if (!ok) ...[
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => setState(() {
            _step = _stepReason; _qrDone = false; _qr = null;
            _faceResult = null; _result = null;
          }),
          child: const Text('Try Again'),
        ),
      ],
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exit Gate'),
        leading: _step < _stepResult
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
              child: [
                _buildReason(),
                _buildQr(),
                _buildFace(),
                _buildApproval(),
                _buildResult(),
              ][_step],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  final int    step;
  final int    total;
  final String title;
  final String sub;
  const _StepHeader({required this.step, required this.total,
      required this.title, required this.sub});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (step > 0)
        Text('Step $step of $total',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 4),
      Text(title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(sub, style: const TextStyle(fontSize: 13, color: Colors.grey)),
    ]);
  }
}

class _ReasonTile extends StatelessWidget {
  final String   label;
  final bool     selected;
  final VoidCallback onTap;
  const _ReasonTile({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary.withValues(alpha: 0.07) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? AppTheme.primary : Colors.grey.shade200,
              width: selected ? 2 : 1),
        ),
        child: Row(children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: selected ? AppTheme.primary : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected ? AppTheme.primary : Colors.black87)),
        ]),
      ),
    );
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

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetaRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ]),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final Color    color;
  final Color    textColor;
  final String   message;
  const _InfoBox({required this.icon, required this.color,
      required this.textColor, required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: textColor, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(message,
            style: TextStyle(fontSize: 12, color: textColor))),
      ]),
    );
  }
}

Widget _label(String text) =>
    Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13));
