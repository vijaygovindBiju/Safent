# Travel SOS Mesh — Late-Night Journey Safety Companion
> **Hackathon Challenge:** SC-03 — Late-Night Journey Safety Companion  
> **Team:** Maravazha (Vijaygovind Biju, Noel Paul Tomy)  
> **Status:** Pre-Qualification Prototype MVP • Verified Running  

---

## 💡 The Core Innovation

> **"Even when the traveller's phone has no Internet, their SOS can travel through nearby participating devices until it reaches an Internet-connected gateway."**

Late-night transit accidents and attacks happen disproportionately in dead zones: underground metro tunnels, highway blackouts, and low-connectivity sectors. Traditional safety apps are rendered completely useless without mobile data.

**Travel SOS Mesh** transforms ordinary smartphones into autonomous peer safety nodes. Using **BLE 5.2 Extended Advertisements** and **Wi-Fi Aware store-and-forward mesh routing**, an encrypted distress beacon hops opportunistically from phone to phone until reaching an Internet-connected peer device that uplinks the signal to emergency dispatchers.

---

## 🔄 The 7-Stage End-to-End Workflow

```
DETECTION ➔ RISK FUSION ➔ SAFETY CONFIRMATION ➔ SOS CREATED ➔ MESH RELAY ➔ 5G GATEWAY ➔ RESPONDER
```

```
┌─────────────────────────────────┐
│        TRAVELLER PHONE A        │
│          (No Internet)          │
│  - Multi-Sensor Edge Fusion     │
│  - 10s False-Positive Challenge │
│  - AES-GCM-256 Envelope PDU     │
└────────────────┬────────────────┘
                 │ BLE 5.2 Extended Advertising (<255B)
                 ▼
┌─────────────────────────────────┐
│          RELAY PHONE B          │
│    (Commuter in Auto-Rickshaw)  │
│  - Zero Internet required       │
│  - Store-and-Forward Rebroadcast│
│  - Zero Knowledge of Plaintext  │
└────────────────┬────────────────┘
                 │ Wi-Fi Aware / BLE Re-broadcast
                 ▼
┌─────────────────────────────────┐
│         GATEWAY PHONE C         │
│   (Pedestrian with 5G Cellular) │
│  - Detects emergency beacon     │
│  - Immediate HTTPS Cloud Uplink │
└────────────────┬────────────────┘
                 │ Secure HTTPS / TLS 1.3
                 ▼
┌─────────────────────────────────┐
│        CLOUD SOS BACKEND        │
│   - Digital signature verified  │
│   - WebSockets dispatch stream  │
└────────────────┬────────────────┘
                 │ Real-Time WebSocket Push
                 ▼
┌─────────────────────────────────┐
│     SAFETY RESPONSE CENTER      │
│  - Console #04 Dispatch View    │
│  - Ambulance 108 & Police Units │
│  - Emergency Contact SMS Alert  │
└─────────────────────────────────┘
```

---

## 🔍 Implementation Status (Honest Technical Transparency)

To maintain absolute credibility before judges, features are clearly categorized:

| Feature | Status | Implementation Details |
|---|---|---|
| **State Machine & Navigation** | `IMPLEMENTED` | Centralized React/TypeScript state engine covering all 7 stages and automatic/manual transitions. |
| **Tactical GPS Radar Map** | `IMPLEMENTED` | Zero-API-key tactical SVG cartography with live breadcrumb route, compass, satellite fix, and BLE beacon rings. |
| **Audio Synthesizer** | `IMPLEMENTED` | 100% client-side Web Audio API synthesizer for warning sirens, countdown beeps, sonar pings, and dispatch chimes (with mute toggle). |
| **False-Positive Guard** | `IMPLEMENTED` | 10-second countdown challenge with `[I'M SAFE]` cancellation and automatic SOS fallback upon timeout. |
| **Interactive Mesh Visualizer** | `IMPLEMENTED` | 5-node pipeline with live packet animation, hop tracking, TTL decrementing, and node schema inspector. |
| **Responder Dispatch Console** | `IMPLEMENTED` | Command center with active incident cards, `[ACKNOWLEDGE]`, `[DISPATCH UNITS]`, and microsecond timeline logs. |
| **60s Automated Demo Engine** | `IMPLEMENTED` | Single-click `[ RUN FULL SOS DEMO ]` automating the full end-to-end loop with live progress narration. |
| **3-Axis Sensor & Audio ML** | `SIMULATED` | Edge sensor signals (4.85G impact, 86°/s tumble, 92 dB acoustic spike) are simulated in this browser environment. |
| **BLE 5.2 / Wi-Fi Aware Stack** | `SIMULATED` | The prototype simulates packet transmission; production architecture is designed for native Android. |
| **SMS & Unit Dispatch Integration** | `SIMULATED` | Simulated SMS dispatch to trusted contact and simulated GPS vectoring to emergency services. |
| **Native Android Daemons** | `PLANNED` | Kotlin foreground service with `BluetoothLeAdvertiser`, `WifiAwareManager`, and hardware Keystore encryption. |

---

## ⚡ 60-Second Demo Instructions for Judges

1. Open **`http://localhost:4173/`** in any web browser.
2. Click the glowing **`[ RUN FULL SOS DEMO ]`** button in the header.
3. **Watch the automated 50-second flow:**
   - **00s:** Journey active with on-device monitoring.
   - **05s:** Vehicle enters dead zone &rarr; Network switches to **OFFLINE (Mesh Active)**.
   - **10s:** Sensor anomaly detected &rarr; Risk fusion reaches **95/100 (HIGH)**.
   - **20s:** "Are you safe?" 10-second countdown runs to prevent false alarms.
   - **25s:** Incapacitated traveller does not respond &rarr; SOS beacon generated.
   - **30s:** Packet relays peer-to-peer from Phone A &rarr; Relay Phone B.
   - **35s:** Phone B forwards to Gateway Phone C with active 5G.
   - **40s:** Gateway C uploads payload to Cloud SOS Backend.
   - **45s:** Safety Response Center receives alert with live GPS coordinates.
   - **50s:** Dispatcher acknowledges incident &rarr; Emergency units dispatched.
4. Click **`[ RESET DEMO ]`** to return to a clean state anytime.

---

## 🛠️ Technology Stack

- **Frontend:** React 18, TypeScript, Vite
- **Styling:** Tailwind CSS, Custom Tactical Safety Theme
- **Icons:** Lucide React
- **Audio:** Client-side Web Audio API Synthesizer (0 external file dependencies)
- **Effects:** Canvas Confetti, SVG Tactical Radar, Animated SVG Paths
- **Documentation:** Markdown specifications in [`/docs`](file:///media/pirate/Shared/currently%20working/Safent/docs)

---

## 🚀 Quickstart & Production Build

```bash
# 1. Install dependencies
npm install

# 2. Start local development server
npm run dev

# 3. Build optimized production bundle
npm run build

# 4. Preview production build locally
npm run preview
```

The production bundle in `dist/` is completely standalone, contains zero localhost dependencies, and can be hosted instantly on Vercel, Netlify, or GitHub Pages.

---

## 👥 Team Maravazha
- **Vijaygovind Biju** — Mesh Architecture & System Design
- **Noel Paul Tomy** — Frontend Engineering & Simulation Engine
