# Travel SOS Mesh — Late-Night Journey Safety Companion
> **Hackathon Challenge:** SC-03 — Late-Night Journey Safety Companion  
> **Team:** Maravazha  
> **Members:** Vijaygovind Biju, Noel Paul Tomy  
> **Status:** Pre-Qualification Prototype MVP  

---

## 🎯 The Core Innovation

> **"Even when the traveller's phone has no Internet, their SOS can travel through nearby participating devices until it reaches an Internet-connected gateway."**

Traditional personal safety apps fail at the exact moment danger strikes: when a traveller enters an underground transit corridor, remote highway stretch, or dark dead-zone with zero cellular connectivity.

**Travel SOS Mesh** transforms ordinary smartphones into autonomous safety nodes. Using **BLE 5.2 Extended Advertisements** and **Wi-Fi Aware peer-to-peer mesh networking**, an emergency beacon hops opportunistically across participating commuter devices until it reaches a device with active cellular data, which automatically uplinks the encrypted packet to emergency responders.

---

## 🚀 End-to-End System Architecture

```
┌───────────────────────────┐
│     TRAVELLER PHONE A     │
│       (No Internet)       │
│  - 3-Axis IMU (Impact)    │
│  - Edge Audio Classifier  │
│  - AES-GCM-256 Envelope   │
└─────────────┬─────────────┘
              │ BLE 5.2 Extended Advertising (255B)
              ▼
┌───────────────────────────┐
│       RELAY PHONE B       │
│ (Nearby Commuter in Auto) │
│  - Zero Internet needed   │
│  - Passive Store & Forward│
│  - Zero knowledge of data │
└─────────────┬─────────────┘
              │ Wi-Fi Aware / BLE Re-broadcast
              ▼
┌───────────────────────────┐
│      GATEWAY PHONE C      │
│ (Pedestrian with 5G/4G)   │
│  - Detects emergency tag  │
│  - Immediate HTTPS Uplink │
└─────────────┬─────────────┘
              │ Secure HTTPS REST / TLS 1.3
              ▼
┌───────────────────────────┐
│     CLOUD SOS BACKEND     │
│   (AWS Mumbai Cluster)    │
│  - Decrypts emergency key │
│  - Dispatches WebSocket   │
└─────────────┬─────────────┘
              │ Real-time WebSocket Push
              ▼
┌───────────────────────────┐
│  SAFETY RESPONSE CENTER   │
│ (Ambulance 108 & Police)  │
│  - Live GPS Vectoring     │
│  - Automated Contact SMS  │
└───────────────────────────┘
```

---

## 📱 Prototype Screens & Features

| # | Screen | Key Functionality |
|---|---|---|
| **1** | **Home / Landing** | Serious transportation safety interface, live network state, mesh status metrics, quick-start CTA, and "RUN FULL SOS DEMO" button. |
| **2** | **Start Journey** | Destination configuration (presets for Kochi Metro, Marine Drive, Kakkanad InfoPark), Emergency contact setup, on-device sensor toggles. |
| **3** | **Active Journey** | Real-time tactical SVG GPS radar map with live coordinates, battery level, speed, tri-sensor indicators, dual online/offline switcher, and radial **HOLD FOR SOS** button. |
| **4** | **Danger Detection** | Multi-sensor risk fusion model breakdown (+40 Impact, +25 Audio shatter, +20 Gyro tumble, +10 Late-night = 95/100 HIGH). **10-second auditory countdown** demonstrating false-positive prevention with `[I'M SAFE]` and `[SEND SOS]`. |
| **5** | **SOS Active** | Serious emergency state displaying encrypted AES-256 payload, last known GPS fix, and step-by-step mesh relay status checkmarks. |
| **6** | **Mesh Visualization** | Interactive, animated visual pipeline of the 5 nodes: Traveller A ➔ Relay B ➔ Gateway C ➔ Cloud ➔ Responder. Displays Message ID, TTL, hop latency, RSSI, and node packet inspector. |
| **7** | **Responder Dashboard** | Emergency dispatch command center (`Dispatch Desk #04`), active incident cards with severity badges, 1-click **Acknowledge**, **Ambulance 108 Dispatch**, microsecond audit timeline, and simulated emergency SMS delivery. |

