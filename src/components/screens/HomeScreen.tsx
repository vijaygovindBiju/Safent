import React from 'react';
import { 
  ShieldCheck, 
  Radio, 
  WifiOff, 
  Users, 
  ArrowRight, 
  Play, 
  Layers, 
  Activity, 
  ChevronRight, 
  AlertTriangle,
  Lock,
  Cpu,
  MapPin
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
      <div className="relative overflow-hidden rounded-3xl bg-gradient-to-b from-[#111726] to-[#0d121f] border border-slate-800 p-6 md:p-10 shadow-2xl">
        
        {/* Subtle background mesh line decoration */}
        <div className="absolute -right-16 -bottom-16 w-80 h-80 rounded-full bg-indigo-500/5 blur-3xl pointer-events-none" />
        <div className="absolute -left-16 -top-16 w-80 h-80 rounded-full bg-red-500/5 blur-3xl pointer-events-none" />

        <div className="max-w-3xl space-y-5 relative z-10">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-800/90 border border-slate-700 text-xs font-mono text-slate-300">
            <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
            <span>Late-Night Journey Safety Protocol • SC-03</span>
          </div>

          <h1 className="text-3xl sm:text-5xl font-black tracking-tight text-white leading-[1.15]">
            Travel SOS Mesh
          </h1>

          <p className="text-lg sm:text-xl font-medium text-slate-300 leading-relaxed">
            "Your journey. Your safety. <span className="text-amber-400 font-bold underline decoration-amber-500/50 underline-offset-4">Even without a network.</span>"
          </p>

          <p className="text-sm sm:text-base text-slate-400 max-w-2xl leading-relaxed">
            When you enter zero-connectivity shadow zones late at night, your phone turns into an autonomous safety beacon. In emergencies, your SOS hops peer-to-peer across nearby participating phones until it reaches an internet-connected gateway.
          </p>

          {/* Action CTAs */}
          <div className="flex flex-wrap items-center gap-3 pt-2">
            <button
              onClick={() => setScreen('SETUP')}
              className="flex items-center gap-2 px-6 py-3 rounded-xl bg-white text-slate-950 hover:bg-slate-200 font-bold text-sm transition-all shadow-lg hover:shadow-white/10 active:scale-95"
            >
              <span>Start Journey</span>
              <ArrowRight className="w-4 h-4" />
            </button>

            <button
              onClick={runFullDemo}
              disabled={isDemoRunning}
              className="flex items-center gap-2 px-6 py-3 rounded-xl bg-slate-800/90 hover:bg-slate-700/90 text-white font-semibold text-sm border border-slate-700 transition-all active:scale-95"
            >
              <Play className="w-4 h-4 text-amber-400 fill-amber-400" />
              <span>{isDemoRunning ? 'Running Demo...' : 'Try Interactive Demo (60s)'}</span>
            </button>

            <button
              onClick={() => setScreen('RESPONDER')}
              className="flex items-center gap-2 px-4 py-3 rounded-xl bg-slate-900/60 hover:bg-slate-800/60 text-slate-300 font-medium text-sm border border-slate-800 transition-all"
            >
              <span>View Response Center</span>
              <ChevronRight className="w-4 h-4 text-slate-500" />
            </button>
          </div>
        </div>

        {/* Live Architectural Concept Banner */}
        <div className="mt-8 pt-6 border-t border-slate-800/80 grid grid-cols-1 md:grid-cols-5 gap-3 text-xs font-mono">
          <div className="bg-[#090d16] p-3 rounded-xl border border-slate-800">
            <span className="text-slate-500 block mb-1">HOP 0</span>
            <span className="text-slate-200 font-bold">Traveller Phone A</span>
            <span className="text-red-400 block text-[10px] mt-0.5 font-sans">NO INTERNET</span>
          </div>
          <div className="flex items-center justify-center text-slate-600">→ BLE 5.2 Mesh →</div>
          <div className="bg-[#090d16] p-3 rounded-xl border border-slate-800">
            <span className="text-slate-500 block mb-1">HOP 1</span>
            <span className="text-slate-200 font-bold">Relay Phone B</span>
            <span className="text-amber-400 block text-[10px] mt-0.5 font-sans">Nearby Commuter</span>
          </div>
          <div className="flex items-center justify-center text-slate-600">→ Wi-Fi Aware →</div>
          <div className="bg-[#090d16] p-3 rounded-xl border border-slate-800">
            <span className="text-slate-500 block mb-1">HOP 2</span>
            <span className="text-slate-200 font-bold">Gateway Phone C</span>
            <span className="text-emerald-400 block text-[10px] mt-0.5 font-sans">Active 5G Cellular</span>
          </div>
        </div>

      </div>

      {/* 4 Core Status Cards (Requested in spec) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        
        {/* Card 1: Journey Status */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 shadow-lg relative flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between text-slate-400 mb-3">
              <span className="text-xs uppercase font-bold tracking-wider">Journey Status</span>
              <Activity className="w-4 h-4 text-emerald-400" />
            </div>
            <div className="text-xl font-bold text-white mb-1">
              {journey.status === 'ACTIVE' ? 'Live & Monitored' : journey.status === 'SOS_TRIGGERED' ? 'SOS Dispatched' : 'Ready to Start'}
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
              {networkStatus === 'ONLINE' ? 'Online LTE/5G' : 'Offline (Mesh Mode)'}
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
              Active Tri-Sensor
            </div>
            <p className="text-xs text-slate-400">
              Audio + IMU Impact + GPS Context
            </p>
          </div>
          <div className="mt-4 pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs">
            <span className="text-slate-500">False-Positive Guard</span>
            <span className="text-cyan-400 font-semibold font-mono">10s Verify</span>
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
              2 Mesh Peers
            </div>
            <p className="text-xs text-slate-400">
              BLE 5.2 / Wi-Fi Direct vicinity
            </p>
          </div>
          <div className="mt-4 pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs">
            <span className="text-slate-500">Internet Gateway</span>
            <span className="text-emerald-400 font-semibold font-mono">1 Peer Online</span>
          </div>
        </div>

      </div>

      {/* Differentiator & Technical Architecture Overview */}
      <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-6 shadow-xl">
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mb-6">
          <div>
            <h2 className="text-lg font-bold text-white tracking-tight">
              How Travel SOS Mesh Solves Late-Night Transit Blackouts
            </h2>
            <p className="text-xs text-slate-400 mt-1">
              Traditional safety apps fail the moment you enter an underground tunnel, rural stretch, or cellar shadow zone.
            </p>
          </div>
          <button
            onClick={() => setScreen('MESH_RELAY')}
            className="flex items-center gap-2 px-3.5 py-2 rounded-xl bg-indigo-950/60 hover:bg-indigo-900/60 text-indigo-300 border border-indigo-700/80 text-xs font-semibold"
          >
            <span>Interactive Mesh Sandbox</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          
          <div className="p-4 rounded-xl bg-[#0a0d16] border border-slate-800 space-y-2">
            <div className="w-8 h-8 rounded-lg bg-red-950/80 border border-red-800/80 flex items-center justify-center text-red-400">
              <AlertTriangle className="w-4 h-4" />
            </div>
            <h3 className="font-bold text-sm text-slate-100">1. On-Device Risk Fusion</h3>
            <p className="text-xs text-slate-400 leading-relaxed">
              No server connection needed. Audio screams, sudden vehicle deceleration (4G+ impact), and gyroscopic flips are fused locally on-device into a 0–100 risk index.
            </p>
          </div>

          <div className="p-4 rounded-xl bg-[#0a0d16] border border-slate-800 space-y-2">
            <div className="w-8 h-8 rounded-lg bg-amber-950/80 border border-amber-800/80 flex items-center justify-center text-amber-400">
              <ShieldCheck className="w-4 h-4" />
            </div>
            <h3 className="font-bold text-sm text-slate-100">2. 10-Second Safety Confirmation</h3>
            <p className="text-xs text-slate-400 leading-relaxed">
              Eliminates false alarms from dropped phones. If the user is responsive, a single tap aborts the alert. If unresponsive, emergency SOS triggers automatically.
            </p>
          </div>

          <div className="p-4 rounded-xl bg-[#0a0d16] border border-slate-800 space-y-2">
            <div className="w-8 h-8 rounded-lg bg-indigo-950/80 border border-indigo-800/80 flex items-center justify-center text-indigo-400">
              <Radio className="w-4 h-4" />
            </div>
            <h3 className="font-bold text-sm text-slate-100">3. Multi-Hop Mesh Relay</h3>
            <p className="text-xs text-slate-400 leading-relaxed">
              SOS packets propagate via BLE 5.2 advertisements and Wi-Fi Direct. Relaying devices forward encrypted packets without ever seeing private personal data.
            </p>
          </div>

        </div>
      </div>

    </div>
  );
};
