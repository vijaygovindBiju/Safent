# Travel SOS Mesh — 3-Day Android-First Engineering Sprint (SC-03)

**Project:** Travel SOS Mesh  
**Product:** Late-Night Journey Safety Companion  
**Team:** Maravazha  
**Members:** Vijaygovind Biju, Noel Paul Tomy  
**Challenge:** SC-03 — Late-night journey safety companion  
**Target Platform:** Physical Android Device (Flutter / Dart + Android Native)  

---

### Implementation Status Notation
- `[REAL]`: Direct on-device hardware execution (Android GPS/Location, 3-Axis Accelerometer, Gyroscope, Battery status, Network connectivity detection, Local persistent storage).
- `[SIMULATED]`: High-fidelity mathematical and interactive models running on phone (BLE 5.2 multi-hop store-and-forward relay packets, peer discovery, 5G gateway uplink, responder command dispatch, emergency SMS).
- `[PLANNED]`: Future production hardening (Certified PSAP emergency gateway integration, native C++ BLE mesh background daemon, AWS GovCloud encrypted storage).

### Task Status Legend
- `[ ]` NOT STARTED
- `[~]` IN PROGRESS
- `[x]` COMPLETED
- `[!]` BLOCKED

---

## 📱 Phase 1 — Android Application Foundation
- [x] Flutter Android project initialized (`com.maravazha.travel_sos_mesh`) `[REAL]`
- [x] Android package / application ID configured with `minSdk = 23` `[REAL]`
- [x] Hardware & network Android permissions declared in `AndroidManifest.xml` (`ACCESS_FINE_LOCATION`, `RECORD_AUDIO`, `INTERNET`, `BLUETOOTH_SCAN`, etc.) `[REAL]`
- [x] Dark safety theme (`AppTheme.darkTheme`) and high-contrast color palette (`AppColors`) `[REAL]`
- [x] Core data models (`LocationPoint`, `Journey`, `RiskFusionScore`, `Incident`, `SOSMessage`, `MeshNode`) `[REAL]`
- [x] State management architecture (`SafetyProvider` with `ChangeNotifierProvider`) `[REAL]`
- [x] Persistent offline storage service (`SharedPreferences` with JSON serialization) `[REAL]`
- [x] Primary screens implemented:
  - [x] `HomeScreen`: Status summary cards, journey trigger, demo launcher `[REAL]`
  - [x] `JourneyScreen`: Destination setup + real OpenStreetMap view (`flutter_map`) with offline fallback `[REAL]`
  - [x] `SafetyScreen`: Real-time hardware telemetry display, risk breakdown, 10s challenge modal, radial hold-for-SOS button `[REAL]`
  - [x] `IncidentsScreen`: Offline SOS storage queue & immutable event timeline `[REAL]`
  - [x] `ResponderScreen`: Response Center Command Console (#04) with GPS, ACK, Dispatch, Resolve, and SMS preview `[REAL/SIMULATED]`
  - [x] `SettingsScreen`: Sensor monitoring toggles, challenge duration, risk thresholds, privacy architecture `[REAL]`
  - [x] `MeshScreen`: 5-node store-and-forward interactive relay visualizer `[SIMULATED]`
- [x] Navigation bar architecture (`MainNavigationScreen` with Material 3 `NavigationBar` & quick action bar) `[REAL]`
- [x] Zero analyzer issues (`flutter analyze` clean) `[REAL]`
- [x] Android debug APK build compilation verification `[REAL]`

---

## 🚀 Phase 2 — Onboarding & Dynamic Permissions
- [x] 4-pillar onboarding flow (`OnboardingScreen`) explaining Journey Monitoring, Safety Detection, Offline SOS, and Mesh Relay `[REAL]`
- [x] First-time launch routing & persistent completion flag in `StorageService` (`isOnboardingCompleted`) `[REAL]`
- [x] Dynamic on-demand permission handling (`PermissionService`) for Location, Microphone, Notifications, and Bluetooth `[REAL]`
- [x] Comprehensive Permissions Hub (`PermissionsScreen`) with live status badges (`GRANTED`, `DENIED`, `BLOCKED`, `N/A`) `[REAL]`
- [x] Clear actionable recovery instructions with direct link to Android App Settings via `openAppSettings()` `[REAL]`
- [x] Replay walkthrough & Permissions Hub access integrated directly into `SettingsScreen` `[REAL]`
- [x] Dynamic on-demand permission triggering before journey tracking begins in `JourneyScreen` `[REAL]`

## 🏠 Phase 3 — Home Dashboard & Quick Access
- [x] Premium header with "Travel SOS Mesh" brand and "Safety that works beyond the network." subtitle `[REAL]`
- [x] 6-card glanceable status grid: Journey (Inactive/Active), Network (Online/Offline), Safety (Monitoring/Not Monitoring), Battery (XX%), Nearby Relay (2 Devices), Location (GPS Fix / Coordinates) `[REAL]`
- [x] Primary CTA: [ START JOURNEY ] (or [ VIEW JOURNEY ] when active) `[REAL]`
- [x] Secondary CTA: [ RUN DEMO ] / [ STOP ] with live percentage and step ticker `[REAL]`
- [x] Emergency CTA: High-contrast [ EMERGENCY SOS ] button `[REAL]`
- [x] Compact mesh concept explainer banner ("If your phone loses Internet...") `[REAL]`
- [x] Interactive network simulation toggle (tap Network card to simulate offline dead-zone) `[REAL]`

## 🗺️ Phase 4 — Journey Setup & Preferences
- [x] Journey naming field with quick presets ('Transit Home', 'Campus Commute', 'Night Cab') `[REAL]`
- [x] Destination configuration with location presets ('Home (Panampilly)', 'College (CUSAT)', 'Kochi (MG Road)', 'Airport (COK)', 'InfoPark') `[REAL]`
- [x] Expected arrival duration selector (15m, 30m, 45m, 60m) `[REAL]`
- [x] Emergency trusted contact inputs (Name, Phone) with local persistence via `StorageService` `[REAL]`
- [x] On-device sensor monitoring toggles (Audio Anomaly, Motion/Impact, GPS Breadcrumbs) `[REAL]`
- [x] Unique Journey ID generation (`JNY-XXXXXXXX`) with local state persistence across reboots `[REAL]`
- [x] Dynamic runtime permission checks triggered before journey activation `[REAL]`

## 📍 Phase 5 — Real Map & Offline Fallback
- [x] Real OpenStreetMap tile rendering via `flutter_map` without requiring expensive third-party API keys `[REAL]`
- [x] Live device GPS positioning marker with rotational heading arrow `[REAL]`
- [x] Dynamic GPS accuracy radius circle (`CircleLayer`) rendered in meters `[REAL]`
- [x] Real-time breadcrumb trail polyline (`PolylineLayer`) tracing travel path `[REAL]`
- [x] Destination pin marker with distance calculation via `Geolocator.distanceBetween` `[REAL]`
- [x] Nearby mesh relay peer visualization (Node B) plotted ~150m along transit corridor `[REAL/SIMULATED]`
- [x] Graceful offline canvas fallback preserving polyline, markers, and distance readouts when disconnected `[REAL]`

## 🛰️ Phase 6 — Real Location Tracking System
- [x] Android GPS geolocator integration via `geolocator` with fine/coarse permission checks `[REAL]`
- [x] Full telemetry capture: Latitude, Longitude, Altitude, Accuracy (±X m), Speed (km/h), Heading (°), and Timestamp `[REAL]`
- [x] Adaptive location sampling: battery-saving filter (10m / high accuracy) in transit, high-frequency (2m / best accuracy) in active emergency `[REAL]`
- [x] GPS signal states: `searching`, `locked`, `lost`, `permissionDenied`, `serviceDisabled` `[REAL]`
- [x] Location failure guards with graceful fallback to last-known coordinates `[REAL]`
- [x] Clear UI designation: "REAL DEVICE LOCATION" when live GPS is active `[REAL]`

## 📳 Phase 7 — Real Accelerometer & Impact Detection
- [ ] 3-axis accelerometer stream (`sensors_plus`) `[REAL]`
- [ ] Vector magnitude computation: `sqrt(x² + y² + z²)` `[REAL]`
- [ ] Sudden deceleration & violent impact candidate thresholding (`>= 3.8G`) `[REAL]`
- [ ] Real-time magnitude & peak G tracking readout `[REAL]`

## 🔄 Phase 8 — Real Gyroscope & Tumbling Detection
- [ ] 3-axis gyroscope stream (`sensors_plus`) `[REAL]`
- [ ] Rotational velocity calculation in °/s `[REAL]`
- [ ] Rollover and abnormal tumbling motion candidate thresholding (`>= 80°/s`) `[REAL]`
- [ ] Live rotational telemetry readout `[REAL]`

## 🎙️ Phase 9 — Real Microphone & Acoustic Anomaly Detection
- [ ] Local audio window sampling via Android microphone `[REAL]`
- [ ] RMS amplitude calculation and dB level analysis `[REAL]`
- [ ] Acoustic spike classification (Normal, Elevated, Anomaly) `[REAL]`
- [ ] Zero raw audio recording or transmission guarantee `[REAL]`

## 🧠 Phase 10 — Multi-Sensor Risk Fusion Engine
- [ ] Multi-signal scoring logic (+40 Impact, +25 Audio, +20 Rotation, +10 Context) `[REAL]`
- [ ] Dynamic risk evaluation and score generation (0–100) `[REAL]`
- [ ] False-positive damping (prevent single-sensor false alarms) `[REAL]`
- [ ] Risk level categorization (LOW, MEDIUM, HIGH) `[REAL]`

## ⏱️ Phase 11 — Safety Confirmation Challenge (False-Alarm Guard)
- [ ] High alert emergency modal (`⚠ POSSIBLE DANGER DETECTED`) `[REAL]`
- [ ] 10-second auditory & visual countdown timer `[REAL]`
- [ ] [ I'M SAFE ] dismissal button (logs false-positive protection) `[REAL]`
- [ ] [ SEND SOS NOW ] immediate override button `[REAL]`
- [ ] Automatic SOS creation on timeout (Zero-user-interaction safety) `[REAL]`

## 🔘 Phase 12 — Manual Emergency SOS Button
- [ ] Radial progress hold-for-SOS button (1.5s press guard) `[REAL]`
- [ ] Instant snapshot: GPS, Battery, Sensor peaks, Journey ID `[REAL]`
- [ ] Immediate offline queue dispatch `[REAL]`

## 💾 Phase 13 — Offline-First Persistent Storage
- [ ] Persistent local SOS queue (`SharedPreferences` / SQLite) `[REAL]`
- [ ] Structured SOS payload persistence across app reboots `[REAL]`
- [ ] Message lifecycle tracking (`CREATED`, `QUEUED`, `RELAY_PENDING`, `UPLOADING`, `DELIVERED`) `[REAL]`

## 📶 Phase 14 — Real Network Connectivity Detection
- [ ] Real cellular & Wi-Fi state listener (`connectivity_plus`) `[REAL]`
- [ ] Live ONLINE / OFFLINE mode display `[REAL]`
- [ ] Simulation toggle for testing zero-reception dead-zones `[REAL]`
- [ ] Automatic SOS queue flushing upon network recovery `[REAL]`

## 🌐 Phase 15 — Lightweight Cloud SOS Backend
- [ ] Lightweight REST / WebSocket backend (FastAPI / Node.js) `[PLANNED]`
- [ ] Endpoints: `/api/journeys`, `/api/incidents`, `/api/incidents/:id/acknowledge` `[PLANNED]`
- [ ] Incident ingestion, decryption verification, and dispatch tracking `[PLANNED]`

## 🖥️ Phase 16 — Responder Command Console
- [ ] Real-time incident alert stream `[REAL/SIMULATED]`
- [ ] Incident telemetry display: GPS, Route history, Risk breakdown `[REAL/SIMULATED]`
- [ ] Dispatch actions: [ ACKNOWLEDGE ], [ DISPATCH UNITS ], [ RESOLVE ] `[REAL/SIMULATED]`

## 👥 Phase 17 — Trusted Contact Management & SMS Alerts
- [ ] Trusted emergency contact configuration `[REAL]`
- [ ] SMS payload generation with live GPS tracking URL `[REAL]`
- [ ] Automated dispatch trigger upon SOS confirmation `[SIMULATED]`

## 📜 Phase 18 — Immutable Incident Timeline
- [ ] Sequential event audit log with millisecond timestamps `[REAL]`
- [ ] Critical state tracking (Detection, Challenge, SOS Created, Mesh Hop, Gateway, Ack) `[REAL]`

## 📦 Phase 19 — Store-and-Forward Mesh Protocol
- [ ] Standardized SOS PDU schema: `messageId`, `originDeviceId`, `currentNodeId`, `hopCount`, `ttl`, `payload`, `signature` `[REAL]`
- [ ] Deduplication cache and TTL expiration logic `[REAL]`
- [ ] Multi-hop forwarding state machine `[REAL]`

## 📡 Phase 20 — Real Android BLE Broadcast Layer
- [ ] Native Android BLE Advertising & Scanning (`flutter_blue_plus` / Android Kotlin) `[PLANNED]`
- [ ] Encrypted 31-byte SOS beacon broadcast `[PLANNED]`
- [ ] Peer receiver & forwarder validation `[PLANNED]`
- [ ] Honest labeling: Physical BLE beacon vs Multi-hop simulation fallback `[REAL]`

## 📊 Phase 21 — Interactive Mesh Relay Visualizer
- [ ] 5-node visual topology (Traveller → Relay B → Gateway C → Backend → Responder) `[REAL/SIMULATED]`
- [ ] Step-by-step packet advancement and node state inspection `[REAL/SIMULATED]`

## ⚙️ Phase 22 — Android Background Foreground Service
- [ ] Persistent Android foreground notification `[PLANNED]`
- [ ] Continuous GPS, Accelerometer, and SOS queue operation while screen off `[PLANNED]`

## 🔔 Phase 23 — Local Android Notifications
- [ ] Local Android notification channels (Normal, Emergency High-Priority) `[PLANNED]`
- [ ] Audible alert upon dangerous event detection `[PLANNED]`

## 🔋 Phase 24 — Battery Optimization & Management
- [ ] Real device battery level tracking (`battery_plus`) `[REAL]`
- [ ] Adaptive sensor throttling based on risk level and battery percentage `[REAL]`

## ⚙️ Phase 25 — Safety Settings & Customization
- [ ] Monitoring toggles, countdown duration, risk threshold adjustment `[REAL]`
- [ ] Opt-in mesh relay participation toggle `[REAL]`

## 🛡️ Phase 26 — Privacy & Ethical Safeguards
- [ ] On-device sensor processing architecture documentation `[REAL]`
- [ ] Zero raw audio transmission, ephemeral TTL-based data policy `[REAL]`

## 🔐 Phase 27 — Practical Security Architecture
- [ ] Unique device IDs, tamper-evident timeline logging `[REAL]`
- [ ] AES-GCM-256 envelope and Ed25519 signature representation `[REAL/SIMULATED]`

## 🚨 Phase 28 — Robust Failure Handling
- [ ] Graceful degradation for GPS denial, sensor failure, or zero network `[REAL]`
- [ ] App restart recovery with persistent state `[REAL]`

## 🎬 Phase 29 — Automated 50-Second Demonstration Engine
- [ ] Full end-to-end automated sequence (00s Journey to 50s Acknowledged) `[REAL/SIMULATED]`
- [ ] Single-click [ RESET DEMO ] clean restore `[REAL]`

## 🗺️ Phase 30 — Map + Incident Visualization on Responder Console
- [ ] OpenStreetMap display with incident vector on responder dashboard `[REAL]`

## 🧭 Phase 31 — Native Android Bottom Navigation & Layout
- [ ] Material 3 NavigationBar with badges for active journey, danger, and pending SOS `[REAL]`
- [ ] Persistent emergency SOS button access `[REAL]`

## 🎨 Phase 32 — Safety UI/UX Polish
- [ ] Dark theme, high-contrast touch targets, typography hierarchy `[REAL]`

## 📱 Phase 33 — Real-Phone Demo Scenario Preparation
- [ ] Verification script on physical Android phone (Sensors, GPS, Dead-Zone, Recovery) `[PLANNED]`

## 📚 Phase 34 — Technical Documentation & Guides
- [ ] Comprehensive README update with Android installation instructions `[PLANNED]`
- [ ] Technical architecture & demo script docs `[PLANNED]`

## 🧪 Phase 35 — Comprehensive Testing
- [ ] Unit & widget smoke tests `[REAL]`
- [ ] Hardware sensor integration tests on physical Android device `[PLANNED]`

## 📦 Phase 36 — Build & Deployment
- [ ] Production debug & release APK builds `[REAL]`
- [ ] Backend & Responder deployment `[PLANNED]`

---

### Phase 1 Audit Summary (Completed)
- **Codebase:** Flutter 3.44.8 / Dart 3.12.2 / Android Gradle Plugin / Android SDK 36.
- **Application ID:** `com.maravazha.travel_sos_mesh`
- **Permissions:** Real fine/coarse GPS, record audio, Bluetooth admin/scan/advertise, wake lock, foreground service.
- **Screens:** 6 complete screens (Home, Journey, Safety, Incidents, Responder, Settings) + Mesh visualizer.
- **State & Storage:** `SafetyProvider` + `StorageService` (SharedPreferences) + `NetworkService` + `SensorService` + `LocationService`.
- **Static Analysis:** `flutter analyze` passed with 0 errors, 0 warnings.
