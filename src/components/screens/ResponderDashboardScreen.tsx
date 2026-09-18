import React, { useState } from 'react';
import { 
  LifeBuoy, 
  AlertTriangle, 
  ShieldAlert, 
  MapPin, 
  Clock, 
  Radio, 
  CheckCircle2, 
  Phone, 
  Send, 
  Navigation, 
  Car, 
  UserCheck, 
  Activity,
  Layers,
  ArrowRight,
  Sparkles,
  ShieldCheck,
  MessageSquare,
  AlertOctagon,
  Check
} from 'lucide-react';
import { useSafety } from '../../context/SafetyContext';
import { IncidentTimeline } from '../common/IncidentTimeline';

export const ResponderDashboardScreen: React.FC = () => {
  const { 
    incident, 
    journey, 
    timeline, 
    acknowledgeIncident, 
    resolveIncident, 
    setScreen, 
    currentHopIndex 
  } = useSafety();

  const [activeTab, setActiveTab] = useState<'DETAILS' | 'TIMELINE' | 'NOTIFICATIONS'>('DETAILS');
  const [dispatchStatus, setDispatchStatus] = useState<string | null>(null);

  const handleDispatchUnits = () => {
    setDispatchStatus("Ambulance 108 & Kochi Police Patrol Unit #04 dispatched to MG Road Metro Station (ETA 4 mins) [Simulated Dispatch].");
  };

  const isDelivered = incident && (incident.status === 'DELIVERED' || incident.status === 'RESPONDER_NOTIFIED' || incident.status === 'ACKNOWLEDGED' || incident.status === 'RESOLVED');
  const isAcknowledged = incident && (incident.status === 'ACKNOWLEDGED' || incident.status === 'RESOLVED');

  return (
    <div className="max-w-6xl mx-auto py-6 px-4 sm:px-6 space-y-6">
      
      {/* Response Center Header */}
      <div className="bg-[#0f1422] border border-slate-800 rounded-3xl p-6 shadow-2xl flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div className="flex items-center gap-4">
          <div className="w-12 h-12 rounded-2xl bg-rose-600/90 text-white flex items-center justify-center shadow-lg shadow-rose-950/40">
            <LifeBuoy className="w-6 h-6 animate-spin-slow" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="text-xs font-mono font-bold px-2 py-0.5 rounded bg-rose-950/80 text-rose-300 border border-rose-800/80">
                DISPATCH CONSOLE #04
              </span>
              <span className="text-xs font-mono text-slate-400">
                Kochi Central Safety Command
              </span>
            </div>
            <h1 className="text-2xl sm:text-3xl font-black text-white tracking-tight mt-0.5">
              SAFETY RESPONSE CENTER
            </h1>
          </div>
        </div>

        {/* Live Operational Status */}
        <div className="flex items-center gap-3">
          <div className="px-3.5 py-2 rounded-xl bg-slate-900 border border-slate-800 text-xs font-mono">
            <span className="text-slate-500 block text-[10px]">OPERATOR ON DUTY</span>
            <span className="text-slate-200 font-bold">Officer Radhakrishnan</span>
          </div>

          <div className="px-3.5 py-2 rounded-xl bg-slate-900 border border-slate-800 text-xs font-mono">
            <span className="text-slate-500 block text-[10px]">INCIDENTS QUEUE</span>
            <span className="text-rose-400 font-bold">{incident ? '1 CRITICAL' : '0 PENDING'}</span>
          </div>
        </div>
      </div>

      {/* No Incident State */}
      {!incident ? (
        <div className="bg-[#0f1422] border border-slate-800 rounded-3xl p-12 text-center space-y-4">
          <div className="w-16 h-16 rounded-2xl bg-slate-900 border border-slate-800 text-slate-500 mx-auto flex items-center justify-center">
            <ShieldCheck className="w-8 h-8 text-slate-600" />
          </div>
          <h3 className="text-lg font-bold text-white">All Clear — No Active Emergency Signals</h3>
          <p className="text-xs text-slate-400 max-w-md mx-auto">
            The Safety Response Center is listening for peer-relayed emergency beacons. You can simulate an incident from the Traveller view or run the full automated demo.
          </p>
          <div className="flex justify-center gap-3 pt-2">
            <button
              onClick={() => setScreen('ACTIVE')}
              className="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold"
            >
              Go to Traveller Screen
            </button>
          </div>
        </div>
      ) : (
        <div className="space-y-6">
          
          {/* Main Active Incident Card */}
          <div className={`rounded-3xl border p-6 sm:p-8 shadow-2xl transition-all ${
            isAcknowledged 
              ? 'bg-[#0f1826] border-emerald-600/80 shadow-emerald-950/30'
              : 'bg-[#15121f] border-red-600/90 shadow-red-950/50 emergency-glow'
          }`}>
            
            {/* Card Header */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-slate-800">
              <div className="space-y-1">
                <div className="flex items-center gap-2">
                  <span className="px-2.5 py-0.5 rounded bg-red-600 text-white font-mono text-[11px] font-black uppercase tracking-wider">
                    SEVERITY: HIGH
                  </span>
                  <span className="text-xs font-mono text-slate-400">
                    {incident.id}
                  </span>
                  <span className={`px-2 py-0.5 rounded text-[10px] font-mono font-bold border ${
                    isAcknowledged
                      ? 'bg-emerald-950/80 text-emerald-300 border-emerald-800'
                      : 'bg-red-950/80 text-red-300 border-red-800 animate-pulse'
                  }`}>
                    {incident.status.replace(/_/g, ' ')}
                  </span>
                </div>
                <h2 className="text-2xl font-black text-white tracking-tight">
                  {incident.type}
                </h2>
              </div>

              {/* 3 Core Action Buttons: ACKNOWLEDGE, DISPATCH, RESOLVE */}
              <div className="flex flex-wrap items-center gap-2">
                {!isAcknowledged ? (
                  <button
                    onClick={() => acknowledgeIncident()}
                    className="flex items-center gap-2 px-6 py-3 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-black text-xs uppercase tracking-wider shadow-lg shadow-emerald-950/50 active:scale-95 transition-all"
                  >
                    <CheckCircle2 className="w-4 h-4 stroke-[2.5]" />
                    <span>ACKNOWLEDGE</span>
                  </button>
                ) : (
                  <div className="flex items-center gap-2">
                    <span className="flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-emerald-950/80 border border-emerald-700 text-emerald-300 text-xs font-mono font-bold">
                      <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                      ACKNOWLEDGED
                    </span>
                    <button
                      onClick={resolveIncident}
                      disabled={incident.status === 'RESOLVED'}
                      className="px-4 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 disabled:opacity-50 text-slate-200 text-xs font-semibold border border-slate-700 transition-all"
                    >
                      {incident.status === 'RESOLVED' ? 'RESOLVED' : 'RESOLVE INCIDENT'}
                    </button>
                  </div>
                )}

                <button
                  onClick={() => setScreen('ACTIVE')}
                  className="px-4 py-2.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-300 text-xs font-semibold border border-slate-800 transition-all"
                >
                  VIEW JOURNEY
                </button>
              </div>
            </div>

            {/* Incident Key Metrics Grid */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 my-6">
              
              <div className="p-3.5 rounded-2xl bg-[#0a0d16] border border-slate-800">
                <span className="text-slate-500 block text-[10px] font-mono uppercase">TRAVELLER</span>
                <span className="font-bold text-sm text-white">{incident.travellerName}</span>
                <span className="text-[10px] text-slate-400 block font-mono">Battery: {journey.battery}%</span>
              </div>

              <div className="p-3.5 rounded-2xl bg-[#0a0d16] border border-slate-800">
                <span className="text-slate-500 block text-[10px] font-mono uppercase">SEVERITY</span>
                <span className="font-black text-sm text-red-400 font-mono">HIGH (95 / 100)</span>
                <span className="text-[10px] text-red-400/80 block font-mono">Multi-Sensor Spike</span>
              </div>

              <div className="p-3.5 rounded-2xl bg-[#0a0d16] border border-slate-800">
                <span className="text-slate-500 block text-[10px] font-mono uppercase">LOCATION</span>
                <span className="font-bold text-sm text-white truncate block">{journey.location.landmark}</span>
                <span className="text-[10px] text-cyan-400 font-mono">9.9674° N, 76.2848° E</span>
              </div>

              <div className="p-3.5 rounded-2xl bg-[#0a0d16] border border-slate-800">
                <span className="text-slate-500 block text-[10px] font-mono uppercase">NETWORK ROUTE</span>
                <span className="font-bold text-sm text-indigo-300">Relayed via 2 devices</span>
                <span className="text-[10px] text-emerald-400 font-mono">Gateway: 5G Uplink</span>
              </div>

            </div>

            {/* Dispatch Units Action Section */}
            <div className="p-4 rounded-2xl bg-slate-900/60 border border-slate-800 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
              <div className="flex items-center gap-3">
                <Car className="w-5 h-5 text-amber-400 shrink-0" />
                <div>
                  <span className="text-xs font-bold text-slate-200 block">
                    Emergency Unit Vectoring
                  </span>
                  <span className="text-[11px] text-slate-400">
                    {dispatchStatus || "Simulated integration with Ambulance 108 and nearest traffic patrol dispatch."}
                  </span>
                </div>
              </div>

              {!dispatchStatus ? (
                <button
                  onClick={handleDispatchUnits}
                  className="px-4 py-2 rounded-xl bg-amber-600 hover:bg-amber-500 text-white font-bold text-xs uppercase tracking-wider shrink-0 transition-all active:scale-95 shadow-lg shadow-amber-950/40"
                >
                  DISPATCH UNITS (108 / POLICE)
                </button>
              ) : (
                <span className="text-xs font-mono text-emerald-400 font-bold px-3 py-1 rounded bg-emerald-950/80 border border-emerald-800 flex items-center gap-1.5">
                  <Check className="w-3.5 h-3.5" />
                  UNITS DISPATCHED (ETA 4 MINS)
                </span>
              )}
            </div>

          </div>

          {/* Sub-Tabs: Relay Route Audit / Incident Timeline / Trusted Contact Simulator */}
          <div className="space-y-4">
            
            <div className="flex items-center gap-2 border-b border-slate-800 pb-2">
              <button
                onClick={() => setActiveTab('DETAILS')}
                className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                  activeTab === 'DETAILS'
                    ? 'bg-slate-800 text-white border border-slate-700'
                    : 'text-slate-400 hover:text-white'
                }`}
              >
                Relay Hop Route & Integrity
              </button>

              <button
                onClick={() => setActiveTab('TIMELINE')}
                className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                  activeTab === 'TIMELINE'
                    ? 'bg-slate-800 text-white border border-slate-700'
                    : 'text-slate-400 hover:text-white'
                }`}
              >
                Incident Timeline ({timeline.length})
              </button>

              <button
                onClick={() => setActiveTab('NOTIFICATIONS')}
                className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                  activeTab === 'NOTIFICATIONS'
                    ? 'bg-slate-800 text-white border border-slate-700'
                    : 'text-slate-400 hover:text-white'
                }`}
              >
                Trusted Contact Alert Simulation
              </button>
            </div>

            {/* Tab 1: Detailed Relay Route */}
            {activeTab === 'DETAILS' && (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                
                {/* Relay Hop Breakdown */}
                <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 space-y-4">
                  <h3 className="font-bold text-sm text-slate-200 uppercase tracking-wider font-mono">
                    Store-and-Forward Route Path
                  </h3>
                  
                  <div className="space-y-3">
                    <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800 text-xs font-mono space-y-1">
                      <div className="flex justify-between text-red-400 font-bold">
                        <span>ORIGIN: Traveller Phone A</span>
                        <span>0ms</span>
                      </div>
                      <div className="text-slate-400 text-[11px]">Device: Samsung Galaxy S23 (Offline Shadow Zone)</div>
                      <div className="text-slate-500 text-[10px]">Protocol: BLE 5.2 Extended Advertising</div>
                    </div>

                    <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800 text-xs font-mono space-y-1">
                      <div className="flex justify-between text-indigo-400 font-bold">
                        <span>RELAY 1: Relay Phone B</span>
                        <span>+140ms</span>
                      </div>
                      <div className="text-slate-400 text-[11px]">Peer: Commuter in auto-rickshaw 35m ahead</div>
                      <div className="text-slate-500 text-[10px]">Protocol: BLE 5.2 Advertisement (RSSI -68 dBm)</div>
                    </div>

                    <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800 text-xs font-mono space-y-1">
                      <div className="flex justify-between text-emerald-400 font-bold">
                        <span>GATEWAY: Gateway Phone C</span>
                        <span>+220ms</span>
                      </div>
                      <div className="text-slate-400 text-[11px]">Peer: Pedestrian with active 5G reception</div>
                      <div className="text-slate-500 text-[10px]">Protocol: Wi-Fi Aware / HTTPS REST Gateway Upload</div>
                    </div>

                    <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800 text-xs font-mono space-y-1">
                      <div className="flex justify-between text-cyan-400 font-bold">
                        <span>DESTINATION: Cloud Ingest & Console</span>
                        <span>+85ms</span>
                      </div>
                      <div className="text-slate-400 text-[11px]">Server: Cloud SOS Ingestion Node</div>
                      <div className="text-slate-500 text-[10px]">Protocol: WebSocket Push to Dispatch Desk #04</div>
                    </div>
                  </div>
                </div>

                {/* Cryptographic Verification */}
                <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 space-y-4">
                  <h3 className="font-bold text-sm text-slate-200 uppercase tracking-wider font-mono">
                    Integrity & Payload Decryption
                  </h3>

                  <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800 space-y-2 text-xs font-mono">
                    <div className="text-slate-500">PROPOSED ENCRYPTION:</div>
                    <div className="text-cyan-400 font-bold">AES-GCM-256 Public-Key Envelope</div>

                    <div className="text-slate-500 pt-2">SIMULATED CIPHERTEXT DIGEST:</div>
                    <div className="text-slate-300 break-all text-[11px]">
                      {incident.encryptedHash}
                    </div>

                    <div className="text-slate-500 pt-2">DECRYPTED DISPATCH TELEMETRY:</div>
                    <div className="text-emerald-400 text-[11px] leading-relaxed font-sans">
                      ✓ GPS Verified: 9.9674° N, 76.2848° E (MG Road Metro Station)<br />
                      ✓ Risk Score: 95/100 (HIGH IMPACT & ACOUSTIC SHATTER)<br />
                      ✓ Battery State: 78% remaining<br />
                      ✓ Safety challenge timed out (no user cancellation)
                    </div>
                  </div>

                  <div className="p-3.5 rounded-xl bg-slate-900/60 border border-slate-800 text-xs text-slate-400 leading-relaxed font-sans">
                    <strong>Zero Privacy Leakage:</strong> Relaying phones (Phones B and C) simply carried encrypted byte buffers without the private key. No personal identity or contacts were accessible until reaching the authenticated dispatch console.
                  </div>
                </div>

              </div>
            )}

            {/* Tab 2: Audit Timeline */}
            {activeTab === 'TIMELINE' && (
              <IncidentTimeline events={timeline} />
            )}

            {/* Tab 3: Trusted Contact Alert Simulator */}
            {activeTab === 'NOTIFICATIONS' && (
              <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-6 space-y-4">
                <div className="flex items-center justify-between pb-3 border-b border-slate-800">
                  <div className="flex items-center gap-2">
                    <MessageSquare className="w-4 h-4 text-emerald-400" />
                    <h3 className="font-bold text-sm text-slate-200 uppercase font-mono">
                      Simulated Emergency SMS Dispatch
                    </h3>
                  </div>
                  <span className="text-xs font-mono text-slate-400">
                    Recipient: {journey.trustedContact.phone}
                  </span>
                </div>

                <div className="max-w-md mx-auto p-4 rounded-2xl bg-[#090d16] border border-slate-800 space-y-3 font-sans shadow-lg">
                  <div className="flex items-center justify-between text-xs text-slate-400 pb-2 border-b border-slate-800">
                    <span className="font-bold text-slate-200">EMERGENCY ALERT (Govt Safety Relay)</span>
                    <span className="font-mono">{incident.timestamp}</span>
                  </div>

                  <p className="text-xs text-slate-200 leading-relaxed">
                    🚨 <strong>URGENT:</strong> An automated high-risk emergency SOS has been received for <strong>{journey.trustedContact.name}'s contact</strong> near <strong>{journey.location.landmark}</strong>.
                  </p>

                  <div className="p-2.5 rounded-xl bg-slate-900 border border-slate-800 text-[11px] font-mono text-slate-300">
                    📍 Last GPS: 9.9674° N, 76.2848° E<br />
                    🚑 Status: Response center acknowledged; units dispatched.<br />
                    🔗 Live Tracking: https://sos.mesh.kerala.gov.in/{journey.id}
                  </div>

                  <div className="text-[10px] text-slate-500 text-right font-mono">
                    ✓ Simulated delivery via Gateway C 5G cellular uplink
                  </div>
                </div>
              </div>
            )}

          </div>

        </div>
      )}

    </div>
  );
};
