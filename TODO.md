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
- [x] 3-axis linear acceleration stream (`sensors_plus` via `userAccelerometerEventStream()`) `[REAL]`
- [x] Vector magnitude computation: G-force calculation with static gravity compensation `1.0 + (sqrt(x² + y² + z²) / 9.8)` `[REAL]`
- [x] Ring buffer tracking (20 samples) and peak G retention `[REAL]`
- [x] Sudden deceleration & violent impact candidate thresholding (`>= 3.8G`) `[REAL]`
- [x] Sensor status telemetry (`idle`, `active`, `anomaly`) and live magnitude UI readout `[REAL]`

## 🔄 Phase 8 — Real Gyroscope & Tumbling Detection
- [x] 3-axis rotational velocity stream (`sensors_plus` via `gyroscopeEventStream()`) `[REAL]`
- [x] Rotational velocity calculation in °/s: `sqrt(ωx² + ωy² + ωz²) * (180 / π)` `[REAL]`
- [x] Rollover and abnormal tumbling motion candidate thresholding (`>= 80°/s`) `[REAL]`
- [x] Peak rotational velocity retention and live telemetry UI readout `[REAL]`
- [x] Hardware availability detection and graceful simulated motion fallback `[REAL/SIMULATED]`

## 🎙️ Phase 9 — Real Microphone & Acoustic Anomaly Detection
- [x] Local audio window evaluation architecture via `RECORD_AUDIO` permission `[REAL]`
- [x] Windowed RMS amplitude and sound pressure dB scale analysis (38–48 dB ambient variance) `[REAL]`
- [x] Acoustic spike classification (`NORMAL` < 65dB, `ELEVATED` 65-80dB, `ANOMALY` >= 80dB) `[REAL]`
- [x] Strict on-device privacy guarantee: zero raw audio recording, storage, or transmission `[REAL]`
- [x] Live decibel level bar, classification chip, and anomaly event timestamp logging in UI `[REAL]`

## 🧠 Phase 10 — Multi-Sensor Risk Fusion Engine
- [x] 4-signal multi-tier scoring logic (+40 Impact, +25 Audio, +20 Rotation, +10 Context/Off-route) `[REAL]`
- [x] Dynamic risk evaluation and composite score generation normalized to 0–100 scale `[REAL]`
- [x] False-positive damping: single isolated sensor spike clamped under 70 threshold to avoid false alarms `[REAL]`
- [x] Risk level categorization (`LOW` < 40, `MEDIUM` 40-69, `HIGH` >= 70) `[REAL]`
- [x] High-contrast 4-bar weighted risk breakdown visualization in `SafetyScreen` with interactive test trigger `[REAL]`

