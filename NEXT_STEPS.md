# Next Steps - Build & Deploy

## Immediate Actions (Before Building)

### 1. Backend Verification
Ask the backend team to confirm:
- [ ] API now accepts payloads at `/api` (not `/api/v1`)
- [ ] New payload schema is accepted:
  - `totp_value` instead of `totp_hash`
  - `totp_window: 30`
  - `embedding_hash` instead of just `liveness_score`
  - Flat GPS fields (`gps_lat`, `gps_lng`, `gps_accuracy`)
  - `geofence_id` field

### 2. QR Code Generation (Gate Tablet)
The warden's gate tablet needs to generate QR codes with the new format:

**Old Format:**
```
sentinelgate://GATE_A/abc123def/nonce-xyz/1700000000000
```

**New Format (Required):**
```
sentinelgate://GATE_A/GEOFENCE_001/abc123def/nonce-xyz/1700000000000
                      ^
                      ADD geofence_id here
```

OR via query params:
```
https://sentinel-gateweb-4sdy-5xlaqwa20.vercel.app/gate/qr?gate_id=GATE_A&geofence_id=GEOFENCE_001&totp=abc123def&nonce=nonce-xyz&expires_at=1700000000000
```

---

## Build Steps

### 1. Clean Flutter Cache
```bash
cd "C:\Users\email\OneDrive\Desktop\major\SentinalgAate\Student app\files (4)"
flutter clean
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Generate Drift Database Code
```bash
flutter pub run build_runner build
```

**This will:**
- Generate `lib/models/database.g.dart` with new schema columns
- Create migration logic for `geofenceId`, `embeddingHash`, `totpHash` fields

### 4. Analyze for Errors
```bash
flutter analyze
```

**Expected to fix or ignore:**
- ✅ Unused imports (removed `dart:math` from crypto_service)
- ✅ Dead null-aware expressions (already in code)
- ✅ Deprecated Color.withOpacity() → use .withValues() (cosmetic)
- ⚠️ New errors related to new EventResult fields (fix if any)

---

## Testing Before Deploy

### Unit Tests Needed
1. **QR Parsing Tests**
   - Test all 4 formats parse `geofence_id` correctly
   - Test fallback formats still work

2. **Payload Tests**
   - Verify payload structure matches backend expectations
   - Verify HMAC signature still validates

3. **Database Tests**
   - Verify schema migration creates new columns
   - Verify existing events still load

### Manual Integration Tests

**On a test device:**
1. Enrollment
   - [ ] Roll number entry works
   - [ ] Face enrollment captures and stores baseline
   - [ ] Routes to home after enrollment

2. Check-out Flow (Short Leave)
   - [ ] Scan QR with geofence_id
   - [ ] Face scan passes
   - [ ] Select reason (< 5 hrs expected duration)
   - [ ] Event syncs to backend immediately
   - [ ] Event appears in history

3. Check-in Flow
   - [ ] Scan same QR
   - [ ] Face scan passes
   - [ ] Event syncs to backend
   - [ ] Status changes to "Inside Campus"

4. Database
   - [ ] Open SQLite browser
   - [ ] Verify `gate_events` has new columns: `geofence_id`, `embedding_hash`, `totp_hash`
   - [ ] Verify event records have values in these columns

---

## Deployment Checklist

Before pushing to production:

- [ ] All QR codes from gate tablet include `geofence_id`
- [ ] Backend API fully accepts new payload schema
- [ ] Android build passes (check `build.gradle`)
- [ ] All permissions are granted in `AndroidManifest.xml`:
  - `CAMERA` (for face scan)
  - `ACCESS_FINE_LOCATION` (for GPS)
  - `INTERNET` (for API)
- [ ] Firebase/Sentry logging configured for errors
- [ ] APK signed with production keystore

---

## Known Limitations (Document in Release Notes)

1. **GPS Accuracy in Urban Canyon**
   - GPS may show ±60m error under concrete overhangs
   - Geofence radius should have 15-30m buffer
   - Mitigation: Warden can override manually

2. **Face Recognition in Low Light**
   - Liveness may fail in dark rooms
   - App auto-brightens screen during scan
   - Mitigation: Ensure gate area is well-lit

3. **Offline Sync**
   - Events queue locally if network is down
   - WorkManager syncs every 15 minutes when network returns
   - After 5 retries (3+ hours), event is abandoned
   - Mitigation: Manual "Guard Console Override" in admin dashboard

---

## Rollback Plan (If Issues)

If the app crashes or doesn't connect:

1. **Revert to Previous Commit**
   ```bash
   git log --oneline | head -5
   # Find the commit before "Align student app flow..."
   git checkout <previous-commit-hash>
   flutter pub get
   flutter run
   ```

2. **Quick Hotfix Path**
   - Fix the issue in a new branch
   - Commit to that branch
   - Test locally
   - Merge to main

3. **Notify Users**
   - If backend is incompatible, backend team must revert their changes
   - Both must be synchronized

---

## Success Criteria

App is ready for production when:

✅ All QR codes parse with geofence_id  
✅ API calls reach `/api/*` endpoints  
✅ Gate auth payloads include `embedding_hash` and `totp_value`  
✅ Database stores all 3 hash fields (`geofenceId`, `embeddingHash`, `totpHash`)  
✅ Short-leave events sync immediately  
✅ Long-leave events defer write until approval (screen logic pending)  
✅ No build errors or warnings  
✅ Manual test on device passes all flows  
✅ Backend confirms new payload schema accepted  

---

## Questions for Backend/DevOps Team

1. **API Path Confirmation**
   - Is the backend ready for `/api` instead of `/api/v1`?
   - Any DNS/load balancer changes needed?

2. **Payload Validation**
   - Will you reject payloads missing `embedding_hash`?
   - Will you accept both old and new schemas during transition?

3. **Geofence Delivery**
   - How will geofence zones be synced to the app?
   - Is `/sync/delta` endpoint ready?

4. **Build Status**
   - Any changes to GitHub Actions CI/CD needed?
   - Any security scanning or signing required?


