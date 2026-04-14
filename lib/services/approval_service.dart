import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../models/database.dart';
import 'api_service.dart';

/// Handles Phase 3: Long-leave warden approval.
///
/// Flow:
/// 1. Student selects return time > 5 hours
/// 2. App calls POST /leave/request → gets leaveId
/// 3. If leave requires approval, student photographs warden letter
/// 4. App calls POST /leave/upload-doc/:leaveId with the photo
/// 5. App polls GET /leave/status/:leaveId until approved
class ApprovalService {
  final AppDatabase db;
  const ApprovalService(this.db);

  /// Launches camera to capture approval document.
  static Future<File?> captureDocument() async {
    final picker = ImagePicker();
    final xFile  = await picker.pickImage(
      source       : ImageSource.camera,
      imageQuality : 80,
      maxWidth     : 1920,
      maxHeight    : 1080,
    );
    if (xFile == null) return null;
    return File(xFile.path);
  }

  /// Step 1: Submit leave request to get leaveId
  Future<LeaveRequestResult> submitLeaveRequest({
    required String gateId,
    required String reason,
    required DateTime expectedReturn,
    File? approvalDoc,
  }) async {
    final expectedReturnTs = expectedReturn.millisecondsSinceEpoch;

    String? docB64;
    if (approvalDoc != null) {
      final bytes = await approvalDoc.readAsBytes();
      docB64 = base64Encode(bytes);
    }

    final result = await ApiService.submitLeaveRequest(
      gateId: gateId,
      reason: reason,
      expectedReturnTs: expectedReturnTs,
      approvalDocB64: docB64,
    );

    if (result.ok) {
      final data = result.data as Map<String, dynamic>;
      return LeaveRequestResult(
        success: true,
        leaveId: data['leave_id']?.toString(),
        status: data['status']?.toString(),
        canProceed: data['can_proceed'] == true,
        requiresDocUpload: data['status'] == 'PENDING_DOC',
      );
    }

    return LeaveRequestResult(success: false, error: result.error ?? 'Leave request failed');
  }

  /// Step 2: Upload approval document
  Future<ApprovalResult> uploadApprovalDoc({
    required String leaveId,
    required File docFile,
  }) async {
    final bytes = await docFile.readAsBytes();
    final ext = docFile.path.split('.').last.toLowerCase();
    final mimeType = ext == 'pdf' ? 'pdf' : 'jpg';

    final result = await ApiService.uploadApprovalDoc(
      leaveId: leaveId,
      docBytes: bytes,
      mimeType: mimeType,
    );

    if (result.ok) {
      return ApprovalResult(success: true);
    }

    return ApprovalResult(success: false, error: result.error ?? 'Upload failed');
  }

  /// Step 3: Poll for approval status
  Future<LeaveStatusResult> pollStatus(String leaveId) async {
    final result = await ApiService.pollLeaveStatus(leaveId);

    if (result.ok) {
      final data = result.data as Map<String, dynamic>;
      return LeaveStatusResult(
        status: data['status']?.toString(),
        canProceed: data['can_proceed'] == true,
        approvedBy: data['approved_by']?.toString(),
        approvedAt: data['approved_at']?.toString(),
      );
    }

    return LeaveStatusResult(
      status: 'ERROR',
      error: result.error ?? 'Status check failed',
    );
  }
}

class LeaveRequestResult {
  final bool success;
  final String? leaveId;
  final String? status;
  final bool canProceed;
  final bool requiresDocUpload;
  final String? error;

  const LeaveRequestResult({
    required this.success,
    this.leaveId,
    this.status,
    this.canProceed = false,
    this.requiresDocUpload = false,
    this.error,
  });
}

class LeaveStatusResult {
  final String? status;
  final bool canProceed;
  final String? approvedBy;
  final String? approvedAt;
  final String? error;

  const LeaveStatusResult({
    this.status,
    this.canProceed = false,
    this.approvedBy,
    this.approvedAt,
    this.error,
  });
}

class ApprovalResult {
  final bool    success;
  final String? error;
  const ApprovalResult({required this.success, this.error});
}