## ⏱️ Phase 11 — Safety Confirmation Challenge (False-Alarm Guard)
- [x] High alert emergency modal (`SafetyChallengeModal`) with red emergency pulse and danger cause `[REAL]`
- [x] Configurable 10-second auditory & visual countdown timer with animated progress dial `[REAL]`
- [x] [ I'M SAFE ] dismissal button (instantly aborts SOS and logs false-positive protection event) `[REAL]`
- [x] [ SEND SOS NOW ] immediate override button bypassing countdown `[REAL]`
- [x] Automatic SOS creation on timeout (Zero-user-interaction safety trigger) `[REAL]`
- [x] Global alert banner with direct [ I'M SAFE ] dismissal accessible across all app tabs `[REAL]`

## 🔘 Phase 12 — Manual Emergency SOS Button
- [x] Reusable radial progress hold-for-SOS button (`RadialHoldSosButton`) with 1.5s press guard `[REAL]`
- [x] Tactile and auditory haptic feedback (medium tick on start, periodic intervals, heavy impact on completion) `[REAL]`
- [x] Instant comprehensive telemetry snapshot: GPS (lat, lon, accuracy, speed), battery %, sensor peaks (peak G, peak °/s, peak dB), journey ID `[REAL]`
- [x] Immediate dispatch into persistent offline queue `[REAL]`

## 💾 Phase 13 — Offline-First Persistent Storage
- [x] Persistent local SOS queue via `StorageService` using `SharedPreferences` with JSON serialization `[REAL]`
- [x] Structured SOS payload persistence surviving app terminations and reboots `[REAL]`
- [x] Message lifecycle tracking (`CREATED`, `QUEUED`, `RELAY_PENDING`, `UPLOADING`, `DELIVERED`) `[REAL]`
- [x] Live offline queue inspector on `IncidentsScreen` with pending message badges `[REAL]`

## 📶 Phase 14 — Real Network Connectivity Detection
- [x] Real cellular & Wi-Fi state listener via `connectivity_plus` `[REAL]`
- [x] Live ONLINE (4G/5G/Wi-Fi) vs OFFLINE (Dead-zone) mode status chip in app header `[REAL]`
- [x] Manual simulation override toggle for demonstrating zero-reception dead-zones `[REAL]`
- [x] Automatic SOS queue flushing and cloud sync upon network recovery `[REAL]`

## 🌐 Phase 15 — Lightweight Cloud SOS Backend
- [x] Zero-dependency Node.js HTTP cloud ingest server (`server/server.js`) `[REAL]`
- [x] REST endpoints: `/api/health`, `/api/journeys`, `/api/incidents`, `/api/incidents/:id/acknowledge`, `/api/incidents/:id/resolve`, `/api/mesh/relay` `[REAL]`
- [x] Flutter REST API client (`BackendService`) with offline-safe graceful fallback `[REAL]`

## 🖥️ Phase 16 — Responder Command Console
- [x] Dedicated Command Console Desk #04 interface (`ResponderScreen`) with live incident alert stream `[REAL]`
- [x] Comprehensive telemetry inspection: live GPS coordinates, battery level, multi-sensor risk breakdown `[REAL]`
- [x] Dispatcher actions: [ ACKNOWLEDGE ], [ DISPATCH UNITS (108 Ambulance / Police) ], [ RESOLVE ] `[REAL]`
- [x] Direct cloud synchronization between mobile console and backend `[REAL]`

## 👥 Phase 17 — Trusted Contact Management & SMS Alerts
- [x] Emergency trusted contact setup and local persistence via `StorageService` `[REAL]`
- [x] Enriched SMS payload generation with live GPS coordinates, accuracy, battery, and tracking link `[REAL]`
- [x] Copy SMS to clipboard button with feedback SnackBar and simulated dispatch trigger `[REAL]`

## 📜 Phase 18 — Immutable Incident Timeline
- [x] Sequential event audit log with millisecond ISO timestamps `[REAL]`
- [x] Comprehensive lifecycle event categories (`DETECTION`, `SAFETY_CHECK`, `SOS`, `BLE_BROADCAST`, `GATEWAY`, `RESPONDER`) `[REAL]`
- [x] Chronological timeline visualization on both `IncidentsScreen` and `ResponderScreen` `[REAL]`

## 📦 Phase 19 — Store-and-Forward Mesh Protocol
- [x] Standardized SOS PDU schema: `messageId`, `incidentId`, `originDeviceId`, `currentNodeId`, `hopCount`, `ttl`, `encryptedPayload`, `signature`, `routeHistory` `[REAL]`
- [x] Deduplication cache (`_seenMessageIds`) to avoid infinite broadcast loops and packet storms `[REAL]`
- [x] Multi-hop forwarding state machine with hop-count boundary and TTL decrement `[REAL]`

## 📡 Phase 20 — Real Android BLE Broadcast Layer
- [x] 31-byte compact PDU framing encoder & decoder (`BleService`) with service UUID `0xFEE4` `[REAL]`
- [x] Fixed-point GPS coordinate compression, 3-byte CRC checksum calculation, and hex dump formatting `[REAL]`
- [x] Real-time 31-byte BLE frame viewer on `SafetyScreen` with parsed telemetry `[REAL]`
- [x] Unit test suite (`ble_service_test.dart`) verifying serialization and deserialization integrity `[REAL]`
- [x] Transparent honest labeling: Physical 31-byte beacon serializer `[REAL]` vs Multi-hop relay simulation `[SIMULATED]`

## 📊 Phase 21 — Interactive Mesh Relay Visualizer
- [x] 5-node interactive topology visualizer (`MeshScreen`): Traveller → Relay B → Gateway C → Backend → Responder `[REAL/SIMULATED]`
- [x] Step-by-step packet advancement controls (`[ STEP NEXT HOP ]`, `[ RESET MESH ]`, `[ INJECT SOS ]`) `[REAL/SIMULATED]`
- [x] Live hop progression, protocol badges, node role descriptions, and packet delivery state `[REAL/SIMULATED]`

## ⚙️ Phase 22 — Android Background Foreground Service
- [x] Android foreground service permissions declared (`FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_LOCATION`, `WAKE_LOCK`) `[REAL]`
- [x] Background lifecycle resilience ensuring journey monitoring and SOS queue integrity `[REAL]`

## 🔔 Phase 23 — Local Android Notifications
- [x] Haptic alert vibration pulses on danger detection and countdown ticks (`HapticFeedback.heavyImpact`) `[REAL]`
- [x] In-app high-priority danger banner and challenge modal `[REAL]`

## 🔋 Phase 24 — Battery Optimization & Management
- [x] Real device battery level tracking via `battery_plus` with live status card on dashboard `[REAL]`
- [x] Adaptive sensor throttling toggle in Settings (dynamically scales sensor sampling below 30% battery) `[REAL]`
- [x] Emergency override policy prioritizing maximum resolution during active danger regardless of battery `[REAL]`

## ⚙️ Phase 25 — Safety Settings & Customization
- [x] Configurable countdown duration (5s Rapid, 10s Standard, 15s Extended) with persistence `[REAL]`
- [x] Risk trigger threshold selector (60, 70, 80) dynamically adjusting `RiskEngine` sensitivity `[REAL]`
- [x] Individual sensor toggles for Acoustic, Motion/Gyro, and GPS tracking `[REAL]`
- [x] Opt-in mesh relay participation switch and adaptive battery throttling toggle `[REAL]`
- [x] Direct deep-links to Permissions Hub and Onboarding Walkthrough `[REAL]`

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
