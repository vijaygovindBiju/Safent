import React, { createContext, useContext, useState, useEffect, useRef, useCallback } from 'react';
import confetti from 'canvas-confetti';
import { 
  ScreenState, 
  NetworkStatus, 
  Journey, 
  Incident, 
  SOSMessage, 
  MeshNode, 
  IncidentTimelineEvent, 
  SensorTelemetry,
  RiskFusionScore 
} from '../types';
import { INITIAL_JOURNEY, DEFAULT_RISK_FUSION, INITIAL_MESH_NODES, KOCHI_LOCATIONS } from '../utils/mockData';
import { soundFx } from '../utils/audio';

interface SafetyContextType {
  currentScreen: ScreenState;
  setScreen: (screen: ScreenState) => void;
  journey: Journey;
  networkStatus: NetworkStatus;
  setNetworkStatus: (status: NetworkStatus) => void;
  toggleNetwork: () => void;
  incident: Incident | null;
  sosMessage: SOSMessage | null;
  meshNodes: MeshNode[];
  currentHopIndex: number;
  timeline: IncidentTimelineEvent[];
  sensorTelemetry: SensorTelemetry;
  dangerCountdown: number;
  isDangerActive: boolean;
  isDemoRunning: boolean;
  demoProgress: number; // 0 to 100
  demoStepText: string;
  isMuted: boolean;
  toggleMute: () => void;
  
  // Actions
  startJourney: (dest: string, contactName: string, contactPhone: string) => void;
  simulateDanger: () => void;
  confirmSafe: () => void;
  triggerImmediateSOS: () => void;
  advanceMeshHop: () => void;
  acknowledgeIncident: (responderId?: string) => void;
  resolveIncident: () => void;
  runFullDemo: () => void;
  stopDemo: () => void;
  resetAll: () => void;
}

const SafetyContext = createContext<SafetyContextType | undefined>(undefined);

