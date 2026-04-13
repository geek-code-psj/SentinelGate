# SentinelGate — Student App

**Decentralized Multi-Factor Spatial-Temporal Campus Authentication**

Flutter Android app: Dynamic QR → GPS Geofence → Face Liveness PAD
with HMAC-SHA256 signed payloads, offline-first sync, SNTP clock correction.

---

## Setup in 4 Steps

### 1. Install dependencies
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 2. Configure your server
Edit `lib/utils/constants.dart`:
```dart
static const String intranetBaseUrl = 'http://192.168.1.100:3000/api/v1';
static const String cloudBaseUrl    = 'https://your-server.com/api/v1';
```

### 3. Configure campus GPS (for dev without server)
In `lib/services/gate_event_service.dart`, set your gate's actual coordinates.

### 4. Run
```bash
flutter run --release
```

---

## Project Structure
```
lib/
├── main.dart                    # Entry point + WorkManager registration + routes
├── models/database.dart         # 5 Drift tables: Students, GateEvents, SpoofAttempts, GeofenceZones, GateTokens
├── services/
│   ├── sntp_service.dart        # Server clock sync, Clock_Delta, anti-cheat
│   ├── crypto_service.dart      # HMAC-SHA256, Android KeyStore vault
│   ├── face_service.dart        # ML Kit BlazeFace PAD, 7-landmark embedding hash
│   ├── geo_service.dart         # Haversine point-in-circle geofence
│   ├── totp_service.dart        # QR parse + SNTP-validated expiry
│   ├── gate_event_service.dart  # The 5-phase state machine
│   ├── api_service.dart         # Dual intranet/cloud, HMAC headers
│   ├── sync_service.dart        # Transactional outbox, exponential backoff, LWW
│   ├── spoof_log_service.dart   # Silent failure logging
│   └── approval_service.dart    # Long-leave doc capture + upload
├── screens/
│   ├── splash_screen.dart       # Phase 0: boot + background sync
│   ├── login_screen.dart        # Device enrollment
│   ├── home_screen.dart         # Dashboard (status, sync indicator, SNTP delta)
│   ├── checkout_screen.dart     # Exit flow: Reason → QR → Face → [Approval] → Result
│   ├── checkin_screen.dart      # Return flow: QR → Face → Result
│   └── history_screen.dart      # Student's event log with sync status icons
└── utils/
    ├── app_theme.dart           # Material 3 theme
    └── constants.dart           # All config in one place

android/
└── app/
    ├── build.gradle             # minSdk 21 (Android 5.0+, 99% of India)
    ├── proguard-rules.pro       # Keeps ML Kit, Drift, WorkManager classes
    └── src/main/
        └── AndroidManifest.xml  # Camera, GPS, internet, WorkManager permissions

docs/
└── PHASES.md                   # 9 future phases roadmap
```

---

## Authentication State Machine

```
Phase 0 (App open):  SNTP sync → check enrollment → background outbox flush

Phase 1 (Checkout):  Pick reason + expected return time
Phase 2 (QR):        Scan rotating QR → parse Gate_ID / TOTP / Nonce / ExpiresAt
Phase 2A (TOTP):     Validate expiry using SNTP time (phone time ignored)
Phase 2B (GPS):      Haversine check — must be within 50m of gate
Phase 2C (Face):     ML Kit PAD — eye openness + head pose liveness check
Phase 3 (Branch):    If Home + duration > 5h → require warden approval doc
Phase 4 (Crypto):    Bundle payload → HMAC-SHA256 sign → write SQLite immediately
Phase 5 (Dispatch):  Try intranet → try cloud → park in outbox if both unreachable
```

---

## Security Summary

| Threat | Defence |
|--------|---------|
| Student sends screenshot of QR | QR expires every 30 seconds (SNTP-verified) |
| Student changes phone time | SNTP delta applied to all timestamps |
| Student outside campus | Haversine geofence ≤ 50m, GPS accuracy checked |
| Proxy attendance (friend scans) | Face liveness PAD on front camera |
| Network replay attack | HMAC-SHA256 with nonce + 60s timestamp window |
| Tampering GPS in transit | Any change breaks HMAC signature |
| Raw biometric data exposed | Only liveness_score (double) transmitted, never image |

---

## Building Release APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

minSdk = **21** (Android 5.0) — covers 99%+ of active Android devices in India.

## Common Issues
- `database.g.dart missing` → Run `dart run build_runner build`
- `GPS timeout` → Move to open sky, disable battery saver
- `Face not detected` → Good lighting, look at front camera directly
- `QR expired` → Ask warden to refresh (rotates every 30s)
- `Pending sync` → Normal — events saved locally, auto-syncs on network
