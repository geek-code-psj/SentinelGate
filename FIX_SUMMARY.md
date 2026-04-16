# SentinelGate Student App - Backend Alignment Fixes

## Summary of Changes

This document describes all fixes applied to align the student app with the backend contract and intended architecture flow.

---

## 1. API Base Path Correction

**Issue:** App was using `/api/v1` paths; backend uses `/api`

**Files Modified:**
- `lib/utils/constants.dart`

**Changes:**
```dart
// OLD
defaultValue: 'https://sentinelgateweb-production.up.railway.app/api/v1'

// NEW
defaultValue: 'https://sentinelgateweb-production.up.railway.app/api'
```

**Impact:** All API calls now route to `/api/...` instead of `/api/v1/...`

---

## 2. QR Parsing Schema Update

**Issue:** QR code didn't include `geofence_id` in parsing; backend expects it

**Files Modified:**
- `lib/services/totp_service.dart`

**Changes:**
- Updated `QrPayload` class to include `geofenceId` field
- Updated all parsing methods to extract `geofence_id` from QR:
  - URI scheme: `sentinelgate://gate_id/geofence_id/totp_value/nonce/expires_ms`
  - Query parameters: `?geofence_id=...&totp_value=...`
  - JSON payload: `{"geofence_id": "..."}`
  - Delimited: `gate_id|geofence_id|totp_value|nonce|expires_ms`

**Example New QR Format:**
```
sentinelgate://GATE_A/GEOFENCE_001/abc123/nonce-xyz/1700000000000
```

---

## 3. Gate Event Request Payload Alignment

**Issue:** App was sending nested GPS, separate biometric/integrity objects. Backend expects flat structure with backend-compatible field names.

**Files Modified:**
- `lib/services/api_service.dart`

**Old Payload:**
```dart
{
  'event_id': 'uuid',
  'gps': {'lat': ..., 'lng': ..., 'accuracy': ...},
  'biometric': {'liveness_score': ...},
  'integrity': {'hmac': ..., 'nonce': ...},
  'gate_id': '...'
}
```

**New Payload:**
```dart
{
  'event_id': 'uuid',
  'gps_lat': ...,
  'gps_lng': ...,
  'gps_accuracy': ...,
  'geofence_id': '...',     // ← NEW
  'gate_id': '...',
  'totp_value': '...',      // ← Now includes TOTP hash
  'totp_window': 30,        // ← NEW temporal MFA window
  'embedding_hash': '...',  // ← NEW face embedding hash
  'liveness_score': ...,
  'hmac': '...',            // ← Flat structure
  'nonce': '...'
}
```

---

## 4. Database Schema Updates

**Issue:** Database was missing fields for `geofence_id`, `embedding_hash`, and `totp_hash`

**Files Modified:**
- `lib/models/database.dart` (schema version bumped to 2)

**New Columns Added:**
```dart
class GateEvents extends Table {
  // ...existing fields...
  TextColumn get geofenceId         => text().nullable()();     // From QR
  TextColumn get embeddingHash      => text().nullable()();     // Face landmark hash
  TextColumn get totpHash           => text().nullable()();     // SHA-256(totp_value)
  // ...rest of table...
}
```

**Schema Version:**
- Old: `schemaVersion = 1`
- New: `schemaVersion = 2` (triggers Drift migration)

---

## 5. Gate Event Service Enhancements

**Issue:** Event flow was missing embedding_hash and geofence_id; no support for deferred database writes for approval flows

**Files Modified:**
- `lib/services/gate_event_service.dart`

**Changes:**

### a) Event Creation Phase
- Now extracts `embedding_hash` from `FaceService.analyse()` result
- Includes `geofence_id` from `QrPayload.geofenceId`
- Computes and stores `totp_hash = SHA256(totp_value)`

### b) Deferred Write Support
Added `writeToDb` parameter to `processExit()`:
```dart
Future<EventResult> processExit({
  // ...existing params...
  bool writeToDb = true,  // ← NEW: skip DB write for long-leave approval flow
}) async { ... }
```

