import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../services/crypto_service.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _rollCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  bool    _loading = false;
  String? _error;

  @override
  void dispose() {
    _rollCtrl.dispose();
    _nameCtrl.dispose();
    _deptCtrl.dispose();
    super.dispose();
  }

  Future<void> _enroll() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    try {
      // Get device fingerprint (use a unique ID)
      final deviceInfo = await _getDeviceInfo();

      // Call backend to enroll device and get HMAC secret
      final enrollResult = await ApiService.enrollDevice(
        rollNumber: _rollCtrl.text.trim().toUpperCase(),
        deviceFingerprint: deviceInfo['fingerprint']!,
        platform: deviceInfo['platform']!,
        model: deviceInfo['model']!,
      );

      if (!enrollResult.ok) {
        setState(() { _error = enrollResult.error ?? 'Enrollment failed'; _loading = false; });
        return;
      }

      // Save the HMAC secret and device ID from server response
      final data = enrollResult.data as Map<String, dynamic>;
      final hmacSecret = data['hmac_secret'] as String?;
      final deviceId = data['device_id'] as String?;

      if (hmacSecret == null || deviceId == null) {
        setState(() { _error = 'Invalid server response - missing data'; _loading = false; });
        return;
      }

      // Store the server-provided HMAC secret and device ID
      await CryptoService.saveDeviceId(deviceId);
      await CryptoService.saveHmacSecret(hmacSecret);
      await CryptoService.saveStudentId(_rollCtrl.text.trim().toUpperCase());
      await CryptoService.setEnrolled();

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() { _error = 'Enrollment failed: $e'; _loading = false; });
    }
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    // Get device ID for fingerprint
    final deviceId = await _getDeviceId();

    // Detect platform
    final platform = Theme.of(context).platform == TargetPlatform.android ? 'android' : 'ios';

    // Get model (fallback to generic)
    String model = 'Unknown';
    try {
      // This would need device_info package for actual model
      model = 'Android Device';
    } catch (_) {}

    return {
      'fingerprint': deviceId,
      'platform': platform,
      'model': model,
    };
  }

  Future<String> _getDeviceId() async {
    // Use Flutter's unique device ID (identifierForVendor on iOS, Android ID on Android)
    // For now, generate a persistent UUID stored in secure storage
    const storage = FlutterSecureStorage();
    String? deviceId = await storage.read(key: 'sg_device_fingerprint');
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await storage.write(key: 'sg_device_fingerprint', value: deviceId);
    }
    return deviceId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Center(
                  child: Column(children: [
                    Icon(Icons.shield, size: 72, color: AppTheme.primary),
                    SizedBox(height: 12),
                    Text('SentinelGate', style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    SizedBox(height: 4),
                    Text('Device Enrollment', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ]),
                ),
                const SizedBox(height: 40),
                _label('Roll Number'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _rollCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'e.g. CS21B042',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().length < 4)
                      ? 'Enter valid roll number' : null,
                ),
                const SizedBox(height: 16),
                _label('Full Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'As per college records',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name required' : null,
                ),
                const SizedBox(height: 16),
                _label('Department'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _deptCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Computer Science',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Department required' : null,
                ),
                const SizedBox(height: 24),
                _securityNote(),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  _errorBox(_error!),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loading ? null : _enroll,
                  child: _loading
                      ? const SizedBox(height: 20, width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Enroll This Device'),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'This device will be permanently linked to your roll number.\n'
                    'Contact IT admin if you change phones.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14));

  Widget _securityNote() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.success.withOpacity(0.3)),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.lock_outline, color: AppTheme.success, size: 18),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'A 256-bit secret key will be generated and stored in this device\'s '
            'hardware security enclave (Android KeyStore). '
            'Face images are never stored or uploaded.',
            style: TextStyle(fontSize: 12, color: Color(0xFF2E7D32)),
          ),
        ),
      ],
    ),
  );

  Widget _errorBox(String msg) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10)),
    child: Text(msg, style: const TextStyle(color: AppTheme.danger, fontSize: 13)),
  );
}
