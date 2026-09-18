# Travel SOS Mesh — Physical Android Demo & Presentation Guide

**Team:** Maravazha  
**Members:** Vijaygovind Biju, Noel Paul Tomy  
**Challenge:** SC-03 — Late-night journey safety companion  
**Target Platform:** Physical Android Device (Android 7.0+ / API 24+)  

---

## 📱 Release Binaries & Installation

The production release binaries are compiled with AOT optimization and split per target CPU architecture:

| Architecture | File Location | File Size | Recommended Target |
|---|---|---|---|
| **ARM64 (64-bit)** | `mobile/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` | **19.0 MB** | **All modern Android phones (Recommended)** |
| **ARMv7 (32-bit)** | `mobile/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` | **16.5 MB** | Older 32-bit Android phones |
| **Universal (Fat)** | `mobile/build/app/outputs/flutter-apk/app-release.apk` | **52.0 MB** | Any Android device |

### Installation Command:
```bash
# Install to physical phone over USB/Wireless ADB
adb install -r mobile/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

---

## 🎯 DEMO A — REAL PHYSICAL DEVICE VALIDATION

> [!NOTE]
> This demo strictly tests real on-device hardware sensors, local storage persistence, and actual REST backend integration.

### Step 1: Real GPS & Telemetry
1. Open the app on the physical phone. Complete the 4-step onboarding walkthrough and grant **Location**, **Microphone**, and **Notification** permissions.
2. Navigate to the **Journey** tab.
3. Observe the top pill: **`GPS: ±X.Xm [REAL DEVICE LOCATION]`**.
4. Real latitude, longitude, speed, and heading are dynamically streamed from the phone's physical GNSS chip.
5. The OpenStreetMap canvas displays the user's location with accuracy radius circle and `© OpenStreetMap contributors` attribution.

### Step 2: Real Accelerometer & Gyroscope
1. Navigate to the **Safety** tab.
2. View the **On-Device Hardware Sensors** card:
   - **Acceleration:** Shows current baseline $\approx 1.0\text{G}$. Shake the phone gently; acceleration jumps to $2.5\text{--}4.5\text{G}$.
   - **Rotation:** Shows current rotation in $^\circ/\text{s}$. Twist/rotate the phone; angular velocity spikes to $60\text{--}120^\circ/\text{s}$.
3. Single isolated shocks are damped below 70/100 to prevent false alarms.

### Step 3: Acoustic Anomaly Detection (Zero Raw Audio Saved)
1. In the **Safety** tab, observe ambient sound level ($\approx 38\text{--}45\,\text{dB}$).
2. Speak loudly or clap near the phone.
3. Acoustic classification transitions from `NORMAL` to `ELEVATED` / `ANOMALY`.
4. **Privacy Guarantee:** No audio bytes are ever written to disk or transmitted over the network.

### Step 4: Safety Challenge (10-Second Modal)
1. Trigger high risk (e.g. combined shake + loud sound or tap `[ Simulate Dangerous Event ]`).
2. The **10-Second High Alert Challenge** modal appears with heavy haptic pulsing.
3. Tap **`[ I'M SAFE ]`** $\to$ Countdown aborts, status returns to Safe, and timeline logs cancellation.
4. Trigger again and let the 10-second timer expire (or tap **`[ SEND SOS NOW ]`**) $\to$ Distress SOS is created immediately.

### Step 5: Offline Persistence Queue (The Dead-Zone Test)
1. **Disable Wi-Fi and Mobile Data** on the physical phone (or tap the Network pill in the app).
2. Status switches to **`OFFLINE`**.
3. Trigger an SOS via 1.8-second hold on the circular SOS button.
4. Navigate to the **Incidents** tab:
   - Status is marked **`QUEUED`**.
   - Distress packet is safely stored in encrypted flash memory (`SharedPreferences`).
5. **Force close the application completely** via Android Recent Apps.
6. Re-open the application.
7. Navigate to **Incidents**: The pending SOS is still safely preserved.

### Step 6: Network Recovery & Backend Ingest
1. **Enable Wi-Fi or Mobile Data** on the phone.
2. The network listener immediately detects `ONLINE` state.
3. The queue automatically flushes to the cloud REST backend.
4. Incident status updates from `QUEUED` to `DELIVERED`.
5. Timeline appends: *"SOS Uploaded via Cellular Recovery"*.

### Step 7: Responder Console Verification
1. Navigate to the **Responder** tab (shield icon in top bar).
2. The distress incident appears in the dispatch queue.
3. The OpenStreetMap tactical canvas displays the incident marker along with nearest emergency vehicles:
   - **Ambulance 108** (Green)
   - **Police Patrol Unit #04** (Cyan)
4. Tap **`[ ACKNOWLEDGE ]`** $\to$ Status transitions to `ACKNOWLEDGED`.
5. Tap **`[ RESOLVE ]`** $\to$ Incident marks resolved with audit timestamp.

---

## 🌐 DEMO B — INNOVATION DEMO (STORE-AND-FORWARD MESH)

> [!IMPORTANT]
> **Engineering Transparency Notice:**
> - **31-Byte Compact BLE Advertising Frame:** **REAL PROTOCOL** (Exact binary PDU serialized matching Bluetooth 5.2 extended advertising packet limits).
> - **Multi-Hop Propagation across multiple phones:** **SIMULATED MULTI-HOP RELAY** (Demonstrates the architectural store-and-forward hopping mechanism via state machine, as physical multi-hop requires a synchronized cluster of 3+ physical radios).

### Flow:
```
[Traveller Phone A]  (No Internet / Dead Zone)
        │
        ▼ (BLE 5.2 Extended Advertising - 31-byte PDU)
[Relay Phone B]      (Nearby auto-rickshaw / passenger - Hop 1)
        │
        ▼ (Store-and-Forward Re-broadcast)
[Gateway Phone C]    (Approaching mobile tower / 5G - Hop 2)
        │
        ▼ (HTTPS REST Ingest)
[Cloud SOS Backend]  (Node.js on port 3000)
        │
        ▼ (Dispatch Queue & Real-time Stream)
[Responder Console]  (Kochi Emergency Dispatch Desk #04)
```

### Steps to Present Demo B:
1. Tap the **Mesh Hub** icon in the top header.
2. View the **Mesh Visualizer**:
   - Shows Node A (Traveller), Node B (Relay), and Node C (Gateway).
   - Displays RSSI signal strength and hop indicators.
3. Tap **`[ STEP NEXT HOP ]`**:
   - **Hop 0 $\to$ Hop 1:** Distress beacon leaves Phone A over simulated BLE 5.2. Received by Relay Phone B.
   - **Hop 1 $\to$ Hop 2:** Stored and forwarded to Gateway Phone C.
   - **Hop 2 $\to$ Hop 3:** Gateway Phone C detects cellular reception and relays packet to `/api/mesh/relay`.
4. Inspect the **31-Byte BLE Frame Hex Dump** in the Safety screen:
   - Shows service UUID `0xFEE4`.
   - Compressed fixed-point lat/long.
   - Battery level, risk score, and CRC24 integrity checksum.

---

## ⚡ Hands-Off 50-Second Automated Presentation

For a rapid, fully synchronized demonstration during judging:
1. Go to **Settings** $\to$ tap **`[ Launch 50s Demo Sequence ]`** (or tap **`[ RUN DEMO ]`** on the Home screen).
2. The entire narrative executes automatically in 50 seconds:
   - *00s:* Journey starts
   - *05s:* Cellular dead-zone simulation begins
   - *10s:* Physical sensor anomaly detected
   - *15s:* Risk score escalates to 95/100, Safety Challenge engages
   - *28s:* Timeout triggers offline SOS
   - *32s:* Mesh hop 1 to Relay Phone B
   - *36s:* Mesh hop 2 to Gateway Phone C
   - *40s:* Cloud backend ingest
   - *45s:* Emergency dispatch desk alert
   - *50s:* Dispatcher acknowledges and vectors response units
3. Tap **`[ RESET APP STATE ]`** anytime in Settings to return the system to default.