### c) EventResult Enhancement
```dart
class EventResult {
  // ...existing fields...
  Map<String, dynamic>? payload;    // ← For deferred writes
  dynamic? signed;                  // ← SignedPayload for deferred writes
}
```

### d) Helper Function for Deferred Commits
Added `commitDeferredEvent()` to write event AFTER approval completes:
```dart
Future<void> commitDeferredEvent({
  required AppDatabase db,
  required String eventId,
  // ...all gate event fields...
}) async {
  // Writes event with status APPROVED
  // Immediately syncs to backend
}
```

---

## 6. Screen Updates

**Files Modified:**
- `lib/screens/checkout_screen.dart`
- `lib/screens/checkin_screen.dart`

**Changes:**
- Added display of `geofence_id` in QR confirmation screens
- Shows geofence alongside gate ID for user confirmation

**Example Display:**
```
Gate: GATE_A
Geofence: GEOFENCE_001
Token expires in 15s
```

---

## 7. Crypto Service Cleanup

**Files Modified:**
- `lib/services/crypto_service.dart`

**Changes:**
- Removed unused `dart:math` import
- Updated path comment from `/api/v1/events` to `/auth/event` (reflects actual usage)

---

## Critical Implementation Notes

### Signing & Anti-Replay
The HMAC signing still uses a **fresh UUID nonce** in headers for each request:
```
Canonical: METHOD\nPATH\nBODY_HASH\nSNTP_TS\nREQUEST_NONCE
```

The **QR nonce** is included in the payload itself (not the request nonce) to prevent replays of the same authorization.

### Leave Approval Flow (Still Needs Screen Updates)
**Current State:** Deferred writes are now supported in `GateEventService`.

**Required Screen Changes (TODO):**
The `checkout_screen` must be reordered to:
1. Capture face (passes)
2. Check if duration > 5 hrs
3. If YES: Submit leave request BEFORE auth event
   - Get leaveId
   - Prompt for document upload
   - Upload document
   - Poll for approval
   - Only THEN commit the auth event
4. If NO: Commit auth event immediately

---

## Database Migration

When the app first runs with these changes:
1. Drift detects `schemaVersion = 2` 
2. Automatically migrates table by:
   - Adding new nullable columns: `geofenceId`, `embeddingHash`, `totpHash`
   - No data loss (new columns are nullable)
3. Existing events remain intact

**Note:** Build command for code generation:
```bash
flutter pub run build_runner build
```

---

## Testing Checklist

- [ ] QR code with `geofence_id` parses correctly (all 4 formats: URI, query, JSON, delimited)
- [ ] API calls hit `/api/*` endpoints (not `/api/v1/*`)
- [ ] Gate event payload includes: `totp_value`, `embedding_hash`, `geofence_id`, flat GPS fields
- [ ] Face embedding hash is extracted and stored in DB
- [ ] TOTP hash is computed and stored
- [ ] Database migration (v1 → v2) runs without errors
- [ ] Sync service sends new payload schema to backend
- [ ] Short-leave flow (<5hrs): Auth event sent immediately
- [ ] Long-leave flow (>5hrs): Deferred write still needs screen integration

---

## Remaining Work

1. **Leave Approval Screen Logic** - Reorder checkout flow to handle approval before auth event
2. **FRR Retry Loop** - Add face re-capture on liveness failure (mentioned in architecture)
3. **Offline Sync Enhancements** - Ensure WorkManager calls sync with network backoff
4. **Build & Test** - Run `flutter pub get` and `build_runner` to generate Drift migrations
5. **Backend Contract Validation** - Confirm backend accepts new payload schema

---

## Git Commits

1. **Commit 1:** Align student app flow with backend contract (QR parsing, API paths, payload schema)
2. **Commit 2:** Add deferred event writing for long-leave approval flow

**Branch:** `main` on `https://github.com/geek-code-psj/SentinelGate.git`


