import { Journey, MeshNode, RiskFusionScore, LocationCoordinates } from '../types';

export const KOCHI_LOCATIONS: Record<string, LocationCoordinates> = {
  MG_ROAD: {
    latitude: 9.9674,
    longitude: 76.2848,
    accuracyMeters: 4.2,
    landmark: "MG Road Metro Station, Kochi",
    speedKmh: 42,
    headingDegrees: 38,
  },
  MARINE_DRIVE: {
    latitude: 9.9796,
    longitude: 76.2762,
    accuracyMeters: 3.8,
    landmark: "Marine Drive Walkway, Ernakulam",
    speedKmh: 35,
    headingDegrees: 12,
  },
  EDAPPALLY: {
    latitude: 10.0236,
    longitude: 76.3116,
    accuracyMeters: 5.1,
    landmark: "Edappally Toll Junction, Kochi",
    speedKmh: 58,
    headingDegrees: 45,
  },
  KAKKANAD_INFOPARK: {
    latitude: 10.0125,
    longitude: 76.3578,
    accuracyMeters: 3.2,
    landmark: "InfoPark Expressway, Kakkanad",
    speedKmh: 48,
    headingDegrees: 78,
  }
};

export const INITIAL_JOURNEY: Journey = {
  id: "JNY-2026-8842",
  destination: "Kochi, Kerala",
  journeyName: "Late Night Transit Home",
  startTime: "22:30 IST",
  elapsedSeconds: 840, // 14 mins into journey
  status: "SCHEDULED",
  networkStatus: "OFFLINE",
  location: KOCHI_LOCATIONS.MG_ROAD,
  battery: 78,
  nearbyRelayCount: 2,
  trustedContact: {
    name: "Anjali Menon (Sister)",
    phone: "+91 98470 12345",
    relationship: "Sister",
    notifyOnSOS: true
  },
  monitoringEnabled: {
    audio: true,
    motion: true,
    location: true
  }
};

export const DEFAULT_RISK_FUSION: RiskFusionScore = {
  audioAnomaly: 25,
  impactDetected: 40,
  suddenRotation: 20,
  lateNightContext: 10,
  totalScore: 95,
  confidences: {
    impact: 98,
    audio: 88,
    rotation: 92,
    context: 99
  },
  level: "HIGH",
  detectedAt: "22:47:03",
  isSimulated: true
};

export const INITIAL_MESH_NODES: MeshNode[] = [
  {
    id: "NODE-A",
    name: "Traveller Phone A",
    type: "TRAVELLER",
    roleDescription: "Origin Device (Late-Night Traveller)",
    networkStatus: "NO_INTERNET",
    signalStrengthDbm: -32,
    batteryPercent: 78,
    hasPayload: true,
    isCurrentHop: true,
    isDelivered: false,
    coords: { x: 10, y: 50 },
    macOrId: "F4:B8:5E:21:0A:7D",
    protocol: "BLE_5.2_ADVERTISEMENT"
  },
  {
    id: "NODE-B",
    name: "Relay Phone B",
    type: "RELAY",
    roleDescription: "Commuter in auto-rickshaw 35m ahead",
    networkStatus: "BLUETOOTH_MESH_ONLY",
    signalStrengthDbm: -68,
    batteryPercent: 64,
    hasPayload: false,
    isCurrentHop: false,
    isDelivered: false,
    coords: { x: 32, y: 50 },
    macOrId: "A8:C2:1B:90:5E:44",
    protocol: "BLE_5.2_ADVERTISEMENT"
  },
  {
    id: "NODE-C",
    name: "Gateway Phone C",
    type: "GATEWAY",
    roleDescription: "Pedestrian near Metro Station (5G Active)",
    networkStatus: "INTERNET_ACTIVE",
    signalStrengthDbm: -52,
    batteryPercent: 91,
    hasPayload: false,
    isCurrentHop: false,
    isDelivered: false,
    coords: { x: 55, y: 50 },
    macOrId: "3C:D9:2F:81:4A:E0",
    protocol: "WIFI_AWARE"
  },
  {
    id: "NODE-CLOUD",
    name: "Cloud SOS Backend",
    type: "BACKEND",
    roleDescription: "Central Safety Ingestion Node (Proposed)",
    networkStatus: "CLOUD_INGEST",
    signalStrengthDbm: 0,
    hasPayload: false,
    isCurrentHop: false,
    isDelivered: false,
    coords: { x: 77, y: 50 },
    macOrId: "cloud-ingest.safent.mesh",
    protocol: "HTTPS_REST"
  },
  {
    id: "NODE-RESPONDER",
    name: "Safety Response Console",
    type: "RESPONDER",
    roleDescription: "Emergency Dispatch & Rapid Response Console #04",
    networkStatus: "DISPATCH_CENTER",
    signalStrengthDbm: 0,
    hasPayload: false,
    isCurrentHop: false,
    isDelivered: false,
    coords: { x: 95, y: 50 },
    macOrId: "DISPATCH-DESK-04",
    protocol: "WEBSOCKET_PUSH"
  }
];
