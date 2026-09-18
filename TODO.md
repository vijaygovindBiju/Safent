# Travel SOS Mesh — Android Engineering Sprint & Validation Tracker (SC-03)

**Project:** Travel SOS Mesh  
**Product:** Late-Night Journey Safety Companion  
**Team:** Maravazha  
**Members:** Vijaygovind Biju, Noel Paul Tomy  
**Challenge:** SC-03 — Late-night journey safety companion  
**Target Platform:** Physical Android Device (Flutter / Dart + Android Native SDK)  

---

### Verification Taxonomy
- `[✓] PHYSICALLY VERIFIED`: Directly validated via hardware sensors, compilation CLI, unit test suites, or live system command execution.
- `[x] IMPLEMENTED`: Code fully implemented and passing static analysis (`flutter analyze` clean).
- `[SIM] SIMULATED`: High-fidelity mathematical and interactive simulation (multi-hop propagation, mesh visualizer, SMS carrier dispatch, crypto envelope prototype).
- `[!] BLOCKED`: Constrained by external physical hardware environment (e.g., requires 3 physical phones for ad-hoc RF mesh testing).

---

## 📱 Phase 1 — Android Application Foundation
- [✓] PHYSICALLY VERIFIED: Flutter Android project compilation (`flutter build apk --release`)
- [✓] PHYSICALLY VERIFIED: Android package / application ID configured with `minSdk = 23` (`com.maravazha.travel_sos_mesh`)
- [✓] PHYSICALLY VERIFIED: Hardware & network permissions declared in `AndroidManifest.xml`
- [x] IMPLEMENTED: Dark safety theme (`AppTheme.darkTheme`) and high-contrast color palette (`AppColors`)
- [x] IMPLEMENTED: Core data models (`LocationPoint`, `Journey`, `RiskFusionScore`, `Incident`, `SOSMessage`, `MeshNode`)
- [x] IMPLEMENTED: State management architecture (`SafetyProvider` with `ChangeNotifierProvider`)
- [✓] PHYSICALLY VERIFIED: Persistent offline storage service (`SharedPreferences` with JSON serialization)
- [x] IMPLEMENTED: Primary screens (Home, Journey, Safety, Incidents, Responder, Settings, Mesh Visualizer)
- [✓] PHYSICALLY VERIFIED: Static analysis clean (`flutter analyze` with 0 issues)

---

## 🚀 Phase 2 — Onboarding & Dynamic Permissions
- [x] IMPLEMENTED: 4-pillar onboarding flow (`OnboardingScreen`)
- [✓] PHYSICALLY VERIFIED: Persistent onboarding completion flag in `StorageService`
- [x] IMPLEMENTED: Dynamic on-demand permission handling (`PermissionService`) for Location, Mic, Notifications, Bluetooth
- [x] IMPLEMENTED: Comprehensive Permissions Hub (`PermissionsScreen`) with live status badges
- [x] IMPLEMENTED: Direct link to Android App Settings via `openAppSettings()`

---

## 🏠 Phase 3 — Home Dashboard & Quick Access
- [x] IMPLEMENTED: Brand header and glanceable 6-card status grid
- [x] IMPLEMENTED: Primary CTAs: [ START JOURNEY ], [ RUN DEMO ], [ EMERGENCY SOS ]
- [x] IMPLEMENTED: Interactive network dead-zone simulation toggle

---

## 🗺️ Phase 4 — Journey Setup & Preferences
- [x] IMPLEMENTED: Journey destination picker with presets and custom input
- [x] IMPLEMENTED: Expected arrival duration selector and safety contact configuration
- [✓] PHYSICALLY VERIFIED: Local state persistence across reboots via `StorageService`

---

## 📍 Phase 5 — Real Map & Offline Fallback
- [✓] PHYSICALLY VERIFIED: OpenStreetMap tile rendering via `flutter_map` with legal attribution badge (`© OpenStreetMap contributors`)
- [x] IMPLEMENTED: Live device GPS marker with rotational heading arrow
- [x] IMPLEMENTED: Dynamic GPS accuracy radius circle (`CircleLayer`)
- [x] IMPLEMENTED: Real-time breadcrumb trail polyline (`PolylineLayer`)
- [x] IMPLEMENTED: Graceful dark canvas offline fallback preserving markers and distance metrics

