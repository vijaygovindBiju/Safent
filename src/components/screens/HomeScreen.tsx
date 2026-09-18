import React from 'react';
import { 
  ShieldCheck, 
  Radio, 
  WifiOff, 
  Users, 
  ArrowRight, 
  Play, 
  Activity, 
  ChevronRight, 
  AlertTriangle,
  Lock,
  Cpu,
  Layers,
  Shield,
  EyeOff,
  Clock
} from 'lucide-react';
import { useSafety } from '../../context/SafetyContext';

export const HomeScreen: React.FC = () => {
  const { 
    setScreen, 
    journey, 
    networkStatus, 
    toggleNetwork, 
    runFullDemo, 
    isDemoRunning,
    incident
  } = useSafety();

  return (
    <div className="max-w-6xl mx-auto space-y-8 py-6 px-4 sm:px-6">
      
      {/* Hero Mission Section */}
      <div className="relative overflow-hidden rounded-3xl bg-[#0f1422] border border-slate-800 p-6 md:p-10 shadow-2xl">
        
        {/* Subtle background glow */}
        <div className="absolute -right-20 -bottom-20 w-96 h-96 rounded-full bg-indigo-500/5 blur-3xl pointer-events-none" />

        <div className="max-w-3xl space-y-5 relative z-10">
          
          <div className="flex flex-wrap items-center gap-2">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-900 border border-slate-700 text-xs font-mono text-slate-300">
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
              <span>Late-Night Journey Safety Companion • SC-03</span>
            </div>
            <span className="text-[11px] font-mono px-2.5 py-1 rounded-full bg-indigo-950/80 text-indigo-300 border border-indigo-800">
              Simulated Architecture Prototype
            </span>
          </div>

          <h1 className="text-3xl sm:text-5xl font-black tracking-tight text-white leading-tight">
            Travel SOS Mesh
          </h1>

          <p className="text-xl sm:text-2xl font-bold text-slate-200 tracking-tight">
            "Safety that works beyond the network."
          </p>

          {/* 5-second core explainer callout */}
          <div className="p-4 rounded-2xl bg-[#090d16] border border-slate-700/80 text-slate-300 text-sm leading-relaxed space-y-1">
            <p className="font-semibold text-white">
              The Problem & The Innovation:
            </p>
            <p className="text-slate-400 text-xs sm:text-sm">
              If your phone loses Internet connectivity in late-night transit shadow zones, nearby participating devices can autonomously relay an emergency message toward an Internet-connected gateway.
            </p>
          </div>

          {/* Action CTAs */}
          <div className="flex flex-wrap items-center gap-3 pt-2">
            {/* Primary CTA */}
            <button
              onClick={() => setScreen('SETUP')}
              className="flex items-center gap-2 px-6 py-3.5 rounded-xl bg-white text-slate-950 hover:bg-slate-200 font-bold text-sm transition-all shadow-lg hover:shadow-white/10 active:scale-95"
            >
              <span>START JOURNEY</span>
              <ArrowRight className="w-4 h-4" />
            </button>

            {/* Secondary CTA */}
            <button
              onClick={runFullDemo}
              disabled={isDemoRunning}
              className="flex items-center gap-2 px-6 py-3.5 rounded-xl bg-gradient-to-r from-red-600 to-amber-600 hover:from-red-500 hover:to-amber-500 text-white font-bold text-sm shadow-xl shadow-red-950/40 transition-all active:scale-95 disabled:opacity-50"
            >
              <Play className="w-4 h-4 fill-current" />
              <span>{isDemoRunning ? 'RUNNING 50s DEMO...' : 'RUN FULL SOS DEMO (50s)'}</span>
            </button>

            <button
              onClick={() => setScreen('RESPONDER')}
              className="flex items-center gap-2 px-4 py-3.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-300 font-semibold text-xs border border-slate-700 transition-all"
            >
              <span>Response Center View</span>
              <ChevronRight className="w-4 h-4 text-slate-500" />
            </button>
          </div>
        </div>

        {/* Conceptual Mesh Pipe Overview */}
        <div className="mt-8 pt-6 border-t border-slate-800 grid grid-cols-1 md:grid-cols-5 gap-3 text-xs font-mono">
          <div className="bg-[#090d16] p-3 rounded-xl border border-slate-800">
            <span className="text-slate-500 block text-[10px]">HOP 0</span>
            <span className="text-slate-200 font-bold">Traveller Phone A</span>
            <span className="text-red-400 block text-[10px] mt-0.5 font-sans">NO INTERNET</span>
          </div>
          <div className="flex items-center justify-center text-slate-600 font-sans text-[11px]">→ BLE 5.2 Mesh →</div>
          <div className="bg-[#090d16] p-3 rounded-xl border border-slate-800">
            <span className="text-slate-500 block text-[10px]">HOP 1</span>
            <span className="text-slate-200 font-bold">Relay Phone B</span>
            <span className="text-amber-400 block text-[10px] mt-0.5 font-sans">Nearby Commuter</span>
          </div>
          <div className="flex items-center justify-center text-slate-600 font-sans text-[11px]">→ Wi-Fi Aware →</div>
          <div className="bg-[#090d16] p-3 rounded-xl border border-slate-800">
            <span className="text-slate-500 block text-[10px]">HOP 2</span>
            <span className="text-slate-200 font-bold">Gateway Phone C</span>
            <span className="text-emerald-400 block text-[10px] mt-0.5 font-sans">Active 5G Cellular</span>
          </div>
        </div>

      </div>

      {/* 4 Core Status Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        
        {/* Card 1: Journey Status */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 shadow-lg relative flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between text-slate-400 mb-3">
              <span className="text-xs uppercase font-bold tracking-wider">Journey Status</span>
              <Activity className="w-4 h-4 text-emerald-400" />
            </div>
            <div className="text-xl font-bold text-white mb-1">
              {journey.status === 'ACTIVE' ? 'Active & Monitored' : journey.status === 'SOS_TRIGGERED' ? 'SOS Dispatched' : 'Ready to Start'}
            </div>
            <p className="text-xs text-slate-400 font-mono">
              Dest: {journey.destination}
            </p>
          </div>
          <div className="mt-4 pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs">
            <span className="text-slate-500">Route State</span>
            <span className={`font-semibold ${journey.status === 'ACTIVE' ? 'text-emerald-400' : 'text-slate-300'}`}>
              {journey.status}
            </span>
          </div>
        </div>

        {/* Card 2: Network Status */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 shadow-lg relative flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between text-slate-400 mb-3">
              <span className="text-xs uppercase font-bold tracking-wider">Network Status</span>
              <WifiOff className="w-4 h-4 text-amber-400" />
            </div>
            <div className="text-xl font-bold text-white mb-1 flex items-center gap-2">
              <span className={`w-2.5 h-2.5 rounded-full ${networkStatus === 'ONLINE' ? 'bg-emerald-400' : 'bg-amber-400 animate-pulse'}`} />
              {networkStatus === 'ONLINE' ? 'Online (4G/5G)' : 'Offline (Mesh Mode)'}
            </div>
            <p className="text-xs text-slate-400">
              {networkStatus === 'ONLINE' ? 'Direct cloud dispatch enabled' : 'Zero-cellular shadow zone'}
            </p>
          </div>
          <div className="mt-4 pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs">
            <span className="text-slate-500">Peer Protocol</span>
            <button 
              onClick={toggleNetwork}
              className="text-amber-400 hover:text-amber-300 font-mono font-semibold underline underline-offset-2"
            >
              Toggle Network
            </button>
          </div>
        </div>

        {/* Card 3: Safety Monitoring */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 shadow-lg relative flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between text-slate-400 mb-3">
              <span className="text-xs uppercase font-bold tracking-wider">Safety Monitoring</span>
              <ShieldCheck className="w-4 h-4 text-cyan-400" />
            </div>
            <div className="text-xl font-bold text-white mb-1">
              Tri-Sensor Active
            </div>
            <p className="text-xs text-slate-400">
              Audio + IMU Impact + GPS Context
            </p>
          </div>
          <div className="mt-4 pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs">
            <span className="text-slate-500">False-Positive Guard</span>
            <span className="text-cyan-400 font-semibold font-mono">10s Challenge</span>
          </div>
        </div>

        {/* Card 4: Nearby Relay Devices */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 shadow-lg relative flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between text-slate-400 mb-3">
              <span className="text-xs uppercase font-bold tracking-wider">Nearby Relay Devices</span>
              <Users className="w-4 h-4 text-indigo-400" />
            </div>
            <div className="text-xl font-bold text-white mb-1">
              2 Participating Peers
            </div>
            <p className="text-xs text-slate-400">
              BLE 5.2 / Wi-Fi Aware vicinity
            </p>
          </div>
          <div className="mt-4 pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs">
            <span className="text-slate-500">Internet Gateway</span>
            <span className="text-emerald-400 font-semibold font-mono">1 Gateway Online</span>
          </div>
        </div>

      </div>

      {/* Privacy & Ethical Safeguards Overview (Phase 16) */}
      <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
        <div className="flex items-center gap-2 pb-3 border-b border-slate-800">
          <Shield className="w-4 h-4 text-cyan-400" />
          <h2 className="text-sm font-bold text-slate-200 uppercase font-mono tracking-wide">
            Privacy & Trust Architecture
          </h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-xs text-slate-300">
          <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800 space-y-1">
            <div className="flex items-center gap-1.5 text-slate-200 font-semibold mb-1">
              <EyeOff className="w-3.5 h-3.5 text-cyan-400" />
              <span>Zero Raw Audio Uploading</span>
            </div>
            <p className="text-slate-400 leading-relaxed">
              Acoustic monitoring runs locally on-device. Audio is converted to mathematical RMS features and never recorded, saved, or uploaded to servers.
            </p>
          </div>

          <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800 space-y-1">
            <div className="flex items-center gap-1.5 text-slate-200 font-semibold mb-1">
              <Lock className="w-3.5 h-3.5 text-indigo-400" />
              <span>Zero-Knowledge Relay</span>
            </div>
            <p className="text-slate-400 leading-relaxed">
              Participating relay phones carry encrypted packet envelopes. Relaying commuters cannot inspect your identity, contacts, or GPS location.
            </p>
          </div>

          <div className="p-3 rounded-xl bg-[#090d16] border border-slate-800 space-y-1">
            <div className="flex items-center gap-1.5 text-slate-200 font-semibold mb-1">
              <Clock className="w-3.5 h-3.5 text-amber-400" />
              <span>Automatic Packet Expiry (TTL)</span>
            </div>
            <p className="text-slate-400 leading-relaxed">
              Distress beacons carry a strict Time-To-Live (300 seconds). Once delivered or expired, relay caches purge all cached records automatically.
            </p>
          </div>
        </div>
      </div>

    </div>
  );
};
