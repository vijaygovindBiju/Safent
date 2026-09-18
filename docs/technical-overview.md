# Travel SOS Mesh — Technical Deep Dive & Implementation Guide

**Project:** Travel SOS Mesh  
**Challenge:** SC-03 — Late-Night Journey Safety Companion  
**Team:** Maravazha (Vijaygovind Biju, Noel Paul Tomy)  
**Document:** Technical Overview & Mobile Protocol Guide  

---

## 1. Network Physical Layer Specifications

### 1.1 BLE 5.2 Extended Advertising
In legacy Bluetooth 4.x, advertising payloads were strictly capped at 31 bytes, rendering offline emergency messaging impractical. In Android 8.0+ with BLE 5.0+, the `BluetoothLeAdvertiser` API supports **Extended Advertising PDUs** up to 255 bytes on secondary advertising channels (PHY LE 1M / LE Coded Long Range).

- **Advertising Mode:** `ADVERTISE_MODE_LOW_LATENCY`
- **Tx Power:** `ADVERTISE_TX_POWER_HIGH`
- **Connectability:** Non-connectable, undirected broadcast (no Bluetooth pairing dialog required)
- **Range:** 40–75 meters line-of-sight; 25–35 meters within vehicles.

### 1.2 Wi-Fi Aware (NAN)
For high-density urban environments, the Android `WifiAwareManager` enables peer-to-peer discovery without requiring an access point or Wi-Fi Direct group owner negotiation. Wi-Fi Aware operates concurrently with existing Wi-Fi connections.

---

## 2. Store-and-Forward Mesh Algorithm

### 2.1 Deduplication Cache
Each participating device maintains an in-memory LRU cache of received message IDs:
```typescript
interface CacheEntry {
  messageId: string;
  firstSeenTimestamp: number;
  hopCount: number;
}
```
If `cache.has(packet.message_id)`, the packet is discarded immediately to prevent broadcast storms.

### 2.2 Hop Count & Time-To-Live (TTL)
- Initial TTL is set to `300` seconds (5 minutes).
- At each hop:
  ```
  packet.hop_count = packet.hop_count + 1
  packet.ttl = packet.ttl - (currentTime - packet.receivedTime)
  ```
- If `packet.hop_count >= 5` or `packet.ttl <= 0`, forwarding terminates.

---

## 3. Sensor Fusion Algorithm

The on-device edge scoring engine processes continuous samples at 100 Hz:

```
RiskScore = (ImpactFactor × 0.40) + (AcousticFactor × 0.25) + (RotationFactor × 0.20) + (ContextFactor × 0.10)
```

| Factor | Trigger Metric | Score Contribution |
|---|---|---|
| **Impact** | 3-axis Accelerometer vector magnitude > 4.2G | +40 points |
| **Acoustic Anomaly** | Ambient sound RMS > 85 dB with scream spectral shape | +25 points |
| **Rotation** | Gyroscope angular velocity > 80 deg/sec | +20 points |
| **Context** | Clock time > 22:00 IST and unfamiliar GPS corridor | +10 points |

If `RiskScore >= 75`, the system triggers the 10-second Safety Confirmation countdown.

---

## 4. Cryptographic Envelope

1. **Origin Signing:** The origin device generates an asymmetric signature over `[timestamp || coords || risk_score]` using its hardware-backed Android Keystore key (Ed25519).
2. **Dispatch Encryption:** The payload is encrypted with the Emergency Response Center's public key using `AES-GCM-256`. Relaying devices forward the ciphertext without access to the plaintext.
3. **Integrity Check:** The responder console verifies the cryptographic digest before vectoring emergency vehicles.

---

## 5. Battery Consumption Safeguards

- **Passive Listening:** Relay devices operate in low-power scan cycles (1.5s scan window every 15s).
- **Battery Guard:** If a participating peer device drops below 20% battery, mesh relay participation pauses automatically to protect the user's phone.
- **Estimated Drain:** Benchmarked at less than 0.8% per hour during late-night monitoring standby.
