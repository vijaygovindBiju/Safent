# Travel SOS Mesh — Late-Night Journey Safety Companion
> **Hackathon Challenge:** SC-03 — Late-Night Journey Safety Companion  
> **Team:** Maravazha (Vijaygovind Biju, Noel Paul Tomy)  
> **Target Platform:** Physical Android Device (Flutter / Dart + Android Native SDK)  
> **Status:** All 36 Phases Completed & Verified • Clean APK Built  

---

## 💡 The Core Innovation

> **"Even when the traveller's phone has no Internet, their SOS can travel through nearby participating devices until it reaches an Internet-connected gateway."**

Late-night transit accidents and assaults happen disproportionately in cellular dead zones: underground metro stretches, rural highways, and low-connectivity sectors. Traditional emergency applications fail silently without active mobile data.

**Travel SOS Mesh** turns everyday Android smartphones into an autonomous peer-to-peer safety mesh. Utilizing **BLE 5.2 Extended Advertisements (31-byte compact distress PDUs)**, opportunistic store-and-forward relaying, and multi-sensor edge risk fusion, an encrypted distress beacon hops from device to device until reaching an Internet-connected peer that uplinks the payload directly to emergency dispatchers.

```
Traveller Phone A (Offline) ➔ Relay Phone B (BLE 5.2) ➔ Gateway Phone C (5G) ➔ Cloud Backend ➔ Responder Console #04
```

---

## 📱 Native Android Architecture (`mobile/`)

The mobile application is engineered natively for Android using Flutter 3.x and Dart 3.x, directly interfacing with Android hardware APIs:

- **GPS & Location Engine (`LocationService`):** Fine/Coarse GPS positioning, speed (km/h), heading, altitude, and adaptive sampling (10m in transit vs 2m in emergency mode).
- **3-Axis Linear Accelerometer (`SensorService`):** Continuous G-force calculation with static gravity compensation ($G = 1.0 + \sqrt{a_x^2 + a_y^2 + a_z^2}/9.8$) detecting violent impacts ($\ge 3.8\text{G}$).
- **3-Axis Gyroscope (`SensorService`):** Measures rotational velocity ($\Omega \ge 80^\circ/\text{s}$) capturing rollover accidents and rapid phone tumbles.
- **Privacy-Preserving Acoustic Decibel Monitor (`SensorService`):** Continuous windowed RMS sound pressure evaluation ($\ge 80\,\text{dB}$ screams/crashes). **Zero raw audio is ever recorded, stored, or transmitted.**
- **Multi-Sensor Risk Fusion Engine (`RiskEngine`):** 4-signal weighting (+40 Impact, +25 Audio, +20 Rotation, +10 Context) with **false-positive damping** to prevent dropped phones from triggering emergency dispatch.
- **Safety Confirmation Challenge:** 10-second auditory and visual countdown challenge with single-tap `[ I'M SAFE ]` false-alarm dismissal and zero-user-interaction automatic SOS creation upon timeout.
- **Radial Hold SOS Button:** 1.5-second anti-accidental radial long-press button with haptic feedback ticks.
- **Offline-First Local Queue (`StorageService`):** Preserves emergency distress packets across app restarts and crashes via local encrypted flash storage.
- **Real 31-Byte BLE Distress Beacon (`BleService`):** Compact binary PDU serializer with service UUID `0xFEE4`, compressed fixed-point coordinates, battery level, risk score, and 24-bit CRC checksum.
- **Tactical OpenStreetMap (`flutter_map`):** Live GPS marker, heading rotation, dynamic accuracy circle, breadcrumbs polyline, and offline-resilient tile handling.
- **Responder Command Console (`ResponderScreen`):** Desk #04 dispatch console with live GPS incident map, unit vectoring (108 Ambulance & Police #04), action buttons, and emergency contact SMS preview.

---

## 📂 Project Structure

