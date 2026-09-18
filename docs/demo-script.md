# Travel SOS Mesh — 60-Second Hackathon Judge Demo Script

**Project:** Travel SOS Mesh  
**Team:** Maravazha (Vijaygovind Biju, Noel Paul Tomy)  
**Duration:** ~60 Seconds  
**Goal:** Deliver a convincing, high-impact demonstration of the offline mesh safety concept.

---

## ⏱️ Verbal Walkthrough & Stage-by-Stage Actions

### [00:00 – 00:10] The Problem Hook & Landing Screen
- **Action:** Open application landing page (`http://localhost:4173/`).
- **Presenter:**
  > *"Judges, traditional safety apps have a fatal flaw: they completely fail the moment you lose cellular network late at night. Our project, **Travel SOS Mesh**, ensures your emergency SOS travels to safety even when you have zero Internet connectivity."*
- **Action:** Click **`[ RUN FULL SOS DEMO ]`** (or navigate manually).

---

### [00:10 – 00:20] Active Journey & Zero-Connectivity Zone
- **Screen:** Active Journey Screen
- **Presenter:**
  > *"The traveller begins their journey home in Kochi. At 22:45, their vehicle enters a dark transit tunnel — cellular data drops to **OFFLINE**. Notice the system automatically activates Store-and-Forward Mesh standby mode while monitoring local sensors."*
- **Visual Callout:** Highlight the `INTERNET UNAVAILABLE — MESH RELAY ACTIVE` badge and the 2 nearby peer devices in range.

---

### [00:20 – 00:32] Crash Detection & False-Positive Guard
- **Screen:** Danger Detection Screen
- **Presenter:**
  > *"Suddenly, a collision occurs. On-device sensors register an impact force of 4.8G and an acoustic shatter spike. Our edge risk fusion model calculates a High Risk score of 95/100."*
  > *"Crucially, we do not summon police immediately — that causes false alarms. The system presents a 10-second auditory challenge. If the traveller was responsive, tapping 'I'M SAFE' cancels it. Because they are incapacitated, the timer expires and emergency SOS is triggered automatically."*

---

### [00:32 – 00:46] The Mesh Relay (Visual Centerpiece)
- **Screen:** Mesh Relay Visualization Screen
- **Presenter:**
  > *"This is our core innovation. The traveller's phone has no Internet. It encrypts an emergency distress beacon into a compact 255-byte BLE 5.2 packet."*
  > *"Watch the packet hop: Node A transmits to Node B — a commuter in an auto-rickshaw 35 meters ahead. Node B has no cellular data either, but it forwards the packet to Node C, a pedestrian near the metro station who has active 5G."*
  > *"Node C acts as an opportunistic Internet gateway, uplinking the encrypted payload to the cloud SOS backend in under 200 milliseconds."*

---

### [00:46 – 01:00] Safety Response Center & Incident Acknowledged
- **Screen:** Safety Response Center Console
- **Presenter:**
  > *"Instantly, Dispatch Console #04 at the Safety Response Center receives the distress packet with exact GPS coordinates at MG Road Metro Station."*
  > *"The dispatcher clicks **[ ACKNOWLEDGE ]**, vectoring Ambulance 108 and Kochi traffic patrol units while an automated SMS alert notifies the traveller's emergency contact, Anjali Menon."*
- **Closing Punchline:**
  > *"Travel SOS Mesh turns ordinary commuter phones into an autonomous safety net — ensuring no one is stranded beyond help. Thank you!"*