export const SafetyProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [currentScreen, setCurrentScreen] = useState<ScreenState>('HOME');
  const [journey, setJourney] = useState<Journey>(INITIAL_JOURNEY);
  const [networkStatus, setNetworkStatusState] = useState<NetworkStatus>('OFFLINE');
  const [incident, setIncident] = useState<Incident | null>(null);
  const [sosMessage, setSosMessage] = useState<SOSMessage | null>(null);
  const [meshNodes, setMeshNodes] = useState<MeshNode[]>(INITIAL_MESH_NODES);
  const [currentHopIndex, setCurrentHopIndex] = useState<number>(0);
  const [timeline, setTimeline] = useState<IncidentTimelineEvent[]>([]);
  
  // Sensor Telemetry simulation
  const [sensorTelemetry, setSensorTelemetry] = useState<SensorTelemetry>({
    accelerometerG: 1.02,
    gyroscopeDps: 3.4,
    ambientDecibels: 48,
    speedKmh: 42,
    isNightTime: true
  });

  // Danger countdown state
  const [dangerCountdown, setDangerCountdown] = useState<number>(10);
  const [isDangerActive, setIsDangerActive] = useState<boolean>(false);
  
  // Demo automation state
  const [isDemoRunning, setIsDemoRunning] = useState<boolean>(false);
  const [demoProgress, setDemoProgress] = useState<number>(0);
  const [demoStepText, setDemoStepText] = useState<string>('');
  
  // Sound mute state
  const [isMuted, setIsMuted] = useState<boolean>(false);

  const countdownIntervalRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const demoTimeoutRef = useRef<ReturnType<typeof setTimeout>[]>([]);

  const toggleMute = () => {
    soundFx.isMuted = !soundFx.isMuted;
    setIsMuted(soundFx.isMuted);
  };

  const getNowTimeString = () => {
    const now = new Date();
    const h = String(now.getHours()).padStart(2, '0');
    const m = String(now.getMinutes()).padStart(2, '0');
    const s = String(now.getSeconds()).padStart(2, '0');
    return `${h}:${m}:${s}`;
  };

  const addTimelineEvent = useCallback((
    title: string, 
    description: string, 
    category: IncidentTimelineEvent['category'], 
    severity: IncidentTimelineEvent['severity'] = 'INFO'
  ) => {
    const newEvent: IncidentTimelineEvent = {
      id: `TL-${Date.now()}-${Math.floor(Math.random()*1000)}`,
      timeString: getNowTimeString(),
      isoTimestamp: new Date().toISOString(),
      title,
      description,
      category,
      severity
    };
    setTimeline(prev => [newEvent, ...prev]);
  }, []);

  const setNetworkStatus = (status: NetworkStatus) => {
    setNetworkStatusState(status);
    setJourney(j => ({ ...j, networkStatus: status }));
  };

  const toggleNetwork = () => {
    const nextStatus = networkStatus === 'OFFLINE' ? 'ONLINE' : 'OFFLINE';
    setNetworkStatus(nextStatus);
    addTimelineEvent(
      `Network Changed: ${nextStatus}`,
      `Device connection manually toggled to ${nextStatus}. ${nextStatus === 'OFFLINE' ? 'Operating in zero-connectivity Bluetooth Mesh fallback mode.' : 'Direct cellular Internet available.'}`,
      'MESH',
      nextStatus === 'OFFLINE' ? 'WARNING' : 'INFO'
    );
  };

  // Live sensor noise fluctuation
  useEffect(() => {
    if (journey.status === 'ACTIVE' && !isDangerActive) {
      const interval = setInterval(() => {
        setSensorTelemetry(prev => ({
          accelerometerG: Number((1.0 + (Math.random() * 0.12 - 0.06)).toFixed(2)),
          gyroscopeDps: Number((3.0 + (Math.random() * 2.5 - 1.2)).toFixed(1)),
          ambientDecibels: Math.floor(45 + Math.random() * 8),
          speedKmh: Math.floor(38 + Math.random() * 6),
          isNightTime: true
        }));
      }, 1500);
      return () => clearInterval(interval);
    }
  }, [journey.status, isDangerActive]);

  // Start Journey
  const startJourney = (dest: string, contactName: string, contactPhone: string) => {
    const updatedJourney: Journey = {
      ...journey,
      id: `JNY-${Date.now().toString().slice(-6)}`,
      destination: dest || "Kochi, Kerala",
      startTime: getNowTimeString() + " IST",
      status: "ACTIVE",
      networkStatus: networkStatus,
      location: KOCHI_LOCATIONS.MG_ROAD,
      battery: 78,
      trustedContact: {
        name: contactName || "Emergency Contact",
        phone: contactPhone || "+91 98470 12345",
        relationship: "Trusted Contact",
        notifyOnSOS: true
      }
    };
    setJourney(updatedJourney);
    setCurrentScreen('ACTIVE');
    addTimelineEvent(
      "Safe Journey Initiated", 
      `Route active toward ${updatedJourney.destination}. High-frequency on-device audio, motion, and location monitors activated in late-night mode.`,
      'DETECTION',
      'INFO'
    );
  };

  // Step 4: Danger Trigger
  const simulateDanger = useCallback(() => {
    setIsDangerActive(true);
    setDangerCountdown(10);
    soundFx.playEmergencyAlarm();

    // Spike telemetry values
    setSensorTelemetry({
      accelerometerG: 4.85, // Heavy sudden deceleration / impact
      gyroscopeDps: 86.4,  // Severe rotation
      ambientDecibels: 92, // Glass shattering / sudden scream / metal crush
      speedKmh: 0,
      isNightTime: true,
      lastAnomalyType: 'IMPACT_AND_ACOUSTIC_ANOMALY'
    });

    const timeStr = getNowTimeString();
    const riskFusion: RiskFusionScore = {
      ...DEFAULT_RISK_FUSION,
      detectedAt: timeStr
    };

    const newIncident: Incident = {
      id: `INC-${Date.now().toString().slice(-6)}`,
      journeyId: journey.id,
      type: "Possible crash / violent impact",
      riskScore: riskFusion.totalScore,
      riskFusion,
      timestamp: timeStr,
      location: KOCHI_LOCATIONS.MG_ROAD,
      status: "CONFIRMATION_PENDING",
      travellerName: "Anonymous Traveller (Device A)",
      battery: 78,
      encryptedHash: "SHA256:8f4c2b9a70e3d11b238f4d99"
    };

    setIncident(newIncident);
    setJourney(j => ({ ...j, status: 'DANGER_SUSPECTED' }));
    setCurrentScreen('DANGER');

    addTimelineEvent(
      "⚠ Danger Detected: Risk 95/100 HIGH",
      "Sensor fusion detected severe multi-axis impact (+40), acoustic anomaly (+25), rapid angular tumble (+20) in late-night transit context (+10). Initiating 10s safety confirmation.",
      'DETECTION',
      'CRITICAL'
    );
  }, [journey.id, addTimelineEvent]);

  // Safety Confirmation: "I'M SAFE" (False-positive guard)
  const confirmSafe = () => {
    if (countdownIntervalRef.current) {
      clearInterval(countdownIntervalRef.current);
      countdownIntervalRef.current = null;
    }
    setIsDangerActive(false);
    setDangerCountdown(10);

    // Reset telemetry to calm state
    setSensorTelemetry({
      accelerometerG: 1.01,
      gyroscopeDps: 2.1,
      ambientDecibels: 46,
      speedKmh: 40,
      isNightTime: true
    });

    if (incident) {
      setIncident({
        ...incident,
        status: "CONFIRMED_SAFE"
      });
    }

    setJourney(j => ({ ...j, status: 'ACTIVE' }));
    setCurrentScreen('ACTIVE');

    addTimelineEvent(
      "User Confirmed Safe (False-Positive Prevented)",
      "Traveller manually pressed 'I'm Safe' within 10-second countdown window. SOS transmission successfully aborted.",
      'SAFETY_CHECK',
      'SUCCESS'
    );
  };

  // Trigger SOS immediately or upon countdown expiry
  const triggerImmediateSOS = useCallback(() => {
    if (countdownIntervalRef.current) {
      clearInterval(countdownIntervalRef.current);
      countdownIntervalRef.current = null;
    }
    setIsDangerActive(false);
    soundFx.playEmergencyAlarm();

    const timeStr = getNowTimeString();
    const incId = incident?.id || `INC-${Date.now().toString().slice(-6)}`;
    
    const initialSos: SOSMessage = {
      id: `SOS-PKT-${Date.now().toString().slice(-7)}`,
      incidentId: incId,
      originDevice: "Traveller Phone A (Galaxy S23)",
      currentNode: "NODE-A",
      hopCount: 0,
      maxHops: 5,
      ttl: 300,
      timestamp: timeStr,
      status: "PENDING_DISCOVERY",
      encryptedPayload: "AES-GCM-256:39f8bc210a4e77da812ef... [Encrypted GPS, Audio Fingerprint, Biometric State]",
      payloadSizeKb: 1.4,
      routeHistory: [
        {
          nodeId: "NODE-A",
          nodeName: "Traveller Phone A",
          timestamp: timeStr,
          hopIndex: 0,
          protocol: "BLE_5.2_ADVERTISEMENT",
          latencyMs: 0
        }
      ]
    };

    setSosMessage(initialSos);

    const updatedIncident: Incident = incident ? {
      ...incident,
      status: "SOS_CREATED"
    } : {
      id: incId,
      journeyId: journey.id,
      type: "Possible crash / violent impact",
      riskScore: 95,
      riskFusion: { ...DEFAULT_RISK_FUSION, detectedAt: timeStr },
      timestamp: timeStr,
      location: KOCHI_LOCATIONS.MG_ROAD,
      status: "SOS_CREATED",
      travellerName: "Anonymous Traveller (Device A)",
      battery: 78,
      encryptedHash: "SHA256:8f4c2b9a70e3d11b238f4d99"
    };

    setIncident(updatedIncident);
    setJourney(j => ({ ...j, status: 'SOS_TRIGGERED' }));
    setCurrentHopIndex(0);

    // Reset mesh nodes state
    setMeshNodes(prev => prev.map((n, i) => ({
      ...n,
      hasPayload: i === 0,
      isCurrentHop: i === 0,
      isDelivered: false
    })));

    setCurrentScreen('SOS_ACTIVE');

    addTimelineEvent(
      "🚨 SOS Activated (Zero Internet Connection)",
      `Incident ${incId} created. Encrypted emergency beacon initialized (AES-256). Searching for nearby mesh peers via BLE 5.2 and Wi-Fi Aware.`,
      'SOS',
      'CRITICAL'
    );
  }, [incident, journey.id, addTimelineEvent]);

  // Countdown timer effect
  useEffect(() => {
    if (isDangerActive) {
      countdownIntervalRef.current = setInterval(() => {
        setDangerCountdown(prev => {
          if (prev <= 1) {
            if (countdownIntervalRef.current) clearInterval(countdownIntervalRef.current);
            triggerImmediateSOS();
            return 0;
          }
          soundFx.playCountdownTick(prev > 3 ? 880 : 1200);
          return prev - 1;
        });
      }, 1000);

      return () => {
        if (countdownIntervalRef.current) {
          clearInterval(countdownIntervalRef.current);
        }
      };
    }
  }, [isDangerActive, triggerImmediateSOS]);

  // Advance to next mesh hop
  const advanceMeshHop = useCallback(() => {
    if (!sosMessage) return;

    soundFx.playMeshPing();
    const nextHop = currentHopIndex + 1;
    const timeStr = getNowTimeString();

    if (nextHop === 1) {
      // Traveller -> Relay Phone B
      setCurrentHopIndex(1);
      setMeshNodes(prev => prev.map((n, idx) => ({
        ...n,
        hasPayload: idx <= 1,
        isCurrentHop: idx === 1,
        isDelivered: false
      })));
      setSosMessage(prev => prev ? {
        ...prev,
        currentNode: "NODE-B",
        hopCount: 1,
        status: "RELAYING",
        routeHistory: [
          ...prev.routeHistory,
          {
            nodeId: "NODE-B",
            nodeName: "Relay Phone B (Commuter)",
            timestamp: timeStr,
            hopIndex: 1,
            protocol: "BLE_5.2_ADVERTISEMENT",
            latencyMs: 140
          }
        ]
      } : null);
      setIncident(prev => prev ? { ...prev, status: "RELAY_FOUND" } : null);
      addTimelineEvent(
        "Mesh Hop 1: Relayed to Phone B",
        "Discovered nearby participating peer 'Relay Phone B' (RSSI: -68 dBm). Packet transferred via BLE 5.2 advertising channels without cellular data.",
        'MESH',
        'WARNING'
      );
    } else if (nextHop === 2) {
      // Relay Phone B -> Gateway Phone C
      setCurrentHopIndex(2);
      setMeshNodes(prev => prev.map((n, idx) => ({
        ...n,
        hasPayload: idx <= 2,
        isCurrentHop: idx === 2,
        isDelivered: false
      })));
      setSosMessage(prev => prev ? {
        ...prev,
        currentNode: "NODE-C",
        hopCount: 2,
        status: "GATEWAY_UPLOADING",
        routeHistory: [
          ...prev.routeHistory,
          {
            nodeId: "NODE-C",
            nodeName: "Gateway Phone C (Pedestrian 5G)",
            timestamp: timeStr,
            hopIndex: 2,
            protocol: "WIFI_AWARE",
            latencyMs: 220
          }
        ]
      } : null);
      setIncident(prev => prev ? { ...prev, status: "GATEWAY_FOUND" } : null);
      addTimelineEvent(
        "Mesh Hop 2: Internet Gateway Reached (Phone C)",
        "Relay B forwarded payload to Gateway Phone C. Gateway possesses active 5G Internet connection and begins immediate HTTPS uplink.",
        'GATEWAY',
        'WARNING'
      );
    } else if (nextHop === 3) {
      // Gateway Phone C -> Cloud SOS Backend
      setCurrentHopIndex(3);
      setMeshNodes(prev => prev.map((n, idx) => ({
        ...n,
        hasPayload: idx <= 3,
        isCurrentHop: idx === 3,
        isDelivered: false
      })));
      setSosMessage(prev => prev ? {
        ...prev,
        currentNode: "NODE-CLOUD",
        hopCount: 3,
        status: "DELIVERED_TO_BACKEND",
        routeHistory: [
          ...prev.routeHistory,
          {
            nodeId: "NODE-CLOUD",
            nodeName: "Cloud SOS Backend",
            timestamp: timeStr,
            hopIndex: 3,
            protocol: "HTTPS_REST",
            latencyMs: 85
          }
        ]
      } : null);
      setIncident(prev => prev ? { ...prev, status: "DELIVERED" } : null);
      addTimelineEvent(
        "Cloud Backend Ingested SOS Payload",
        "Payload authenticated and decrypted at AWS Mumbai SOS ingest cluster. Dispatch pipeline triggered; WebSockets broadcasting to emergency responders.",
        'GATEWAY',
        'SUCCESS'
      );
    } else if (nextHop === 4) {
      // Cloud Backend -> Responder Console
      setCurrentHopIndex(4);
      setMeshNodes(prev => prev.map((n, idx) => ({
        ...n,
        hasPayload: true,
        isCurrentHop: idx === 4,
        isDelivered: true
      })));
      setSosMessage(prev => prev ? {
        ...prev,
        currentNode: "NODE-RESPONDER",
        hopCount: 4,
        status: "RESPONDER_ALERTED",
        routeHistory: [
          ...prev.routeHistory,
          {
            nodeId: "NODE-RESPONDER",
            nodeName: "Safety Response Console",
            timestamp: timeStr,
            hopIndex: 4,
            protocol: "WEBSOCKET_PUSH",
            latencyMs: 42
          }
        ]
      } : null);
      setIncident(prev => prev ? { ...prev, status: "RESPONDER_NOTIFIED" } : null);
      soundFx.playSuccessChime();
      addTimelineEvent(
        "🚨 Safety Response Center Notified",
        "Emergency console received incident packet. Audio sirens and live route coordinates displayed on responder radar.",
        'RESPONDER',
        'CRITICAL'
      );
    }
  }, [currentHopIndex, sosMessage, addTimelineEvent]);

  // Acknowledge Incident (from Responder Dashboard)
  const acknowledgeIncident = (responderId = "Dispatcher Officer Radhakrishnan (Console #04)") => {
    soundFx.playSuccessChime();
    confetti({
      particleCount: 50,
      spread: 60,
      origin: { y: 0.6 }
    });

    const timeStr = getNowTimeString();
    if (incident) {
      setIncident({
        ...incident,
        status: "ACKNOWLEDGED",
        acknowledgedBy: responderId,
        acknowledgedAt: timeStr,
        responderNotes: "Ambulance 108 and Kochi Traffic Patrol unit 4 dispatched to MG Road Metro Station."
      });
    }

    addTimelineEvent(
      "Incident Acknowledged by Response Center",
      `Dispatcher ${responderId} verified SOS. Emergency response units mobilized to MG Road coordinates. Trusted contact notified via SMS simulation.`,
      'RESPONDER',
      'SUCCESS'
    );
  };

  // Resolve Incident
  const resolveIncident = () => {
    if (incident) {
      setIncident({
        ...incident,
        status: "RESOLVED"
      });
    }
    setJourney(j => ({ ...j, status: 'COMPLETED' }));
    addTimelineEvent(
      "Incident Resolved & Secured",
      "Emergency units arrived on site. Traveller verified safe and transported. Mesh session closed.",
      'RESPONDER',
      'SUCCESS'
    );
  };

  // Run Full Automated Demo (60-90 seconds flow)
  const runFullDemo = () => {
    // Clear any previous running demo timeouts
    demoTimeoutRef.current.forEach(clearTimeout);
    demoTimeoutRef.current = [];

    setIsDemoRunning(true);
    setDemoProgress(5);
    setDemoStepText("Phase 1: Initializing late-night journey...");

    // 1. Reset state & Start journey (T+0s)
    resetAll();
    const timeouts: ReturnType<typeof setTimeout>[] = [];

    timeouts.push(setTimeout(() => {
      startJourney("Kochi, Kerala", "Anjali Menon (Sister)", "+91 98470 12345");
      setDemoProgress(15);
      setDemoStepText("Phase 2: Simulating Traveller entering zero-network shadow zone (OFFLINE)...");
    }, 1500));

    // 2. Set network to OFFLINE (T+3.5s)
    timeouts.push(setTimeout(() => {
      setNetworkStatus("OFFLINE");
      setDemoProgress(28);
      setDemoStepText("Phase 3: Active journey monitoring (Accelerometer, Audio, GPS active)...");
    }, 3500));

    // 3. Simulate Dangerous Event (T+6.5s)
    timeouts.push(setTimeout(() => {
      simulateDanger();
      setDemoProgress(40);
      setDemoStepText("Phase 4: Possible crash detected! Risk Score: 95/100 HIGH. Safety confirmation countdown running...");
    }, 6500));

    // 4. Let countdown run 3 seconds, then show countdown expiring without response (T+10s)
    timeouts.push(setTimeout(() => {
      triggerImmediateSOS();
      setDemoProgress(52);
      setDemoStepText("Phase 5: No response from traveller. SOS Created! Zero internet - initiating Mesh Relay...");
    }, 10500));

    // 5. Navigate to Mesh Visualization screen (T+12s)
    timeouts.push(setTimeout(() => {
      setCurrentScreen('MESH_RELAY');
      setDemoProgress(60);
      setDemoStepText("Phase 6: Searching for nearby peer... Relaying to Phone B (Commuter)...");
      advanceMeshHop(); // Hop 1 (to Relay Phone B)
    }, 12500));

    // 6. Forward to Gateway Phone C (T+15s)
    timeouts.push(setTimeout(() => {
      setDemoProgress(70);
      setDemoStepText("Phase 7: Phone B forwards to Gateway Phone C with active 5G Internet!");
      advanceMeshHop(); // Hop 2 (to Gateway Phone C)
    }, 15500));

    // 7. Deliver to Cloud SOS Backend (T+18.5s)
    timeouts.push(setTimeout(() => {
      setDemoProgress(80);
      setDemoStepText("Phase 8: Gateway uploads encrypted payload to Cloud SOS Backend...");
      advanceMeshHop(); // Hop 3 (to Backend)
    }, 18500));

    // 8. Deliver to Responder Console & Navigate to Responder screen (T+21.5s)
    timeouts.push(setTimeout(() => {
      setDemoProgress(90);
      setDemoStepText("Phase 9: SOS Delivered! Safety Response Center siren sounding...");
      advanceMeshHop(); // Hop 4 (to Responder)
      setCurrentScreen('RESPONDER');
    }, 21500));

    // 9. Auto acknowledge (T+25s)
    timeouts.push(setTimeout(() => {
      acknowledgeIncident();
      setDemoProgress(100);
      setDemoStepText("Demo Completed: Full offline-to-responder loop proved in 25 seconds!");
      setTimeout(() => {
        setIsDemoRunning(false);
      }, 3500);
    }, 25000));

    demoTimeoutRef.current = timeouts;
  };

  const stopDemo = () => {
    demoTimeoutRef.current.forEach(clearTimeout);
    demoTimeoutRef.current = [];
    setIsDemoRunning(false);
    setDemoStepText("");
  };

  const resetAll = () => {
    stopDemo();
    if (countdownIntervalRef.current) {
      clearInterval(countdownIntervalRef.current);
      countdownIntervalRef.current = null;
    }
    setIsDangerActive(false);
    setDangerCountdown(10);
    setCurrentScreen('HOME');
    setJourney(INITIAL_JOURNEY);
    setNetworkStatusState('OFFLINE');
    setIncident(null);
    setSosMessage(null);
    setCurrentHopIndex(0);
    setMeshNodes(INITIAL_MESH_NODES);
    setTimeline([]);
    setSensorTelemetry({
      accelerometerG: 1.02,
      gyroscopeDps: 3.4,
      ambientDecibels: 48,
      speedKmh: 42,
      isNightTime: true
    });
  };

  return (
    <SafetyContext.Provider value={{
      currentScreen,
      setScreen: setCurrentScreen,
      journey,
      networkStatus,
      setNetworkStatus,
      toggleNetwork,
      incident,
      sosMessage,
      meshNodes,
      currentHopIndex,
      timeline,
      sensorTelemetry,
      dangerCountdown,
      isDangerActive,
      isDemoRunning,
      demoProgress,
      demoStepText,
      isMuted,
      toggleMute,
      startJourney,
      simulateDanger,
      confirmSafe,
      triggerImmediateSOS,
      advanceMeshHop,
      acknowledgeIncident,
      resolveIncident,
      runFullDemo,
      stopDemo,
      resetAll
    }}>
      {children}
    </SafetyContext.Provider>
  );
};

export const useSafety = () => {
  const context = useContext(SafetyContext);
  if (!context) {
    throw new Error('useSafety must be used within a SafetyProvider');
  }
  return context;
};
