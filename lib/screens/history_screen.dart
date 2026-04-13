import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/crypto_service.dart';
import '../models/database.dart';
import '../utils/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<GateEvent>? _events;
  final _db = AppDatabase();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = await CryptoService.getStudentId();
    if (id == null) return;
    final events = await _db.getStudentHistory(id);
    if (mounted) setState(() => _events = events);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exit History'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _events == null
          ? const Center(child: CircularProgressIndicator())
          : _events!.isEmpty
              ? const Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.history_toggle_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No exit records yet',
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ]),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _events!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) => _EventTile(event: _events![i]),
                ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final GateEvent event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final isOut  = event.status == 'OUT';
    final color  = isOut ? AppTheme.danger : AppTheme.success;

    DateTime? dt;
    try { dt = DateTime.parse(event.trueTimestamp).toLocal(); } catch (_) {}

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          // Status icon
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.12)),
            child: Icon(isOut ? Icons.logout : Icons.login, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          // Details
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                _StatusBadge(status: event.status),
                const SizedBox(width: 8),
                _ReasonBadge(reason: event.reason),
              ]),
              const SizedBox(height: 6),
              Text(
                dt != null
                    ? DateFormat('dd MMM yyyy, hh:mm a').format(dt)
                    : event.trueTimestamp,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                'Gate: ${event.gateId}  ·  '
                'GPS ±${event.gpsAccuracy.toStringAsFixed(0)}m  ·  '
                'Face: ${(event.faceConfidence * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ]),
          ),
          const SizedBox(width: 8),
          // Sync status icon
          _SyncIcon(status: event.syncStatus),
        ]),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    final isOut = status == 'OUT';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (isOut ? AppTheme.danger : AppTheme.success).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isOut ? AppTheme.danger : AppTheme.success)),
    );
  }
}

class _ReasonBadge extends StatelessWidget {
  final String reason;
  const _ReasonBadge({required this.reason});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(reason,
          style: const TextStyle(fontSize: 11, color: Colors.black54)),
    );
  }
}

class _SyncIcon extends StatelessWidget {
  final String status;
  const _SyncIcon({required this.status});
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'SYNCED':
        return const Tooltip(
          message: 'Synced to server',
          child: Icon(Icons.cloud_done_outlined, color: AppTheme.success, size: 18),
        );
      case 'PENDING':
        return const Tooltip(
          message: 'Waiting to sync',
          child: Icon(Icons.cloud_upload_outlined, color: AppTheme.warning, size: 18),
        );
      case 'PENDING_APPROVAL':
        return const Tooltip(
          message: 'Warden approval required',
          child: Icon(Icons.pending_outlined, color: AppTheme.warning, size: 18),
        );
      case 'APPROVED':
        return const Tooltip(
          message: 'Warden approved',
          child: Icon(Icons.verified_outlined, color: AppTheme.success, size: 18),
        );
      default:
        return const Tooltip(
          message: 'Sync failed — will retry',
          child: Icon(Icons.cloud_off_outlined, color: AppTheme.danger, size: 18),
        );
    }
  }
}
