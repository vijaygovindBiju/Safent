import React, { useState, useEffect } from 'react';
import { 
  Network, 
  Radio, 
  Wifi, 
  WifiOff, 
  Server, 
  LifeBuoy, 
  Clock, 
  ShieldCheck, 
  Layers, 
  Play, 
  Pause, 
  RotateCcw, 
  FastForward, 
  CheckCircle2, 
  Lock, 
  Cpu, 
  Smartphone,
  Zap,
  ArrowRight,
  Code2,
  ChevronDown,
  ChevronUp,
  Info
} from 'lucide-react';
import { useSafety } from '../../context/SafetyContext';
import { MeshNode } from '../../types';

export const MeshVisualizationScreen: React.FC = () => {
  const { 
    meshNodes, 
    currentHopIndex, 
    advanceMeshHop, 
    sosMessage, 
    journey, 
    incident,
    setScreen
  } = useSafety();

  const [isAutoStepping, setIsAutoStepping] = useState<boolean>(false);
  const [selectedNodeId, setSelectedNodeId] = useState<string>("NODE-A");
  const [showProtocolEngine, setShowProtocolEngine] = useState<boolean>(true);

  useEffect(() => {
    let timer: ReturnType<typeof setTimeout>;
    if (isAutoStepping && currentHopIndex < 4) {
      timer = setTimeout(() => {
        advanceMeshHop();
      }, 2500);
    } else if (currentHopIndex >= 4) {
      setIsAutoStepping(false);
    }
    return () => clearTimeout(timer);
  }, [isAutoStepping, currentHopIndex, advanceMeshHop]);

  const selectedNode = meshNodes.find(n => n.id === selectedNodeId) || meshNodes[0];

  const getNodeIcon = (type: MeshNode['type']) => {
    switch (type) {
      case 'TRAVELLER':
        return <Smartphone className="w-5 h-5 text-red-400" />;
      case 'RELAY':
        return <Radio className="w-5 h-5 text-indigo-400" />;
      case 'GATEWAY':
        return <Wifi className="w-5 h-5 text-emerald-400" />;
      case 'BACKEND':
        return <Server className="w-5 h-5 text-cyan-400" />;
      case 'RESPONDER':
        return <LifeBuoy className="w-5 h-5 text-rose-400" />;
    }
  };

  return (
    <div className="max-w-6xl mx-auto py-6 px-4 sm:px-6 space-y-6">
      
      {/* Top Controls & Explanation Banner */}
      <div className="bg-[#0f1422] border border-slate-800 rounded-3xl p-6 shadow-xl space-y-4">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-950/80 border border-indigo-700 text-xs font-mono text-indigo-300 mb-2">
              <Network className="w-3.5 h-3.5" />
              <span>STORE-AND-FORWARD MULTI-HOP ARCHITECTURE</span>
            </div>
            <h2 className="text-2xl sm:text-3xl font-black text-white tracking-tight">
              Interactive Mesh Relay Visualization
            </h2>
            <p className="text-xs sm:text-sm text-slate-300 mt-1 max-w-2xl">
              Even when the traveller's phone has no Internet, their SOS hops peer-to-peer across nearby participating devices until reaching an Internet-connected gateway.
            </p>
          </div>

          {/* Hop Stepping Controls */}
          <div className="flex flex-wrap items-center gap-2">
            <button
              onClick={() => setIsAutoStepping(!isAutoStepping)}
              disabled={currentHopIndex >= 4}
              className={`flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-bold uppercase transition-all shadow-md active:scale-95 ${
                isAutoStepping
                  ? 'bg-amber-600 text-white'
                  : 'bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700'
              }`}
            >
              {isAutoStepping ? <Pause className="w-3.5 h-3.5" /> : <Play className="w-3.5 h-3.5" />}
              <span>{isAutoStepping ? 'Pause Auto' : 'Auto Play Hops'}</span>
            </button>

            <button
              onClick={advanceMeshHop}
              disabled={currentHopIndex >= 4}
              className="flex items-center gap-1.5 px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 disabled:opacity-50 text-white text-xs font-bold uppercase tracking-wider shadow-lg shadow-indigo-950/50 transition-all active:scale-95"
            >
              <FastForward className="w-3.5 h-3.5" />
              <span>Step Next Hop</span>
            </button>

            <button
              onClick={() => setScreen('RESPONDER')}
              className="flex items-center gap-1.5 px-4 py-2 rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-300 text-xs font-semibold border border-slate-700 transition-all"
            >
              <span>View Responder</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>

        {/* Live Packet Header Badge */}
        <div className="grid grid-cols-2 sm:grid-cols-5 gap-2 pt-4 border-t border-slate-800 text-xs font-mono">
          <div className="p-2.5 rounded-xl bg-[#090d16] border border-slate-800">
            <span className="text-slate-500 block text-[10px]">MESSAGE ID</span>
            <span className="font-bold text-cyan-400">{sosMessage?.id || 'SOS-PKT-28491'}</span>
          </div>
          <div className="p-2.5 rounded-xl bg-[#090d16] border border-slate-800">
            <span className="text-slate-500 block text-[10px]">CURRENT HOP</span>
            <span className="font-bold text-amber-400">{currentHopIndex} / 4 Hops</span>
          </div>
          <div className="p-2.5 rounded-xl bg-[#090d16] border border-slate-800">
            <span className="text-slate-500 block text-[10px]">TIME TO LIVE (TTL)</span>
            <span className="font-bold text-emerald-400">{sosMessage?.ttl || 300}s</span>
          </div>
          <div className="p-2.5 rounded-xl bg-[#090d16] border border-slate-800">
            <span className="text-slate-500 block text-[10px]">DELIVERY STATUS</span>
            <span className={`font-bold ${currentHopIndex >= 4 ? 'text-emerald-400' : 'text-amber-400'}`}>
              {currentHopIndex >= 4 ? 'DELIVERED' : currentHopIndex >= 2 ? 'UPLOADING' : 'RELAYING'}
            </span>
          </div>
          <div className="p-2.5 rounded-xl bg-[#090d16] border border-slate-800 col-span-2 sm:col-span-1">
            <span className="text-slate-500 block text-[10px]">ENCRYPTION</span>
            <span className="font-bold text-slate-200">AES-256 (Simulated)</span>
          </div>
        </div>
      </div>

      {/* Main Interactive Diagram Canvas */}
      <div className="relative bg-[#090d16] border border-slate-800 rounded-3xl p-6 sm:p-10 shadow-2xl overflow-hidden min-h-[380px] flex flex-col justify-between">
        
        {/* SVG Interconnecting Mesh Lines */}
        <svg className="absolute inset-0 w-full h-full pointer-events-none" xmlns="http://www.w3.org/2000/svg">
          <line x1="10%" y1="50%" x2="30%" y2="50%" stroke={currentHopIndex >= 1 ? "#6366f1" : "#1e293b"} strokeWidth={currentHopIndex >= 1 ? "4" : "2"} strokeDasharray={currentHopIndex >= 1 ? "6 3" : "4 4"} className={currentHopIndex === 0 ? "mesh-path-active" : ""} />
          <line x1="30%" y1="50%" x2="50%" y2="50%" stroke={currentHopIndex >= 2 ? "#10b981" : "#1e293b"} strokeWidth={currentHopIndex >= 2 ? "4" : "2"} strokeDasharray={currentHopIndex >= 2 ? "6 3" : "4 4"} className={currentHopIndex === 1 ? "mesh-path-active" : ""} />
          <line x1="50%" y1="50%" x2="70%" y2="50%" stroke={currentHopIndex >= 3 ? "#0ea5e9" : "#1e293b"} strokeWidth={currentHopIndex >= 3 ? "4" : "2"} strokeDasharray={currentHopIndex >= 3 ? "6 3" : "4 4"} className={currentHopIndex === 2 ? "mesh-path-active" : ""} />
          <line x1="70%" y1="50%" x2="90%" y2="50%" stroke={currentHopIndex >= 4 ? "#f43f5e" : "#1e293b"} strokeWidth={currentHopIndex >= 4 ? "4" : "2"} strokeDasharray={currentHopIndex >= 4 ? "6 3" : "4 4"} className={currentHopIndex === 3 ? "mesh-path-active" : ""} />
        </svg>

        {/* 5 Mesh Nodes in visual pipeline */}
        <div className="grid grid-cols-1 md:grid-cols-5 gap-4 relative z-10 my-auto">
          
          {meshNodes.map((node, index) => {
            const isOrigin = node.type === 'TRAVELLER';
            const isGateway = node.type === 'GATEWAY';
            const isRelay = node.type === 'RELAY';
            const isBackend = node.type === 'BACKEND';
            const isResponder = node.type === 'RESPONDER';
            
            const hasPacket = node.hasPayload || currentHopIndex >= index;
            const isCurrent = currentHopIndex === index;
            const isSelected = selectedNodeId === node.id;

            return (
              <div
                key={node.id}
                onClick={() => setSelectedNodeId(node.id)}
                className={`cursor-pointer rounded-2xl p-4 border transition-all relative flex flex-col justify-between select-none ${
                  isSelected ? 'ring-2 ring-cyan-400' : ''
                } ${
                  isCurrent
                    ? 'bg-[#151c2e] border-amber-500 shadow-xl shadow-amber-950/60 scale-105 animate-pulse-fast'
                    : hasPacket
                    ? 'bg-[#0f1422] border-emerald-500/80 shadow-lg'
                    : 'bg-[#0c101a]/80 border-slate-800 opacity-60 hover:opacity-100'
                }`}
              >
                {/* Current packet indicator dot */}
                {isCurrent && (
                  <div className="absolute -top-3 left-1/2 -translate-x-1/2 px-2 py-0.5 rounded-full bg-amber-500 text-black text-[9px] font-mono font-black uppercase tracking-wider shadow animate-bounce">
                    PACKET HERE
                  </div>
                )}

                <div>
                  <div className="flex items-center justify-between mb-3">
                    <div className={`w-10 h-10 rounded-xl flex items-center justify-center border shadow-inner ${
                      isOrigin ? 'bg-red-950/80 border-red-700' :
                      isRelay ? 'bg-indigo-950/80 border-indigo-700' :
                      isGateway ? 'bg-emerald-950/80 border-emerald-700' :
                      isBackend ? 'bg-cyan-950/80 border-cyan-700' :
                      'bg-rose-950/80 border-rose-700'
                    }`}>
                      {getNodeIcon(node.type)}
                    </div>
                    
                    <span className="text-[10px] font-mono text-slate-400">
                      HOP {index}
                    </span>
                  </div>

                  <h3 className="font-bold text-xs text-white leading-tight">
                    {node.name}
                  </h3>

                  <p className="text-[11px] text-slate-400 mt-1 leading-snug">
                    {node.roleDescription}
                  </p>
                </div>

                <div className="mt-4 pt-3 border-t border-slate-800 text-[10px] font-mono space-y-1">
                  <div className="flex justify-between items-center">
                    <span className="text-slate-500">Network:</span>
                    <span className={`font-semibold ${
                      node.networkStatus === 'NO_INTERNET' ? 'text-red-400' :
                      node.networkStatus === 'INTERNET_ACTIVE' || node.networkStatus === 'CLOUD_INGEST' ? 'text-emerald-400' :
                      'text-indigo-400'
                    }`}>
                      {node.networkStatus === 'NO_INTERNET' ? 'NO INTERNET' :
                       node.networkStatus === 'INTERNET_ACTIVE' ? '5G ACTIVE' :
                       node.networkStatus === 'BLUETOOTH_MESH_ONLY' ? 'BLE MESH' :
                       'CLOUD UPLINK'}
                    </span>
                  </div>

                  <div className="flex justify-between items-center">
                    <span className="text-slate-500">Protocol:</span>
                    <span className="text-slate-300">{node.protocol.split('_')[0]}</span>
                  </div>
                </div>

              </div>
            );
          })}

        </div>

        {/* Live Packet Flow Legend Bar */}
        <div className="mt-6 pt-4 border-t border-slate-800/80 flex flex-wrap items-center justify-between gap-3 text-xs text-slate-400 font-mono">
          <div className="flex items-center gap-4">
            <span className="flex items-center gap-1.5">
              <span className="w-2.5 h-2.5 rounded-full bg-red-500" /> Origin (Offline)
            </span>
            <span className="flex items-center gap-1.5">
              <span className="w-2.5 h-2.5 rounded-full bg-indigo-500" /> Relay Peer
            </span>
            <span className="flex items-center gap-1.5">
              <span className="w-2.5 h-2.5 rounded-full bg-emerald-500" /> 5G Gateway
            </span>
            <span className="flex items-center gap-1.5">
              <span className="w-2.5 h-2.5 rounded-full bg-rose-500" /> Dispatch
            </span>
          </div>

          <div>
            Click any node card to inspect its simulated MAC address, protocol & payload state.
          </div>
        </div>

      </div>

      {/* Phase 10: Store-and-Forward Mesh Protocol Engine & Schema Panel */}
      <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
        
        <div className="flex items-center justify-between pb-3 border-b border-slate-800">
          <div className="flex items-center gap-2">
            <Code2 className="w-4 h-4 text-cyan-400" />
            <h3 className="font-bold text-sm text-slate-200 uppercase font-mono tracking-wide">
              Store-and-Forward Protocol Engine & Packet Schema
            </h3>
          </div>
          <button
            onClick={() => setShowProtocolEngine(!showProtocolEngine)}
            className="text-slate-400 hover:text-white text-xs font-mono flex items-center gap-1"
          >
            <span>{showProtocolEngine ? 'Collapse' : 'Expand'}</span>
            {showProtocolEngine ? <ChevronUp className="w-3.5 h-3.5" /> : <ChevronDown className="w-3.5 h-3.5" />}
          </button>
        </div>

        {showProtocolEngine && (
          <div className="space-y-4">
            
            {/* 6 Step Protocol Lifecycle */}
            <div className="grid grid-cols-2 md:grid-cols-6 gap-2 text-xs font-mono">
              <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800">
                <span className="text-cyan-400 font-bold block mb-1">1. RECEIVES</span>
                <span className="text-[11px] text-slate-400 font-sans">Listens on BLE advertisement channel</span>
              </div>
              <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800">
                <span className="text-cyan-400 font-bold block mb-1">2. VALIDATES</span>
                <span className="text-[11px] text-slate-400 font-sans">Checks cryptographic signature</span>
              </div>
              <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800">
                <span className="text-cyan-400 font-bold block mb-1">3. DEDUPES</span>
                <span className="text-[11px] text-slate-400 font-sans">Rejects duplicate message_id cache</span>
              </div>
              <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800">
                <span className="text-cyan-400 font-bold block mb-1">4. DECREMENTS</span>
                <span className="text-[11px] text-slate-400 font-sans">TTL = TTL - 1 (Prevents broadcast storm)</span>
              </div>
              <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800">
                <span className="text-cyan-400 font-bold block mb-1">5. FORWARDS</span>
                <span className="text-[11px] text-slate-400 font-sans">Re-broadcasts or initiates 5G upload</span>
              </div>
              <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800">
                <span className="text-cyan-400 font-bold block mb-1">6. RECORDS</span>
                <span className="text-[11px] text-slate-400 font-sans">Logs delivery state & purges on ACK</span>
              </div>
            </div>

            {/* Conceptual Packet JSON Schema Display */}
            <div className="p-4 rounded-xl bg-[#090d16] border border-slate-800 text-xs font-mono">
              <div className="text-slate-500 mb-2">// Conceptual Mesh Distress PDU Schema (Under 255 bytes BLE limit):</div>
              <pre className="text-slate-300 overflow-x-auto leading-relaxed">
{`{
  "message_id": "${sosMessage?.id || 'SOS-PKT-884291'}",
  "origin_id": "DEVICE-A-F4B85E",
  "current_node": "${meshNodes[currentHopIndex]?.id || 'NODE-A'}",
  "hop_count": ${currentHopIndex},
  "ttl": ${sosMessage?.ttl || 300},
  "timestamp": "${sosMessage?.timestamp || '22:47:03'}",
  "payload": "${sosMessage?.encryptedPayload.slice(0, 45) || 'AES-GCM-256:7f90e1c28834a9b...'}...",
  "signature": "${sosMessage?.signature || 'ED25519-SIG:9b20e184...'}"
}`}
              </pre>
            </div>

          </div>
        )}

      </div>

      {/* Selected Node Deep-Dive Inspector */}
      <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-6 shadow-xl">
        <div className="flex items-center justify-between pb-4 border-b border-slate-800/80 mb-4">
          <div className="flex items-center gap-2">
            <Cpu className="w-4 h-4 text-cyan-400" />
            <h3 className="font-bold text-sm text-slate-200 tracking-wide uppercase font-mono">
              Node Inspector: {selectedNode.name}
            </h3>
          </div>
          <span className="text-xs font-mono text-cyan-300 px-2 py-0.5 rounded bg-cyan-950/60 border border-cyan-800">
            {selectedNode.protocol}
          </span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-xs font-mono">
          <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800">
            <span className="text-slate-500 block mb-1">NODE IDENTIFIER</span>
            <span className="text-slate-200 font-bold">{selectedNode.macOrId}</span>
          </div>

          <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800">
            <span className="text-slate-500 block mb-1">SIGNAL STRENGTH (RSSI)</span>
            <span className="text-emerald-400 font-bold">
              {selectedNode.signalStrengthDbm ? `${selectedNode.signalStrengthDbm} dBm` : 'Cloud Link (0ms)'}
            </span>
          </div>

          <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800">
            <span className="text-slate-500 block mb-1">PAYLOAD CACHE STATUS</span>
            <span className={`font-bold ${selectedNode.hasPayload ? 'text-emerald-400' : 'text-slate-400'}`}>
              {selectedNode.hasPayload ? 'CACHED & FORWARDED' : 'AWAITING HOP'}
            </span>
          </div>
        </div>

        <div className="mt-4 p-3 rounded-xl bg-slate-900/60 border border-slate-800 text-xs text-slate-300 leading-relaxed font-sans">
          <strong>Proposed Physical Stack:</strong> In an Android deployment, Node A uses <code className="text-cyan-400">BluetoothLeAdvertiser</code> in non-connectable mode. Node B detects the advertising PDU via passive BLE scanner without pairing. Node C with active cellular connectivity uploads the byte array to the HTTPS dispatch gateway.
        </div>
      </div>

    </div>
  );
};
