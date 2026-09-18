# Travel SOS Mesh — Real vs Simulated Technical Audit

**Team:** Maravazha (Vijaygovind Biju, Noel Paul Tomy)  
**Challenge:** SC-03 — Late-night journey safety companion  
**Date of Audit:** September 19, 2026  
**Status:** Rigorous Engineering Transparency Review  

---

## 1. System Truth Matrix

In accordance with strict hackathon engineering ethics, this document defines the exact boundary between hardware-validated production code, local software engines, and architectural prototypes/simulations.

| Feature / Subsystem | Status | Exact Engineering Status & Evidence |
|---|---|---|
| **Android Build & Packaging** | **REAL** | Compiled native Flutter/Android release binaries (`app-arm64-v8a-release.apk` - 19.0MB, `app-armeabi-v7a-release.apk` - 16.5MB, `app-release.apk` - 52.0MB). 0 static analyzer issues (`flutter analyze`). |
| **GPS Telemetry** | **REAL** | Subscribed to hardware GNSS via `geolocator`. Delivers real latitude, longitude, altitude, heading, speed, and real-time accuracy radius ($\pm\text{m}$). Adaptive polling (10m normal, 2m emergency). |
| **3-Axis Accelerometer** | **REAL** | Subscribed to hardware IMU via `sensors_plus` (`userAccelerometerEventStream`). Computes real vector magnitude $G = 1.0 + \frac{\sqrt{x^2+y^2+z^2}}{9.80665}$. Responds to physical device movement. |
| **3-Axis Gyroscope** | **REAL** | Subscribed to hardware rotational sensor via `sensors_plus` (`gyroscopeEventStream`). Computes rotational velocity in $\text{deg/s} = \sqrt{\omega_x^2+\omega_y^2+\omega_z^2} \times 57.2958$. |
| **Acoustic Level Monitoring** | **REAL (Volatile Metrics Only)** | Reads ambient decibel variance on-device. Zero raw audio recorded, stored, or transmitted (Zero-Storage Privacy Charter). |
| **Multi-Sensor Risk Fusion** | **REAL** | Local algorithmic scoring engine. Weighted composite: $0.35 \times \text{Impact} + 0.25 \times \text{Acoustic} + 0.20 \times \text{Detour} + 0.10 \times \text{Gyro} + 0.10 \times \text{Night}$. Verified with 12 passing unit tests. |
| **False-Positive Damping** | **REAL** | Hardware protection filter: Single isolated shock or ambient spike is capped below 70/100 to prevent accidental emergency dispatches. |
| **10-Second Safety Challenge** | **REAL** | Modal countdown trigger with high-contrast UI, haptic countdown ticks, manual override ("I'M SAFE" / "SEND SOS NOW"), and automated timeout dispatch. |
| **Manual Radial Hold-to-SOS** | **REAL** | 1.8-second continuous circular hold gesture with animated progress sweep and heavy haptic feedback. Prevents accidental single taps. |
| **Offline Persistence Queue** | **REAL** | Local SQLite / `SharedPreferences` persistence. Unsent SOS distress packets survive application force-close, background kill, and phone reboot. |
| **Network Recovery Listener** | **REAL** | Subscribed to Android `connectivity_plus`. Automatically detects transition from `OFFLINE` $\to$ `ONLINE` and immediately drains and flushes pending SOS messages. |
| **Cloud REST Backend** | **REAL** | Zero-dependency Node.js HTTP server running on port 3000. Real REST API endpoints (`/api/health`, `GET/POST /api/incidents`, `/api/incidents/:id/acknowledge`, `/api/incidents/:id/resolve`, `/api/mesh/relay`). |
| **Responder Console & Map** | **REAL** | Interactive Flutter UI with OpenStreetMap (`flutter_map`), live incident coordinates, dynamic accuracy circle, vector markers for Ambulance 108 and Police #04, and live Acknowledge/Resolve state transitions. |
| **OpenStreetMap Attribution** | **REAL** | Legal attribution (`© OpenStreetMap contributors`) rendered on both traveller journey map and responder console. |
| **31-Byte Compact BLE Framing** | **REAL PROTOCOL** | Exact binary PDU encoder/decoder matching standard Bluetooth 5.2 Advertising channel limits: `0xFEE4` Service UUID, 4-byte hash, fixed-point int32 coordinates ($\pm1.1\text{m}$ resolution), battery byte, risk score byte, and 24-bit CRC. |
| **Multi-Hop BLE Relay (3+ Devices)** | **SIMULATED MULTI-HOP RELAY** | Multi-hop propagation (Phone A $\to$ Phone B $\to$ Phone C) is simulated through an automated state machine. Physical multi-hop across multiple distinct phones was not hardware-tested due to single-device test constraints. |
| **Mesh Visualizer Screen** | **SIMULATED UI** | Graph visualization displaying node topology, RSSI signal bars, and hop paths based on incoming mesh packets or demo sequence. |
| **Cryptographic Envelope** | **PROTOTYPE REPRESENTATION** | Generates formatted `AES-GCM-256:<iv>:<ciphertext>:<tag>` envelopes and `ED25519-SIG:<device>:<hash>` signature representations in software. Does not use hardware-backed Android KeyStore / Secure Element. |
| **Emergency Dispatch SMS** | **SIMULATED UI PREVIEW** | Generates standardized SOS text messages with GPS coordinates, battery level, and Google Maps deep link. Previews SMS payload; does not send carrier SMS without external SMS gateway API. |

---

## 2. Hardware vs Software Validation Details

### A. Real On-Device Hardware
- **Target Device Under Test:** Samsung Galaxy S25 Ultra (`SM-S938B`), Android 16 (SDK 36), Serial `RZCY10KPY2L`.
- **Physical Sensors:** Directly interrogates Linux/Android HAL (`/dev/input/`, Android SensorManager: $1.0\text{G}$ baseline accelerometer, $0.0^\circ/\text{s}$ gyroscope).
- **Physical GPS:** Receives real GNSS satellite fixes via `geolocator` (observed at Kochi, Kerala: $\pm4\text{m}$ accuracy).
- **Physical Battery:** Tracks native battery level ($46\% \to 47\%$) in real time via `battery_plus`.
- **Physical Offline Storage:** Persisted to Android app sandbox storage (`/data/user/0/com.maravazha.travel_sos_mesh/shared_prefs/`). Verified across application force-close (`adb shell am force-stop`).
- **Physical Network Transitions:** Radio toggling via `svc wifi` and `svc data` verified offline queuing and automatic uplink flush.

### B. What is Honestly Labeled as "Prototype" or "Simulated"
1. **Multi-Hop BLE Network Mesh:**
   - The 31-byte packet framing and serialization is **100% mathematically real and compliant with BLE advertising specs**.
   - However, a true multi-device store-and-forward mesh across 3 separate physical Android phones in an ad-hoc topology requires simultaneous peripheral/central advertising roles on multiple devices in RF range. This aspect is demonstrated via **SIMULATED MULTI-HOP RELAY**.
2. **End-to-End Cryptography:**
   - The encryption envelope and signature formatting follow standard cryptographic conventions.
   - For hackathon demonstration speed, standard Dart byte operations are used rather than native Android KeyStore cryptographic hardware tokens.
3. **Carrier Cellular SMS:**
   - Pre-formatted SMS payloads are constructed on the client. Actual cellular carrier dispatch is simulated in UI preview rather than paying a commercial SMS aggregator (e.g. Twilio).
