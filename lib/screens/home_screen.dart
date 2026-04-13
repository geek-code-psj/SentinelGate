import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/crypto_service.dart';
import '../services/sync_service.dart';
import '../services/sntp_service.dart';
import '../models/database.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String?    _studentId;
  GateEvent? _lastEvent;
  int        _pendingSync = 0;
  bool       _loading = true;
  final _db = AppDatabase();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _studentId   = await CryptoService.getStudentId();
    if (_studentId != null) {
      _lastEvent = await _db.getLatestEvent(_studentId!);
    }
    _pendingSync = await SyncService.pendingCount();
    if (mounted) setState(() => _loading = false);
  }

  bool get _isOut => _lastEvent?.status == 'OUT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SentinelGate'),
        actions: [
          if (_pendingSync > 0)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Chip(
                label: Text('$_pendingSync pending',
                    style: const TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: AppTheme.warning,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              await Navigator.pushNamed(context, '/history');
              _load();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StudentCard(studentId: _studentId ?? ''),
                    const SizedBox(height: 16),
                    _StatusCard(isOut: _isOut, lastEvent: _lastEvent),
                    const SizedBox(height: 24),
                    _sectionLabel(_isOut ? 'Return to Campus' : 'Exit Campus'),
                    const SizedBox(height: 12),
                    if (!_isOut)
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/checkout');
                          _load();
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Exit Gate — Check Out'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/checkin');
                          _load();
                        },
                        icon: const Icon(Icons.login),
                        label: const Text('Enter Gate — Check In'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                      ),
                    const SizedBox(height: 24),
                    _ClockCard(),
                    const SizedBox(height: 16),
                    _InfoBox(
                      icon: Icons.info_outline,
                      color: Colors.blue.shade50,
                      textColor: Colors.blue.shade700,
                      message:
                          'You must be within 50 m of the gate, '
                          'pass face liveness, and scan the rotating QR code to authenticate.',
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600));
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _StudentCard extends StatelessWidget {
  final String studentId;
  const _StudentCard({required this.studentId});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppTheme.primary.withOpacity(0.1),
            child: Text(
              studentId.isNotEmpty ? studentId[0] : '?',
              style: const TextStyle(
                  color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Enrolled Student',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(studentId,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
        ]),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool       isOut;
  final GateEvent? lastEvent;
  const _StatusCard({required this.isOut, this.lastEvent});

  @override
  Widget build(BuildContext context) {
    final color = isOut ? AppTheme.danger : AppTheme.success;
    DateTime? dt;
    if (lastEvent != null) {
      try { dt = DateTime.parse(lastEvent!.trueTimestamp).toLocal(); } catch (_) {}
    }

    return Card(
      color: color.withOpacity(0.07),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(children: [
          Container(
            width: 14, height: 14,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                isOut ? 'Currently Outside Campus' : 'Currently Inside Campus',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15, color: color),
              ),
              if (lastEvent != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${lastEvent!.status}  ·  ${lastEvent!.reason}'
                  '${dt != null ? '  ·  ${DateFormat("dd MMM, hh:mm a").format(dt)}' : ''}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ClockCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final synced = SntpService.isSynced;
    final delta  = SntpService.deltaMs;
    final usingAdjustedClock = synced || delta != 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Icon(
            usingAdjustedClock ? Icons.access_time_filled : Icons.access_time_outlined,
            color: usingAdjustedClock ? AppTheme.success : AppTheme.warning,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              synced
                  ? 'Clock synced with server  (Δ ${delta >= 0 ? '+' : ''}${delta}ms)'
                  : usingAdjustedClock
                      ? 'Using cached server clock  (Δ ${delta >= 0 ? '+' : ''}${delta}ms)'
                      : 'Clock not synced — using device time',
              style: TextStyle(
                fontSize: 12,
                color: usingAdjustedClock ? AppTheme.success : AppTheme.warning,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final Color    color;
  final Color    textColor;
  final String   message;
  const _InfoBox({
    required this.icon,
    required this.color,
    required this.textColor,
    required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style: TextStyle(fontSize: 12, color: textColor))),
        ],
      ),
    );
  }
}
