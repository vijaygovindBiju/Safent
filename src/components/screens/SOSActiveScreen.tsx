import React from 'react';
import { 
  ShieldAlert, 
  Lock, 
  Radio, 
  Wifi, 
  Server, 
  LifeBuoy, 
  Clock, 
  MapPin, 
  CheckCircle2, 
  ArrowRight, 
  FastForward,
  Cpu,
  Layers
} from 'lucide-react';
import { useSafety } from '../../context/SafetyContext';

export const SOSActiveScreen: React.FC = () => {
  const { 
    incident, 
    sosMessage, 
    journey, 
    advanceMeshHop, 
    currentHopIndex, 
    setScreen 
  } = useSafety();

  const stages = [
    { label: "Incident created", done: true, key: "created" },
    { label: "Message encrypted (AES-256)", done: true, key: "encrypted" },
    { label: "Searching for mesh relay", done: true, key: "searching" },
    { label: "Relay Phone B discovered", done: currentHopIndex >= 1, active: currentHopIndex === 0, key: "relay" },
    { label: "Internet Gateway Phone C found", done: currentHopIndex >= 2, active: currentHopIndex === 1, key: "gateway" },
    { label: "Delivered to SOS Cloud Backend", done: currentHopIndex >= 3, active: currentHopIndex === 2, key: "backend" },
    { label: "Responder Dashboard Alerted", done: currentHopIndex >= 4, active: currentHopIndex === 3, key: "responder" }
  ];

  return (
    <div className="max-w-5xl mx-auto py-6 px-4 sm:px-6 space-y-6">
      
      {/* High Urgency Status Banner */}
      <div className="bg-gradient-to-r from-red-950/80 via-slate-900 to-red-950/80 border-2 border-red-600 rounded-3xl p-6 sm:p-8 shadow-2xl relative overflow-hidden emergency-glow">
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="w-14 h-14 rounded-2xl bg-red-600 text-white flex items-center justify-center shadow-xl shadow-red-900/60 animate-pulse">
              <ShieldAlert className="w-8 h-8" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="text-xs font-mono font-black px-2.5 py-0.5 rounded bg-red-600 text-white tracking-widest uppercase animate-pulse">
                  SOS ACTIVE
                </span>
                <span className="text-xs font-mono text-red-300">
                  {incident?.id || 'INC-884291'}
                </span>
              </div>
              <h2 className="text-2xl sm:text-3xl font-black text-white tracking-tight mt-1">
                Emergency Beacon Broadcasting
              </h2>
              <p className="text-xs sm:text-sm text-red-200 mt-0.5">
                Zero internet connection available on origin device. Mesh Store-and-Forward engaged.
              </p>
            </div>
          </div>

          {/* Quick Nav to Visualizer */}
          <div className="flex flex-wrap items-center gap-2 w-full md:w-auto">
            <button
              onClick={() => setScreen('MESH_RELAY')}
              className="flex-1 sm:flex-none flex items-center justify-center gap-2 px-5 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs uppercase tracking-wider shadow-lg shadow-indigo-950/50 transition-all"
            >
              <span>Open Mesh Visualizer</span>
              <ArrowRight className="w-4 h-4" />
            </button>
            <button
              onClick={() => setScreen('RESPONDER')}
              className="flex-1 sm:flex-none flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 font-semibold text-xs border border-slate-700 transition-all"
            >
              <span>Responder Desk</span>
            </button>
          </div>
        </div>
      </div>

      {/* Incident Metadata & Cryptographic Payload Row */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        
        {/* Incident Summary */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 space-y-3 shadow-lg">
          <span className="text-[11px] font-mono text-slate-400 uppercase tracking-wider block font-bold">
            Incident Telemetry
          </span>
          <div className="space-y-2 text-xs">
            <div className="flex justify-between py-1 border-b border-slate-800/80">
              <span className="text-slate-400">Incident Type:</span>
              <span className="font-semibold text-red-400">{incident?.type || "Possible crash"}</span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-800/80">
              <span className="text-slate-400">Risk Assessment:</span>
              <span className="font-bold text-red-400 font-mono">95 / 100 (HIGH)</span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-800/80">
              <span className="text-slate-400">Time Registered:</span>
              <span className="font-mono text-slate-200">{incident?.timestamp || "22:47:03"}</span>
            </div>
            <div className="flex justify-between py-1">
              <span className="text-slate-400">Battery Level:</span>
              <span className="font-mono text-emerald-400 font-semibold">{journey.battery}%</span>
            </div>
          </div>
        </div>

        {/* Location Snapshot */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 space-y-3 shadow-lg">
          <span className="text-[11px] font-mono text-slate-400 uppercase tracking-wider block font-bold">
            Last Known Coordinates
          </span>
          <div className="space-y-2 text-xs">
            <div className="flex items-center gap-1.5 text-slate-200 font-semibold">
              <MapPin className="w-3.5 h-3.5 text-red-400" />
              <span>{journey.location.landmark}</span>
            </div>
            <div className="p-2.5 rounded-xl bg-[#090d16] border border-slate-800 font-mono text-[11px] text-slate-300">
              <div>LAT: {journey.location.latitude.toFixed(5)}° N</div>
              <div>LNG: {journey.location.longitude.toFixed(5)}° E</div>
              <div className="text-slate-500 text-[10px] mt-0.5">Accuracy radius: ±{journey.location.accuracyMeters}m</div>
            </div>
            <div className="text-[11px] text-slate-400">
              Target Destination: <strong className="text-white">{journey.destination}</strong>
            </div>
          </div>
        </div>

        {/* Cryptographic Mesh Packet */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 space-y-3 shadow-lg">
          <div className="flex items-center justify-between">
            <span className="text-[11px] font-mono text-slate-400 uppercase tracking-wider font-bold flex items-center gap-1">
              <Lock className="w-3.5 h-3.5 text-cyan-400" />
              <span>Encrypted Packet</span>
            </span>
            <span className="text-[10px] font-mono px-1.5 py-0.5 rounded bg-cyan-950/80 text-cyan-300 border border-cyan-800">
              AES-GCM-256
            </span>
          </div>
          <p className="text-[11px] text-slate-400">
            Relay phones only forward encrypted payload blocks; personal identity and destination are decrypted only by certified emergency dispatchers.
          </p>
          <div className="p-2 rounded bg-[#090d16] border border-slate-800 text-[10px] font-mono text-cyan-400/90 break-all">
            {sosMessage?.encryptedPayload || "AES-GCM-256:7f90e1c28834a9b... [Payload Signed]"}
          </div>
        </div>

      </div>

      {/* Visual Centerpiece: Step Status Pipeline & Next Hop Trigger */}
      <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-6 shadow-xl space-y-6">
        
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-slate-800/80">
          <div>
            <h3 className="font-bold text-base text-white tracking-tight">
              SOS Mesh Propagation Status
            </h3>
            <p className="text-xs text-slate-400 mt-0.5">
              Current Hop: <span className="font-mono text-cyan-400 font-bold">{currentHopIndex} / 4</span> — {
                currentHopIndex === 0 ? 'Searching for nearby peers' :
                currentHopIndex === 1 ? 'Relayed to Phone B' :
                currentHopIndex === 2 ? 'Gateway Phone C uploading via 5G' :
                currentHopIndex === 3 ? 'Ingested by Cloud Backend' :
                'Delivered & Alerted Responder Desk'
              }
            </p>
          </div>

          {/* Manual Hop Advance Button */}
          {currentHopIndex < 4 && (
            <button
              onClick={advanceMeshHop}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-gradient-to-r from-cyan-600 to-indigo-600 hover:from-cyan-500 hover:to-indigo-500 text-white font-bold text-xs uppercase tracking-wider shadow-lg shadow-cyan-950/50 transition-all active:scale-95 self-start sm:self-auto"
            >
              <FastForward className="w-4 h-4" />
              <span>Step Next Hop (Hop {currentHopIndex + 1})</span>
            </button>
          )}
        </div>

        {/* Status Checkmarks List */}
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3">
          {stages.map((st) => (
            <div
              key={st.key}
              className={`p-3 rounded-xl border transition-all flex items-center gap-3 ${
                st.done
                  ? 'bg-emerald-950/40 border-emerald-800/70 text-emerald-200'
                  : st.active
                  ? 'bg-amber-950/40 border-amber-600 text-amber-200 animate-pulse'
                  : 'bg-[#090d16] border-slate-800/60 text-slate-500'
              }`}
            >
              <div className="shrink-0">
                {st.done ? (
                  <CheckCircle2 className="w-5 h-5 text-emerald-400" />
                ) : st.active ? (
                  <Radio className="w-5 h-5 text-amber-400 animate-spin-slow" />
                ) : (
                  <div className="w-5 h-5 rounded-full border border-slate-700" />
                )}
              </div>
              <span className="text-xs font-semibold">
                {st.label}
              </span>
            </div>
          ))}
        </div>

        {/* Hop Flow Progression Nodes */}
        <div className="mt-6 pt-6 border-t border-slate-800/80">
          <div className="text-xs font-mono uppercase tracking-wider text-slate-400 mb-4 font-bold">
            End-to-End Node Chain Progression
          </div>

          <div className="flex flex-col md:flex-row items-center justify-between gap-3 relative">
            
            {/* Node 1: Traveller */}
            <div className={`w-full md:w-48 p-4 rounded-xl border text-center transition-all ${
              currentHopIndex >= 0 ? 'bg-[#0c1424] border-red-500 shadow-lg shadow-red-950/40' : 'bg-[#090d16] border-slate-800'
            }`}>
              <span className="text-[10px] font-mono text-red-400 font-bold block mb-1">ORIGIN</span>
              <div className="w-9 h-9 rounded-full bg-red-600 text-white mx-auto flex items-center justify-center mb-2">
                <Radio className="w-4 h-4" />
              </div>
              <h4 className="font-bold text-xs text-white">Phone A (Traveller)</h4>
              <span className="text-[10px] text-red-400 font-mono block mt-1">NO INTERNET</span>
            </div>

            <div className="text-slate-600 hidden md:block">→</div>

            {/* Node 2: Relay */}
            <div className={`w-full md:w-48 p-4 rounded-xl border text-center transition-all ${
              currentHopIndex >= 1 ? 'bg-[#0c1424] border-indigo-500 shadow-lg shadow-indigo-950/40' : 'bg-[#090d16] border-slate-800 opacity-60'
            }`}>
              <span className="text-[10px] font-mono text-indigo-400 font-bold block mb-1">HOP 1</span>
              <div className="w-9 h-9 rounded-full bg-indigo-600 text-white mx-auto flex items-center justify-center mb-2">
                <Radio className="w-4 h-4" />
              </div>
              <h4 className="font-bold text-xs text-white">Phone B (Relay)</h4>
              <span className="text-[10px] text-indigo-300 font-mono block mt-1">Nearby Peer (35m)</span>
            </div>

            <div className="text-slate-600 hidden md:block">→</div>

            {/* Node 3: Gateway */}
            <div className={`w-full md:w-48 p-4 rounded-xl border text-center transition-all ${
              currentHopIndex >= 2 ? 'bg-[#0c1424] border-emerald-500 shadow-lg shadow-emerald-950/40' : 'bg-[#090d16] border-slate-800 opacity-60'
            }`}>
              <span className="text-[10px] font-mono text-emerald-400 font-bold block mb-1">HOP 2 (GATEWAY)</span>
              <div className="w-9 h-9 rounded-full bg-emerald-600 text-white mx-auto flex items-center justify-center mb-2">
                <Wifi className="w-4 h-4" />
              </div>
              <h4 className="font-bold text-xs text-white">Phone C (Gateway)</h4>
              <span className="text-[10px] text-emerald-300 font-mono block mt-1">5G Cellular Active</span>
            </div>

            <div className="text-slate-600 hidden md:block">→</div>

            {/* Node 4: Backend */}
            <div className={`w-full md:w-48 p-4 rounded-xl border text-center transition-all ${
              currentHopIndex >= 3 ? 'bg-[#0c1424] border-cyan-500 shadow-lg shadow-cyan-950/40' : 'bg-[#090d16] border-slate-800 opacity-60'
            }`}>
              <span className="text-[10px] font-mono text-cyan-400 font-bold block mb-1">HOP 3</span>
              <div className="w-9 h-9 rounded-full bg-cyan-600 text-white mx-auto flex items-center justify-center mb-2">
                <Server className="w-4 h-4" />
              </div>
              <h4 className="font-bold text-xs text-white">SOS Backend</h4>
              <span className="text-[10px] text-cyan-300 font-mono block mt-1">Cloud Ingest</span>
            </div>

            <div className="text-slate-600 hidden md:block">→</div>

            {/* Node 5: Responder */}
            <div className={`w-full md:w-48 p-4 rounded-xl border text-center transition-all ${
              currentHopIndex >= 4 ? 'bg-[#0c1424] border-rose-500 shadow-lg shadow-rose-950/40' : 'bg-[#090d16] border-slate-800 opacity-60'
            }`}>
              <span className="text-[10px] font-mono text-rose-400 font-bold block mb-1">DISPATCH</span>
              <div className="w-9 h-9 rounded-full bg-rose-600 text-white mx-auto flex items-center justify-center mb-2">
                <LifeBuoy className="w-4 h-4" />
              </div>
              <h4 className="font-bold text-xs text-white">Help Dashboard</h4>
              <span className="text-[10px] text-rose-300 font-mono block mt-1">Responder Notified</span>
            </div>

          </div>

        </div>

      </div>

    </div>
  );
};
