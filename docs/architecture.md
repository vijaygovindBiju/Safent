# Travel SOS Mesh — System Architecture Specification

**Project:** Travel SOS Mesh  
**Challenge:** SC-03 — Late-Night Journey Safety Companion  
**Team:** Maravazha (Vijaygovind Biju, Noel Paul Tomy)  
**Document:** System Architecture Specification  

---

## 1. Executive Summary

Traditional personal safety applications rely fundamentally on active mobile data (4G/5G). However, late-night transit risks peak in connectivity shadow zones: underground metro stretches, rural highways, basements, and cellular blackouts.

**Travel SOS Mesh** implements an **offline-first store-and-forward mesh relay protocol**. In an emergency, a disconnected traveller's device generates an encrypted emergency beacon and relays it peer-to-peer across participating commuter phones via Bluetooth Low Energy (BLE 5.2) and Wi-Fi Aware until reaching a peer device with active cellular reception, which automatically uplinks the packet to emergency services.

---

## 2. Six-Layer System Architecture

```
┌─────────────────────────────────────────────────────────┐
│              LAYER 1: TRAVELLER DEVICE                  │
│  - Edge Tri-Sensor Telemetry Engine                     │
│  - Autonomous Acoustic Anomaly Classifier               │
│  - Battery & GPS Coordinate Cache                       │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│           LAYER 2: MULTI-SENSOR RISK FUSION             │
│  - Sudden Deceleration / Impact (>4G):      +40 pts     │
│  - Acoustic Distress / Scream Classifier:   +25 pts     │
│  - Rapid Angular Gyro Tumble (>80°/s):      +20 pts     │
│  - Late-Night Transit Context (>22:00 IST): +10 pts     │
│  - Cumulative Threshold: 95 / 100 (HIGH RISK)           │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│        LAYER 3: SAFETY CONFIRMATION (FALSE-POSITIVE)    │
│  - 10-Second Auditory & Visual Challenge                │
│  - User Taps "I'M SAFE": Alert Cancelled (Logged)       │
│  - User Unresponsive: Automatic SOS Elevation           │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│             LAYER 4: DISTRESS PDU PACKET                │
│  - Payload < 255 Bytes (BLE Extended Advertising Limit) │
│  - Public-Key Envelope Encryption (AES-GCM-256)         │
│  - Nonce, Timestamp, Deduplication Hash, TTL (300s)     │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│        LAYER 5: STORE-AND-FORWARD PEER MESH             │
│  - Node A (Traveller): BLE 5.2 Extended Advertising     │
│  - Node B (Relay Commuter): Passive Scan & Rebroadcast  │
│  - Deduplication Cache + TTL Decrementing               │
│  - 50-meter Hop Radius, Zero Internet Required          │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│        LAYER 6: 5G GATEWAY & RESPONSE CENTER            │
│  - Node C (Gateway): Detects Internet, Uploads via HTTPS│
│  - Cloud SOS Backend: Verifies signature, notifies PSAP │
│  - Dispatch Console #04: Live GPS vectoring for 108     │
└─────────────────────────────────────────────────────────┘
```

---

## 3. Distress PDU Schema Specification

Distress packets must fit within the 255-byte payload capacity of Bluetooth Low Energy 5.2 Extended Advertising PDUs:

```json
{
  "message_id": "SOS-PKT-884291",
  "origin_id": "DEVICE-A-F4B85E",
  "current_node": "NODE-B",
  "hop_count": 1,
  "ttl": 299,
  "timestamp": "2026-09-18T22:47:03.142Z",
  "payload": "AES-GCM-256:7f90e1c28834a9b910fa3e... [Encrypted Coordinates & Risk Vector]",
  "signature": "ED25519-SIG:9b20e184f4... [Signed by Device A Secure Element]"
}
```

### Fields:
1. `message_id`: Unique identifier derived from device hash and microsecond timestamp.
2. `origin_id`: Anonymous hardware hash of origin device.
3. `current_node`: ID of the node currently broadcasting or forwarding.
4. `hop_count`: Incremented by 1 at each hop (capped at 5 hops maximum).
5. `ttl`: Time-To-Live countdown in seconds (starts at 300s, purged when 0).
6. `payload`: Authenticated ciphertext containing high-precision GPS, speed, battery, and contact reference.
7. `signature`: Asymmetric Ed25519 signature ensuring message authenticity.

---

## 4. Privacy & Zero-Knowledge Architecture

1. **Local Edge Inference:** Audio inference runs completely on-device using a quantized TensorFlow Lite model. Raw audio is converted to spectral RMS features and never stored or uploaded.
2. **Zero-Knowledge Relaying:** Relaying phones carry encrypted binary blobs without possessing the private decryption key. Relay participants cannot inspect the traveller's name, contact list, or exact coordinates.
3. **Automatic Cache Purge:** When a packet's TTL expires or an acknowledgement is received, intermediate relay caches purge the payload.

---

## 5. Prototype Status Distinction

- **Implemented in Web Prototype:** Central state machine, SVG tactical GPS radar map, Web Audio API sound synthesizer, 10s false-positive challenge, interactive 5-node hop visualizer, dispatch dashboard, and full automated 50s demo sequence.
- **Simulated for Prototype:** Native 3-axis accelerometer/gyroscope readings, physical Bluetooth Low Energy advertising channels, and external cellular gateway uplink.
- **Planned Mobile Stack:** Android Foreground Service with `BluetoothLeAdvertiser`, `ScanCallback`, `SensorEventListener`, and WebSockets/REST integration.
