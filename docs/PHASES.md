# SentinelGate — Future Phases Roadmap

## Phase 1 (Current): Student Mobile App — Android
What is built now:
- Triple-Lock checkout/checkin (Dynamic QR → GPS → Face Liveness PAD)
- HMAC-SHA256 signed payloads with Android KeyStore
- SNTP clock sync (anti-cheat)
- Offline-first SQLite with transactional outbox sync
- Warden approval flow for long leave (> 5 hours)
- Silent spoof attempt logging
- Background WorkManager sync

---

## Phase 2: Warden Dashboard (Web)
**What**: React + TypeScript web app for wardens and administrators.

Key screens:
- Live occupancy board — green/red dots per student, real-time WebSocket updates
- Student exit log — filterable by gate, reason, time, floor
- Anomaly alerts — auto-flagged overstays, mass exits, repeat spoof attempts
- Approval queue — pending warden approval letters with accept/reject
- Export — PDF/CSV reports for disciplinary committee

Tech: React, TypeScript, Recharts, WebSocket, PostgreSQL + PostGIS, Node.js/Express

---

## Phase 3: ML Anomaly Detection Backend
**What**: Behavioural intelligence layer on top of raw event data.

Components:
- Synthetic dataset generation using Agent-Based Modelling (ABM) + CTGAN
- Baseline: XGBoost / Random Forest for individual point anomalies
- Advanced: Spatio-Temporal Graph Neural Network (ST-GNN / CoBAD framework)
  - Models students as nodes, gate transitions as edges
  - Detects coordinated proxy fraud rings (group of students all exiting simultaneously with implausible stated reasons)
  - 13-18% AUCROC improvement over tabular baselines
- Anomaly categories: temporal (3am access), spatial (teleportation), frequency (brute force)

---

## Phase 4: Multi-Gate Coordination
**What**: Cross-gate ghost detection.

Logic:
- Student exits Gate A at 14:30
- System expects Gate A entry or Gate B entry by 23:59
- If no return scan by curfew → auto-alert to warden
- Ghost window: student exited Gate A, entered Gate B (different gate) — system reconciles

Implementation:
- Server-side Celery task that runs at curfew time
- Checks for all OUT events with no corresponding IN event
- Weighted by risk score (repeat offender, long absence, implausible reason)

---

## Phase 5: Geo-Locked Documents
**What**: Campus documents that can only be opened within the campus geofence.

Use case: Warden circulars, exam hall tickets, hostel rules — cannot be opened if student is outside campus.

Implementation:
- Backend generates time-limited signed URL
- URL includes GPS check endpoint
- App verifies student is within campus polygon before decrypting document
- Document is AES-256 encrypted; key only released by server after GPS verification

---

## Phase 6: iOS Support
**What**: Same Flutter app targeting iOS with equivalent security primitives.

Changes required:
- Replace Android KeyStore with Apple Keychain (already supported by flutter_secure_storage)
- Replace WorkManager with iOS Background Tasks
- Test ML Kit face detection on iOS (same API, different performance profile)
- App Store review preparation (biometric data justification)

---

## Phase 7: Queuing Theory Adaptive Throughput
**What**: Dynamic gate mode switching during mass exits (Friday evenings, semester end).

Logic (from SentinelGate master plan):
- Monitor arrival rate λ and service rate μ per gate
- Compute utilisation ρ = λ / (s × μ)
- If ρ → 1.0: switch to simplified single-factor mode (face only, no QR scan)
- When ρ normalises: restore full triple-lock

Mathematical foundation: M/M/s/∞/∞/FIFO queuing model (Kendall notation)

---

## Phase 8: Blockchain Audit Trail
**What**: Immutable, tamper-proof log of every aggregation event.

Implementation:
- Permissioned blockchain: Hyperledger Fabric or Ethereum Ganache testnet
- On every successful gate event: write hash(eventId + studentId + timestamp + hmac) to chain
- Smart contract enforces: duplicate event IDs are rejected at chain level
- Warden can verify any exit event via blockchain explorer without trusting the database

---

## Phase 9: Parent Notification System
**What**: Auto SMS/WhatsApp to parent when student is outside > expected duration.

Logic:
- Student exits, states expectedReturn = 8:00 PM
- If no checkin by 8:30 PM → send notification to registered parent number
- Escalation: if no checkin by 10:00 PM → notify both parent and college security
- Override: student can request 1-hour extension from app (requires re-authentication)

---

## Deployment Architecture (Target)

```
Campus Intranet (Primary)
├── Node.js/Express API server (192.168.x.x:3000)
├── PostgreSQL + PostGIS (geofence zones, events, students)
├── Redis (nonce cache, session store)
└── ML microservice (Python FastAPI, XGBoost + ST-GNN inference)

Cloud (Fallback + Remote Access)
├── Same stack on AWS/GCP/Railway
├── Sync with intranet via encrypted replication
└── Warden dashboard accessible from anywhere

Student Devices
├── Flutter Android app (API 21+)
├── Offline-first SQLite (Drift)
└── WorkManager background sync
```
