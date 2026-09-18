export type ScreenState = 
  | 'HOME' 
  | 'SETUP' 
  | 'ACTIVE' 
  | 'DANGER' 
  | 'SOS_ACTIVE' 
  | 'MESH_RELAY' 
  | 'RESPONDER';

export type NetworkStatus = 'OFFLINE' | 'ONLINE' | 'MESH_CONNECTED';

export interface LocationCoordinates {
  latitude: number;
  longitude: number;
  accuracyMeters: number;
  landmark: string;
  speedKmh: number;
  headingDegrees: number;
}

export interface TrustedContact {
  name: string;
  phone: string;
  relationship: string;
  notifyOnSOS: boolean;
}

export interface Journey {
  id: string;
  destination: string;
  journeyName: string;
  startTime: string;
  elapsedSeconds: number;
  status: 'SCHEDULED' | 'ACTIVE' | 'DANGER_SUSPECTED' | 'SOS_TRIGGERED' | 'COMPLETED' | 'CANCELLED';
  networkStatus: NetworkStatus;
  location: LocationCoordinates;
  battery: number;
  nearbyRelayCount: number;
  trustedContact: TrustedContact;
  monitoringEnabled: {
    audio: boolean;
    motion: boolean;
    location: boolean;
  };
}

export interface RiskFusionScore {
  audioAnomaly: number;     // e.g. +25
  impactDetected: number;    // e.g. +40
  suddenRotation: number;    // e.g. +20
  lateNightContext: number;  // e.g. +10
  totalScore: number;        // 95 / 100
  confidences: {
    impact: number;          // e.g. 96%
    audio: number;           // e.g. 88%
    rotation: number;        // e.g. 92%
    context: number;         // e.g. 99%
  };
  level: 'LOW' | 'MODERATE' | 'HIGH' | 'CRITICAL';
  detectedAt: string;
  isSimulated: boolean;
}

export interface SensorTelemetry {
  accelerometerG: number;
  gyroscopeDps: number;
  ambientDecibels: number;
  speedKmh: number;
  isNightTime: boolean;
  lastAnomalyType?: string;
  isSimulated: boolean;
}

export type IncidentStatus = 
  | 'DETECTED'
  | 'CONFIRMATION_PENDING'
  | 'CONFIRMED_SAFE'
  | 'SOS_CREATED'
  | 'RELAY_SEARCH'
  | 'RELAY_FOUND'
  | 'GATEWAY_FOUND'
  | 'DELIVERED'
  | 'RESPONDER_NOTIFIED'
  | 'ACKNOWLEDGED'
  | 'RESOLVED';

export interface Incident {
  id: string;
  journeyId: string;
  type: string;
  riskScore: number;
  riskFusion: RiskFusionScore;
  timestamp: string;
  location: LocationCoordinates;
  status: IncidentStatus;
  travellerName: string;
  battery: number;
  encryptedHash: string;
  acknowledgedBy?: string;
  acknowledgedAt?: string;
  responderNotes?: string;
  isSimulated: boolean;
}

export type MeshNodeType = 'TRAVELLER' | 'RELAY' | 'GATEWAY' | 'BACKEND' | 'RESPONDER';

export interface MeshNode {
  id: string;
  name: string;
  type: MeshNodeType;
  roleDescription: string;
  networkStatus: 'NO_INTERNET' | 'BLUETOOTH_MESH_ONLY' | 'INTERNET_ACTIVE' | 'CLOUD_INGEST' | 'DISPATCH_CENTER';
  signalStrengthDbm: number;
  batteryPercent?: number;
  hasPayload: boolean;
  isCurrentHop: boolean;
  isDelivered: boolean;
  coords: { x: number; y: number };
  macOrId: string;
  protocol: 'BLE_5.2_ADVERTISEMENT' | 'WIFI_AWARE' | 'HTTPS_REST' | 'WEBSOCKET_PUSH';
}

export interface RouteHopRecord {
  nodeId: string;
  nodeName: string;
  timestamp: string;
  hopIndex: number;
  protocol: string;
  latencyMs: number;
  actionTaken: string;
}

export interface SOSMessage {
  id: string;
  incidentId: string;
  originDevice: string;
  originId: string;
  currentNode: string;
  hopCount: number;
  maxHops: number;
  ttl: number; // Time To Live in seconds
  timestamp: string;
  status: 'PENDING_DISCOVERY' | 'RELAYING' | 'GATEWAY_UPLOADING' | 'DELIVERED_TO_BACKEND' | 'RESPONDER_ALERTED';
  encryptedPayload: string;
  payloadSizeKb: number;
  signature: string;
  deduplicationHash: string;
  isSimulated: boolean;
  routeHistory: RouteHopRecord[];
}

export interface IncidentTimelineEvent {
  id: string;
  timeString: string;
  isoTimestamp: string;
  title: string;
  description: string;
  category: 'DETECTION' | 'ASSESSMENT' | 'SAFETY_CHECK' | 'SOS' | 'MESH' | 'GATEWAY' | 'RESPONDER';
  severity: 'INFO' | 'WARNING' | 'CRITICAL' | 'SUCCESS';
}
