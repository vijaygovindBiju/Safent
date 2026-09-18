# Travel SOS Mesh — Real Physical Android Phone Demo Protocol (SC-03)

**Team:** Maravazha  
**Members:** Vijaygovind Biju, Noel Paul Tomy  
**Challenge:** SC-03 — Late-night journey safety companion  
**Target Platform:** Physical Android Device (Android 7.0+ / API 24+)  

---

## 📱 Hardware Requirements
1. **Physical Android Phone:** Minimum Android 7.0 (API 24), Android 13/14/15 supported.
2. **Sensors Required:** 3-Axis Accelerometer, Gyroscope, Microphone, GPS chip, BLE 5.0+.
3. **Debug APK:** Located at `mobile/build/app/outputs/flutter-apk/app-debug.apk`.

---

## 🚀 Pre-Demo Installation & Setup
1. **Transfer APK to Device:**
   ```bash
   adb install -r mobile/build/app/outputs/flutter-apk/app-debug.apk
   ```
2. **First Launch Walkthrough:**
   - Launch **Travel SOS Mesh** from the app launcher (`com.maravazha.travel_sos_mesh`).
   - Swipe through the **4-Pillar Onboarding Walkthrough** explaining:
     - Late-Night Journey Tracking
     - Multi-Sensor Anomaly Detection
     - Offline Distress Ingest
     - Store-and-Forward Mesh Relay
   - Complete runtime permissions:
     - Location (Fine & Coarse GPS)
     - Microphone (Audio Decibel Monitoring — Zero Raw Audio Saved)
     - Notifications (High-Priority Alert Channel)
     - Bluetooth (BLE Extended Advertising & Scanning)

---

## 🧪 Real-Device Demonstration Scenarios

### Scenario 1: Physical Sensor Telemetry Verification (`[REAL]`)
1. Navigate to the **Safety** tab (shield icon in bottom navigation).
2. Note the **On-Device Hardware Sensors** card:
   - **Acceleration (G):** Shows real-time linear $G$ force (nominal $\approx 1.0\text{G}$).
   - **Rotation (°/s):** Shows live angular velocity in degrees per second (nominal $0^\circ/\text{s}$).
   - **Acoustic (dB):** Shows live sound pressure level (nominal $38\text{--}48\,\text{dB}$).
3. **Physical Actions:**
   - **Device Shake:** Vigorously shake the phone. Accelerometer G-force jumps to $3.5\text{--}5.2\text{G}$, lighting up the red `Impact Candidate` indicator.
   - **Device Spin:** Rapidly rotate or tumble the phone in hand. Gyroscope leaps over $80^\circ/\text{s}$, flagging `Rollover Candidate`.
   - **Loud Sound / Shout:** Speak loudly or clap close to the microphone. Decibel scale rises above $80\,\text{dB}$, shifting status from `NORMAL` to `ANOMALY`.

---

### Scenario 2: False-Alarm Protection Challenge (`[REAL]`)
1. From the **Safety** screen, tap `[ SIMULATE DANGEROUS EVENT (DEMO) ]` (or shake phone while speaking loudly).
2. The **High Alert Safety Challenge Modal** immediately engages:
   - Heavy vibration alert pulses (`HapticFeedback.heavyImpact`).
   - Red emergency border pulses.
   - 10-second countdown dial begins ticking down with auditory ticks.
   - Shows detected causes (e.g. `Sudden deceleration (4.8G) + Acoustic Spike (84 dB)`).
3. **Test False-Positive Dismissal:**
   - Tap **`[ I'M SAFE ]`**.
   - Modal dismisses immediately.
   - Danger countdown cancels.
   - Incident timeline in **Incidents** tab logs:  
     `"User Confirmed Safe — Traveller tapped I'M SAFE. SOS dispatch successfully aborted."`
   - Peak risk scores reset to nominal baseline.

---

### Scenario 3: Zero-Reception Dead-Zone & Store-and-Forward Relay (`[REAL / SIMULATED]`)
1. Start an active journey on the **Journey** tab toward `MG Road Metro Station, Kochi`.
2. Tap the **Network Pill** in the top header (or turn on Airplane Mode on the phone).
   - Header switches from `ONLINE` to `OFFLINE (Dead Zone - Mesh Mode Active)`.
3. Trigger an SOS either by holding the radial button for 1.5s or letting the 10s challenge expire.
4. **Inspect Offline Storage Queue:**
   - Open the **Incidents** tab.
   - Notice the **1 QUEUED** offline beacon badge.
   - The distress beacon is securely preserved in flash memory with encrypted AES-GCM-256 payload and Ed25519 signature.
5. **Inspect 31-Byte BLE Distress Beacon:**
   - Open the **Safety** tab.
   - Scroll to **BLE 5.2 BEACON (31-BYTE PDU)**.
   - Inspect the real byte stream (UUID `0xFEE4`, compressed GPS coordinates, battery level, risk score, and CRC checksum).
6. **Step Through Mesh Relay Visualizer:**
   - Tap the **Hub** icon in the top app bar.
   - Tap **`[ STEP NEXT HOP ]`**:
     - Hop 1: Relayed to **Phone B** in auto-rickshaw via BLE 5.2 Extended Advertising.
     - Hop 2: Relayed to **Gateway Phone C** with 5G Internet.
     - Hop 3: Gateway Phone C uploads to **Cloud SOS Backend**.
     - Hop 4: Backend notifies **Response Center Console #04**.

---

### Scenario 4: Cellular Recovery Auto-Flush & Responder Command (`[REAL]`)
1. Tap the **Network Pill** again to simulate cellular network recovery (or disable Airplane Mode).
2. Watch the **Incidents** screen:
   - The offline pending queue automatically flushes to the cloud backend.
   - SOS status transitions from `QUEUED` to `DELIVERED`.
   - Immutable audit timeline logs:  
     `"SOS Uploaded via Cellular Recovery — Internet restored. Offline pending SOS successfully transmitted."`
3. Open the **Responder Console** (top shield icon):
   - Review live incident with GPS coordinates on the tactical OpenStreetMap canvas.
   - Notice Kochi Police Unit #04 and Ambulance 108 plotted on map relative to distress location.
   - Tap **`[ ACKNOWLEDGE ]`**: logs dispatcher name and timestamps.
   - Review the generated **Emergency SMS** with live tracking URL.
   - Tap **`[ COPY SMS ]`** to verify clipboard payload.
   - Tap **`[ RESOLVE ]`**: closes incident and returns journey to complete state.

---

### Scenario 5: Automated 50-Second Evaluation Script (`[REAL / SIMULATED]`)
For rapid judging and demonstrations without manual clicking:
1. On the **Home** dashboard, tap **`[ RUN DEMO ]`**.
2. Hands-off automated 50-second presentation begins:
   - 00s: Journey starts.
   - 05s: Cellular dead-zone entered.
   - 10s: Anomaly detected.
   - 15s: Risk reaches 95/100 HIGH, challenge active.
   - 28s: Timeout, SOS queued offline.
   - 32s: Mesh Hop 1 (Phone B).
   - 36s: Mesh Hop 2 (Gateway Phone C).
   - 40s: Cloud backend ingest.
   - 45s: Responder console alert.
   - 50s: Incident acknowledged by dispatch desk.
3. Tap **`[ RESET ]`** in Settings anytime to return all state to a clean slate.