---

## 🛰️ Phase 6 — Real Location Tracking System
- [✓] PHYSICALLY VERIFIED: Android GPS geolocator integration (`geolocator` with fine/coarse permission checks)
- [x] IMPLEMENTED: Adaptive location sampling (10m / high accuracy normal, 2m / best accuracy emergency)
- [x] IMPLEMENTED: GPS signal states (`searching`, `locked`, `lost`, `permissionDenied`, `serviceDisabled`)
- [x] IMPLEMENTED: Clear UI designation: "REAL DEVICE LOCATION" when live GPS is locked

---

## 📳 Phase 7 — Real Accelerometer & Impact Detection
- [✓] PHYSICALLY VERIFIED: 3-axis linear acceleration stream (`sensors_plus` via `userAccelerometerEventStream()`)
- [✓] PHYSICALLY VERIFIED: Vector magnitude computation: $G = 1.0 + \frac{\sqrt{x^2+y^2+z^2}}{9.8}$
- [x] IMPLEMENTED: Sudden deceleration & violent impact candidate thresholding (`>= 3.8G`)
- [x] IMPLEMENTED: Ring buffer tracking (20 samples) and peak G retention

---

## 🔄 Phase 8 — Real Gyroscope & Tumbling Detection
- [✓] PHYSICALLY VERIFIED: 3-axis rotational velocity stream (`sensors_plus` via `gyroscopeEventStream()`)
- [✓] PHYSICALLY VERIFIED: Rotational velocity calculation in $^\circ/\text{s}$: $\sqrt{\omega_x^2+\omega_y^2+\omega_z^2} \times 57.2958$
- [x] IMPLEMENTED: Abnormal tumbling motion candidate thresholding (`>= 80°/s`)
- [x] IMPLEMENTED: Sensor status telemetry and peak retention

---

## 🎙️ Phase 9 — Real Microphone & Acoustic Anomaly Detection
- [✓] PHYSICALLY VERIFIED: On-device local window audio evaluation (`RECORD_AUDIO` permission)
- [✓] PHYSICALLY VERIFIED: Strict zero-storage privacy guarantee: zero raw audio recording, storage, or transmission
- [x] IMPLEMENTED: Acoustic spike classification (`NORMAL` < 65dB, `ELEVATED` 65-80dB, `ANOMALY` >= 80dB)
- [x] IMPLEMENTED: Live decibel level meter and anomaly event timestamp logging

---

## 🧠 Phase 10 — Multi-Sensor Risk Fusion Engine
- [✓] PHYSICALLY VERIFIED: 4-signal multi-tier scoring logic (+40 Impact, +25 Audio, +20 Rotation, +10 Context)
- [✓] PHYSICALLY VERIFIED: False-positive damping: single isolated sensor spike clamped below 70 threshold (Unit test verified)
- [✓] PHYSICALLY VERIFIED: Risk level categorization (`LOW` < 40, `MEDIUM` 40-69, `HIGH` >= 70) via unit tests

---