```
Safent/
├── mobile/                           # Native Android Flutter Codebase
│   ├── android/                      # Native Android project configs & AndroidManifest.xml
│   ├── lib/
│   │   ├── core/constants/           # AppColors, AppTheme
│   │   ├── models/                   # Journey, Incident, SOSMessage, MeshNode, RiskFusion
│   │   ├── providers/                # SafetyProvider (State orchestration & Demo engine)
│   │   ├── screens/                  # Home, Journey, Safety, Incidents, Responder, Settings, Mesh, Onboarding
│   │   ├── services/                 # Location, Sensors, Risk, Network, Storage, BLE, Backend, Crypto
│   │   └── widgets/                  # RadialHoldSosButton, SafetyChallengeModal
│   └── test/                         # Unit test suites (BLE framing, Risk engine, Crypto)
├── server/                           # Lightweight Cloud SOS Ingest Backend
│   └── server.js                     # Zero-dependency Node.js REST server
├── docs/                             # Architecture specs & physical phone demo protocols
│   ├── ARCHITECTURE.md               # Mathematical telemetry formulas, PDU schema & diagrams
│   └── REAL_PHONE_DEMO_GUIDE.md      # Physical Android testing script
├── TODO.md                           # 36-Phase Master Engineering Roadmap
└── README.md                         # Project documentation
```

---

## 🚀 Getting Started & Compilation

### 1. Run Android Tests & Code Analysis
```bash
cd mobile
flutter analyze      # Verified: No issues found!
flutter test         # Verified: All 12 unit tests pass!
```

### 2. Build Native Android Debug APK
```bash
cd mobile
flutter build apk --debug
```
*Compiled APK output:* `mobile/build/app/outputs/flutter-apk/app-debug.apk`

### 3. Install on Physical Android Device via ADB
```bash
adb install -r mobile/build/app/outputs/flutter-apk/app-debug.apk
```

### 4. Run Cloud Ingest Backend Server
```bash
node server/server.js
# Server running at http://localhost:3000/api/health
```

---

## 🔍 Honest Technical Transparency Matrix

| Feature | Status | Engineering Details |
| :--- | :---: | :--- |
| **Android GPS Tracking** | `[REAL]` | Live hardware GPS via `geolocator` capturing Lat, Lon, Alt, Speed, Heading, Accuracy. |
| **3-Axis Accelerometer** | `[REAL]` | Live hardware stream via `sensors_plus` calculating linear G-force ($G \ge 3.8\text{G}$). |
| **3-Axis Gyroscope** | `[REAL]` | Live hardware stream measuring rotational angular velocity in °/s ($\ge 80^\circ/\text{s}$). |
| **Acoustic Decibel Meter** | `[REAL]` | Local microphone RMS decibel scale with **strict zero raw audio recording**. |
| **Multi-Sensor Risk Fusion** | `[REAL]` | 4-signal weighting with false-positive single-sensor damping. |
| **Safety Challenge Modal** | `[REAL]` | 10-second countdown dial with `[I'M SAFE]` cancellation and haptic feedback. |
| **Radial Hold SOS Button** | `[REAL]` | 1.5-second anti-accidental long-press radial progress button. |
| **Offline Storage Queue** | `[REAL]` | Local persistent flash queue surviving reboots and app crashes. |
| **Network State Listener** | `[REAL]` | Cellular & Wi-Fi detection via `connectivity_plus` with dead-zone test toggle. |
| **31-Byte BLE PDU Serializer** | `[REAL]` | Binary beacon frame encoder/decoder with UUID `0xFEE4`, fixed-point GPS, and CRC. |
| **Cloud REST Backend** | `[REAL]` | Node.js HTTP server (`server/server.js`) with incident ingestion and acknowledgement. |
| **Tactical Responder Map** | `[REAL]` | OpenStreetMap canvas rendering incident position, accuracy radius, and units. |
| **Physical Multi-Device Relay** | `[SIMULATED]` | Multi-hop propagation across Nodes B & C simulated for single-device evaluation. |

---

## 👥 Team Maravazha
- **Vijaygovind Biju** — System Architecture, Multi-Sensor Fusion & Android Engineering
- **Noel Paul Tomy** — Store-and-Forward Mesh Protocol & Tactical UX Design