---

## ⚡ 60-Second Hackathon Judge Demo Guide

To review the entire end-to-end loop in under 60 seconds:

1. Click the glowing **`[ RUN FULL SOS DEMO ]`** button in the top header (or on the Home screen).
2. **Watch the automated sequence:**
   - **T+1.5s:** Safe journey initializes toward Kochi.
   - **T+3.5s:** Network automatically switches to **OFFLINE (Mesh Mode)** to simulate entering a cellular shadow zone.
   - **T+6.5s:** Crash event simulates with 4.85G impact and acoustic distress anomaly (Risk: **95/100 HIGH**).
   - **T+10.5s:** 10-second countdown runs; with no user response, the system auto-triggers emergency SOS.
   - **T+12.5s:** Navigates to **Mesh Visualizer**: Traveller Phone A transmits encrypted packet via BLE 5.2 to Relay Phone B.
   - **T+15.5s:** Relay Phone B forwards packet to Gateway Phone C.
   - **T+18.5s:** Gateway Phone C utilizes active 5G cell data to uplink packet to Cloud SOS Backend.
   - **T+21.5s:** Navigates to **Safety Response Center**: Emergency siren chimes, live GPS lock renders on operator console.
   - **T+25.0s:** Dispatcher acknowledges incident; confetti triggers; Ambulance 108 and Kochi Police patrol units are dispatched.

---

## 🛡️ Key Architectural Differentiators

### 1. Zero-Internet Store-and-Forward Mesh
Unlike standard safety applications that completely fail when data connectivity drops to zero, Travel SOS Mesh utilizes non-connectable BLE 5.2 Extended Advertising PDUs (255 bytes capacity) to broadcast encrypted distress beacons across a 50-meter radius without requiring pairing.

### 2. Multi-Sensor Edge Risk Fusion
Risk scoring runs 100% on-device on the user's phone using native Android sensor APIs (`SensorManager`) and a lightweight TensorFlow Lite audio classifier. No raw microphone audio ever leaves the device, preserving absolute user privacy.

### 3. False-Positive Protection
Accidentally dropping your phone does not summon emergency services. The system initiates a high-urgency 10-second sensory challenge. A single tap on `[ I'M SAFE ]` dismisses the alert and records a false-positive cancellation in the audit trail.

### 4. Zero-Knowledge Cryptographic Privacy
Packets forwarded by participating peer phones (Phones B and C) are encrypted with public-key dispatch encryption (`AES-GCM-256`). Relaying users cannot inspect the traveller's identity, photos, location, or emergency contacts. Only authenticated emergency dispatchers can decrypt the payload.

---

## 🛠️ Tech Stack

- **Framework:** React 18 + TypeScript + Vite
- **Styling:** Tailwind CSS + Custom Dark Transportation Safety Theme
- **Icons:** Lucide React
- **Audio Synthesizer:** Web Audio API (100% client-side synthesized sirens, countdown beeps, sonar pings, and success chimes — 0 external audio file dependencies)
- **Visuals:** SVG Tactical Radar Map, Canvas Confetti, Animated Hop Paths

---

## 💻 Local Development & Build

### Prerequisites
- Node.js >= 18
- npm >= 9

### Install & Run
```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build production bundle
npm run build

# Preview production build locally
npm run preview
```

Production output is compiled to the `dist/` directory and can be deployed directly to any static hosting provider (Vercel, Netlify, GitHub Pages, Cloudflare Pages) with zero configuration.

---

## 👥 Team Maravazha
- **Vijaygovind Biju** — System Architecture & Mesh Protocol Design
- **Noel Paul Tomy** — Frontend Engineering & Sensor Simulation Engine