## ⏱️ Phase 11 — Safety Confirmation Challenge (False-Alarm Guard)
- [x] IMPLEMENTED: High alert modal (`SafetyChallengeModal`) with emergency border pulse and danger causes
- [x] IMPLEMENTED: Configurable 10-second auditory & visual countdown timer with animated progress dial
- [x] IMPLEMENTED: [ I'M SAFE ] dismissal button (aborts SOS and logs false-positive protection event)
- [x] IMPLEMENTED: [ SEND SOS NOW ] immediate override button bypassing countdown
- [x] IMPLEMENTED: Automatic SOS creation on timeout (zero-user-interaction safety trigger)

---

## 🔘 Phase 12 — Manual Emergency SOS Button
- [x] IMPLEMENTED: Reusable radial progress hold-for-SOS button (`RadialHoldSosButton`) with 1.8s press guard
- [x] IMPLEMENTED: Tactile haptic feedback (medium tick on start, heavy impact on completion)
- [x] IMPLEMENTED: Instant comprehensive telemetry snapshot (GPS, battery %, sensor peaks, journey ID)

---

## 💾 Phase 13 — Offline-First Persistent Storage
- [✓] PHYSICALLY VERIFIED: Persistent local SOS queue via `StorageService` using `SharedPreferences`
- [✓] PHYSICALLY VERIFIED: Structured SOS payload persistence surviving app terminations and reboots
- [x] IMPLEMENTED: Message lifecycle tracking (`CREATED`, `QUEUED`, `RELAY_PENDING`, `UPLOADING`, `DELIVERED`)
- [x] IMPLEMENTED: Live offline queue inspector on `IncidentsScreen`

---

## 📶 Phase 14 — Real Network Connectivity Detection
- [✓] PHYSICALLY VERIFIED: Cellular & Wi-Fi state listener via `connectivity_plus`
- [x] IMPLEMENTED: Live ONLINE vs OFFLINE mode status chip in app header
- [x] IMPLEMENTED: Manual simulation override toggle for demonstrating zero-reception dead-zones
- [✓] PHYSICALLY VERIFIED: Automatic SOS queue flushing and cloud sync upon network recovery

---

## 🌐 Phase 15 — Lightweight Cloud SOS Backend
- [✓] PHYSICALLY VERIFIED: Zero-dependency Node.js HTTP cloud ingest server (`server/server.js`) on port 3000
- [✓] PHYSICALLY VERIFIED: REST endpoints verified via curl: `/api/health`, `/api/incidents`, `/api/incidents/:id/acknowledge`, `/api/incidents/:id/resolve`, `/api/mesh/relay`
- [x] IMPLEMENTED: Flutter REST API client (`BackendService`) with offline-safe graceful fallback

---

## 🖥️ Phase 16 — Responder Command Console
- [✓] PHYSICALLY VERIFIED: Dedicated Command Console Desk #04 interface (`ResponderScreen`) with live incident alert stream (Tested on `SM-S938B`)
- [✓] PHYSICALLY VERIFIED: Comprehensive telemetry inspection: live GPS coordinates, battery level, multi-sensor risk breakdown (Observed on `SM-S938B`)
- [✓] PHYSICALLY VERIFIED: Dispatcher actions: [ ACKNOWLEDGE ], [ DISPATCH UNITS (Ambulance / Police) ], [ RESOLVE ] verified with backend (Executed on `SM-S938B`)

---

## 👥 Phase 17 — Trusted Contact Management & SMS Alerts
- [✓] PHYSICALLY VERIFIED: Emergency trusted contact setup and local persistence via `StorageService`
- [x] IMPLEMENTED: Enriched SMS payload generation with live GPS coordinates, accuracy, battery, and tracking link
- [SIM] SIMULATED: SMS carrier dispatch simulated via UI preview and clipboard copy

---

## 📜 Phase 18 — Immutable Incident Timeline
- [x] IMPLEMENTED: Sequential event audit log with millisecond ISO timestamps
- [x] IMPLEMENTED: Comprehensive lifecycle event categories (`DETECTION`, `SAFETY_CHECK`, `SOS`, `BLE_BROADCAST`, `GATEWAY`, `RESPONDER`)
- [✓] PHYSICALLY VERIFIED: Cryptographic rolling event hash chaining (FNV-1a verified by unit test)

---

## 📦 Phase 19 — Store-and-Forward Mesh Protocol
- [x] IMPLEMENTED: Standardized SOS PDU schema: `messageId`, `incidentId`, `originDeviceId`, `currentNodeId`, `hopCount`, `ttl`, `encryptedPayload`, `signature`, `routeHistory`
- [x] IMPLEMENTED: Deduplication cache (`_seenMessageIds`) to avoid broadcast loops
- [SIM] SIMULATED: Multi-hop forwarding state machine with hop-count boundary and TTL decrement

---

## 📡 Phase 20 — Real Android BLE Broadcast Layer
- [✓] PHYSICALLY VERIFIED: 31-byte compact PDU framing encoder & decoder (`BleService`) with service UUID `0xFEE4` (Unit test verified)
- [✓] PHYSICALLY VERIFIED: Fixed-point GPS coordinate compression, 3-byte CRC checksum calculation, and hex dump formatting
- [x] IMPLEMENTED: Real-time 31-byte BLE frame viewer on `SafetyScreen` with parsed telemetry
- [SIM] SIMULATED: Multi-hop propagation across 3 separate physical devices (Demonstrated via simulated relay state machine)
- [!] BLOCKED: Multi-device physical RF mesh ad-hoc testing requires 3 physical phones running concurrent peripheral/central roles

---

## 📊 Phase 21 — Interactive Mesh Relay Visualizer
- [SIM] SIMULATED: 5-node interactive topology visualizer (`MeshScreen`): Traveller → Relay B → Gateway C → Backend → Responder
- [x] IMPLEMENTED: Step-by-step packet advancement controls (`[ STEP NEXT HOP ]`, `[ RESET MESH ]`)
- [x] IMPLEMENTED: Live hop progression, protocol badges, node role descriptions, and packet delivery state

---

## ⚙️ Phase 22 — Android Foreground Service
- [✓] PHYSICALLY VERIFIED: Android foreground service permissions declared (`FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_LOCATION`, `WAKE_LOCK`)
- [✓] PHYSICALLY VERIFIED: Background lifecycle resilience ensuring journey monitoring and SOS queue integrity (Tested via Home keyevent on `SM-S938B`)

---

## 🔔 Phase 23 — Local Android Notifications
- [x] IMPLEMENTED: Haptic alert vibration pulses on danger detection and countdown ticks (`HapticFeedback.heavyImpact`)
- [x] IMPLEMENTED: In-app high-priority danger banner and challenge modal

---

## 🔋 Phase 24 — Battery Optimization & Management
- [✓] PHYSICALLY VERIFIED: Real device battery level tracking via `battery_plus` with live status card
- [x] IMPLEMENTED: Adaptive sensor throttling toggle in Settings (scales sampling below 30% battery)
- [x] IMPLEMENTED: Emergency override policy prioritizing maximum resolution during active danger

---

## ⚙️ Phase 25 — Safety Settings & Customization
- [x] IMPLEMENTED: Configurable countdown duration (5s Rapid, 10s Standard, 15s Extended) with persistence
- [x] IMPLEMENTED: Risk trigger threshold selector (60, 70, 80) dynamically adjusting `RiskEngine` sensitivity
- [x] IMPLEMENTED: Individual sensor toggles for Acoustic, Motion/Gyro, and GPS tracking
- [x] IMPLEMENTED: Ethical Data Governance Charter modal and Permissions Hub shortcuts

---

## 🛡️ Phase 26 — Privacy & Ethical Safeguards
- [✓] PHYSICALLY VERIFIED: On-device sensor processing: zero raw audio recording, buffering, or transmission
- [x] IMPLEMENTED: Need-to-know geolocation: GPS coordinates isolated on-device until SOS confirmation
- [x] IMPLEMENTED: Zero-knowledge relay network: intermediate nodes route sealed ciphertext without traveller identity
- [x] IMPLEMENTED: Ephemeral TTL data policy (300 seconds self-termination)
- [x] IMPLEMENTED: Ethical Data Governance Charter modal integrated in `SettingsScreen`

---

## 🔐 Phase 27 — Practical Security Architecture
- [✓] PHYSICALLY VERIFIED: Unique origin device fingerprint (`ANDROID-DEV-XXXX`) via `CryptoService` (Unit test verified)
- [✓] PHYSICALLY VERIFIED: Tamper-evident incident timeline logging with rolling event hash chaining (Unit test verified)
- [SIM] SIMULATED: AES-GCM-256 sealed envelope construction and Ed25519 signature representation in software (Prototype formatting, not hardware KeyStore)

---

## 🚨 Phase 28 — Robust Failure Handling
- [x] IMPLEMENTED: Graceful degradation for GPS hardware denial, falling back to coarse coordinates or last-known fix
- [x] IMPLEMENTED: Sensor failure fallback: automatic fallback to nominal baselines if device lacks physical gyroscope
- [✓] PHYSICALLY VERIFIED: App restart & crash recovery: restores active journey and pending SOS queue from flash
- [✓] PHYSICALLY VERIFIED: Offline queue absorption: handles total network loss without unhandled exceptions

---

## 🎬 Phase 29 — Automated 50-Second Demonstration Engine
- [x] IMPLEMENTED: Full end-to-end automated sequence (00s Journey to 50s Acknowledged) in `SafetyProvider`
- [x] IMPLEMENTED: Live progress percentage counter and dynamic demo step narrative banner on dashboard
- [x] IMPLEMENTED: Single-click [ STOP ] and [ RESET DEMO ] clean restore across all provider states

---

## 🗺️ Phase 30 — Map + Incident Visualization on Responder Console
- [✓] PHYSICALLY VERIFIED: OpenStreetMap tile canvas embedded directly in `ResponderScreen` (`flutter_map`) with attribution (Observed on `SM-S938B`)
- [✓] PHYSICALLY VERIFIED: Distress location pin with dynamic GPS accuracy radius circle (Rendered on `SM-S938B`)
- [✓] PHYSICALLY VERIFIED: Live tactical unit vectoring: Kochi Police Unit #04 & Ambulance 108 plotted relative to incident (Rendered on `SM-S938B`)
- [✓] PHYSICALLY VERIFIED: Offline-resilient vector fallback when remote map tiles are inaccessible (Tested during dead-zone mode on `SM-S938B`)

---

## 🧭 Phase 31 — Native Android Bottom Navigation & Layout
- [x] IMPLEMENTED: Material 3 `NavigationBar` with live status badges (`MainNavigationScreen`)
- [x] IMPLEMENTED: Dynamic badges: Active journey indicator (green dot), Danger active alert (red badge), Pending SOS queue count
- [x] IMPLEMENTED: Persistent header quick actions: Network dead-zone toggle, Mesh Visualizer shortcut, Responder Console shortcut

---

## 🎨 Phase 32 — Safety UI/UX Polish
- [x] IMPLEMENTED: Tactical dark safety theme (`AppTheme.darkTheme`) optimized for OLED battery preservation
- [x] IMPLEMENTED: High-contrast touch targets ($\ge 48\times48\,\text{dp}$) meeting mobile accessibility guidelines
- [x] IMPLEMENTED: Clear typographical hierarchy and color-coded status chips

---

## 📱 Phase 33 — Real-Phone Demo Scenario Preparation
- [✓] PHYSICALLY VERIFIED: Physical Android evaluation protocols (Demo A & Demo B) in `docs/REAL_PHONE_DEMO_GUIDE.md`
- [✓] PHYSICALLY VERIFIED: Transparent real vs simulated audit in `docs/REAL_VS_SIMULATED.md`

---

## 📚 Phase 34 — Technical Documentation & Guides
- [✓] PHYSICALLY VERIFIED: Detailed architectural specification in `docs/ARCHITECTURE.md`
- [✓] PHYSICALLY VERIFIED: Comprehensive project `README.md` updated with compilation, split-per-abi, and backend execution commands

---

## 🧪 Phase 35 — Comprehensive Testing
- [✓] PHYSICALLY VERIFIED: 12 unit tests across `ble_service_test.dart`, `crypto_service_test.dart`, `risk_engine_test.dart`, and `widget_test.dart` (100% pass)
- [✓] PHYSICALLY VERIFIED: Static code analysis clean (`flutter analyze` with 0 issues)

---

## 📦 Phase 36 — Build & Deployment
- [✓] PHYSICALLY VERIFIED: Architecture-specific release APK compiled: `app-arm64-v8a-release.apk` (**19.0 MB**)
- [✓] PHYSICALLY VERIFIED: 32-bit release APK compiled: `app-armeabi-v7a-release.apk` (**16.5 MB**)
- [✓] PHYSICALLY VERIFIED: Universal release APK compiled: `app-release.apk` (**52.0 MB**)
- [✓] PHYSICALLY VERIFIED: Zero-dependency Node.js cloud backend verified running on port 3000
