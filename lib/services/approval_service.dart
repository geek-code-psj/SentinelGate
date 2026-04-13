import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/database.dart';
import 'api_service.dart';

/// Handles Phase 3B: Long-leave warden approval document.
///
/// If expectedDuration > 5 hours:
///   - UI pauses and prompts student to photograph the warden-signed leave letter.
///   - Signed approval payload + document upload are sent to the server.
///   - Event sync status stays at PENDING_APPROVAL until admin approval arrives.
class ApprovalService {
  final AppDatabase db;
  const ApprovalService(this.db);

  /// Launches camera to capture approval document.
  static Future<File?> captureDocument() async {
    final picker = ImagePicker();
    final xFile  = await picker.pickImage(
      source       : ImageSource.camera,
      imageQuality : 80,         // Compress for faster upload on slow 4G
      maxWidth     : 1920,
      maxHeight    : 1080,
    );
    if (xFile == null) return null;
    return File(xFile.path);
  }

  /// Upload the document and unlock the event for sync.
  Future<ApprovalResult> submitApproval({
    required String eventId,
    required File   docFile,
  }) async {
    final bytes    = await docFile.readAsBytes();
    final ext      = docFile.path.split('.').last.toLowerCase();
    final mimeType = ext == 'pdf' ? 'pdf' : 'jpg';
    final docPath  = docFile.path;

    final result = await ApiService.uploadApproval(
      eventId   : eventId,
      docBytes  : bytes,
      mimeType  : mimeType,
      imageUrl  : docPath,
    );

    if (result.ok) {
      final imageUrl = (result.data is Map && (result.data as Map)['image_url'] != null)
          ? (result.data as Map)['image_url'].toString()
          : docPath;
      await db.setApprovalDocPath(eventId, imageUrl);
      await db.markPendingApproval(eventId);
      return ApprovalResult(success: true);
    }

    return ApprovalResult(success: false, error: result.error ?? 'Upload failed');
  }
}

class ApprovalResult {
  final bool    success;
  final String? error;
  const ApprovalResult({required this.success, this.error});
}
