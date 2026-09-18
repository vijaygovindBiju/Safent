import React, { useState, useRef, useEffect } from 'react';
import { 
  Radio, 
  Battery, 
  MapPin, 
  AlertTriangle, 
  ShieldAlert, 
  Volume2, 
  Activity, 
  Navigation, 
  Wifi, 
  WifiOff, 
  Flame,
  CheckCircle2,
  PhoneCall,
  RefreshCw,
  Clock,
  Users,
  Shield,
  Info
} from 'lucide-react';
import { useSafety } from '../../context/SafetyContext';
import { SimulatedMap } from '../common/SimulatedMap';

export const ActiveJourneyScreen: React.FC = () => {
  const { 
    journey, 
    networkStatus, 
    toggleNetwork, 
    sensorTelemetry, 
    simulateDanger, 
    triggerImmediateSOS,
    setScreen
  } = useSafety();

  // Hold-to-trigger SOS button state
  const [holdProgress, setHoldProgress] = useState<number>(0);
  const holdIntervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const startHold = () => {
    if (holdIntervalRef.current) clearInterval(holdIntervalRef.current);
    holdIntervalRef.current = setInterval(() => {
      setHoldProgress((prev) => {
        if (prev >= 100) {
          clearInterval(holdIntervalRef.current!);
          triggerImmediateSOS();
          return 100;
        }
        return prev + 5; // Reaches 100 in ~1.5s
      });
    }, 75);
  };

  const endHold = () => {
    if (holdIntervalRef.current) {
      clearInterval(holdIntervalRef.current);
      holdIntervalRef.current = null;
    }
    setHoldProgress(0);
  };

  useEffect(() => {
    return () => {
      if (holdIntervalRef.current) clearInterval(holdIntervalRef.current);
    };
  }, []);

  const formatDuration = (totalSeconds: number) => {
    const hrs = Math.floor(totalSeconds / 3600);
    const mins = Math.floor((totalSeconds % 3600) / 60);
    const secs = totalSeconds % 60;
    return `${String(hrs).padStart(2, '0')}:${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
  };

  return (
    <div className="max-w-6xl mx-auto py-6 px-4 sm:px-6 space-y-6">
      
      {/* Top Telemetry Header Bar */}
      <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 shadow-xl flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        
        {/* Journey Identity & Status */}
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded-2xl bg-gradient-to-br from-emerald-600 to-teal-700 flex items-center justify-center text-white shadow-lg shadow-emerald-950/40">
            <Radio className="w-6 h-6 animate-pulse" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="text-xs font-mono font-bold px-2 py-0.5 rounded bg-emerald-950/80 text-emerald-400 border border-emerald-800/80">
                LIVE JOURNEY
              </span>
              <span className="text-xs text-slate-400 font-mono">
                {journey.id}
              </span>
            </div>
            <h2 className="text-xl font-bold text-white tracking-tight mt-0.5">
              Target: {journey.destination}
            </h2>
          </div>
        </div>

        {/* Telemetry Pills */}
        <div className="flex flex-wrap items-center gap-2.5 text-xs font-mono">
          
          {/* Duration Ticker */}
          <div className="px-3 py-1.5 rounded-xl bg-slate-900 border border-slate-800 text-slate-300 flex items-center gap-1.5">
            <Clock className="w-3.5 h-3.5 text-cyan-400" />
            <span className="text-slate-500">Duration:</span>
            <span className="text-white font-bold">{formatDuration(journey.elapsedSeconds)}</span>
          </div>

          {/* Network Switcher Pill */}
          <button
            onClick={toggleNetwork}
            title="Click to toggle between Online cellular and Offline mesh-only mode"
            className={`px-3 py-1.5 rounded-xl border flex items-center gap-1.5 transition-all hover:scale-105 active:scale-95 ${
              networkStatus === 'ONLINE'
                ? 'bg-emerald-950/60 text-emerald-300 border-emerald-700'
                : 'bg-amber-950/60 text-amber-300 border-amber-700'
            }`}
          >
            {networkStatus === 'ONLINE' ? <Wifi className="w-3.5 h-3.5" /> : <WifiOff className="w-3.5 h-3.5 text-amber-400" />}
            <span>Network: {networkStatus}</span>
          </button>

          {/* Nearby Relay Devices Pill */}
          <div className="px-3 py-1.5 rounded-xl bg-slate-900 border border-slate-800 text-slate-300 flex items-center gap-1.5">
            <Users className="w-3.5 h-3.5 text-indigo-400" />
            <span>{journey.nearbyRelayCount} Mesh Peers</span>
          </div>

          {/* Battery */}
          <div className="px-3 py-1.5 rounded-xl bg-slate-900 border border-slate-800 text-slate-300 flex items-center gap-1.5">
            <Battery className="w-3.5 h-3.5 text-emerald-400" />
            <span>{journey.battery}%</span>
          </div>

        </div>

      </div>

      {/* Prominent Offline / Mesh Callout (Phase 5 Requirement) */}
      {networkStatus === 'OFFLINE' ? (
        <div className="p-4 rounded-2xl bg-amber-950/40 border border-amber-800/80 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 text-xs font-mono">
          <div className="flex items-center gap-2.5">
            <WifiOff className="w-4 h-4 text-amber-400 shrink-0" />
            <div>
              <span className="text-amber-300 font-bold block">
                INTERNET UNAVAILABLE — MESH RELAY ACTIVE
              </span>
              <span className="text-slate-400 text-[11px]">
                Device is operating in late-night shadow mode. Peer discovery broadcasting via BLE 5.2.
              </span>
            </div>
          </div>
          <span className="text-indigo-400 bg-indigo-950/80 px-2.5 py-1 rounded-lg border border-indigo-800 text-[11px] whitespace-nowrap">
            ● 2 Nearby Peers in Range (35m)
          </span>
        </div>
      ) : (
        <div className="p-4 rounded-2xl bg-emerald-950/40 border border-emerald-800/80 flex items-center justify-between gap-3 text-xs font-mono">
          <div className="flex items-center gap-2.5">
            <Wifi className="w-4 h-4 text-emerald-400 shrink-0" />
            <span className="text-emerald-300 font-bold">
              CELLULAR DATA ACTIVE (5G) — Direct cloud ingestion active
            </span>
          </div>
          <button 
            onClick={toggleNetwork}
            className="text-amber-400 underline underline-offset-2 hover:text-amber-300 text-[11px]"
          >
            Simulate Entering Shadow Zone (Go Offline)
          </button>
        </div>
      )}

      {/* Main Grid: Map on Left / Controls on Right */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Left 2 Cols: Tactical Journey Map */}
        <div className="lg:col-span-2 space-y-4">
          <SimulatedMap
            location={journey.location}
            networkStatus={networkStatus}
            destination={journey.destination}
          />

          {/* Tri-Sensor Monitoring Indicators */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            
            {/* Sensor 1: Audio */}
            <div className="bg-[#0f1422] border border-slate-800 rounded-xl p-3.5 shadow-md flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-lg bg-cyan-950/60 border border-cyan-800/80 flex items-center justify-center text-cyan-400">
                  <Volume2 className="w-4 h-4" />
                </div>
                <div>
                  <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400 block">
                    ● Audio Monitoring
                  </span>
                  <span className="text-xs font-mono text-cyan-300 font-semibold">
                    {sensorTelemetry.ambientDecibels} dB Ambient
                  </span>
                </div>
              </div>
              <span className="w-2 h-2 rounded-full bg-cyan-400 animate-pulse" />
            </div>

            {/* Sensor 2: Motion / IMU */}
            <div className="bg-[#0f1422] border border-slate-800 rounded-xl p-3.5 shadow-md flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-lg bg-indigo-950/60 border border-indigo-800/80 flex items-center justify-center text-indigo-400">
                  <Activity className="w-4 h-4" />
                </div>
                <div>
                  <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400 block">
                    ● Motion Monitoring
                  </span>
                  <span className="text-xs font-mono text-indigo-300 font-semibold">
                    {sensorTelemetry.accelerometerG}G / {sensorTelemetry.gyroscopeDps}°/s
                  </span>
                </div>
              </div>
              <span className="w-2 h-2 rounded-full bg-indigo-400 animate-pulse" />
            </div>

            {/* Sensor 3: Location Anomaly */}
            <div className="bg-[#0f1422] border border-slate-800 rounded-xl p-3.5 shadow-md flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-lg bg-emerald-950/60 border border-emerald-800/80 flex items-center justify-center text-emerald-400">
                  <Navigation className="w-4 h-4" />
                </div>
                <div>
                  <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400 block">
                    ● Location Monitoring
                  </span>
                  <span className="text-xs font-mono text-emerald-300 font-semibold">
                    GPS Fix Locked (12 Sats)
                  </span>
                </div>
              </div>
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
            </div>

          </div>

          <div className="text-[11px] text-slate-500 font-mono text-right">
            * Telemetry metrics dynamically simulated for prototype demonstration.
          </div>
        </div>

        {/* Right 1 Col: Emergency Actions & Safety Controls */}
        <div className="space-y-4 flex flex-col justify-between">
          
          {/* Action 1: HOLD FOR SOS Primary Emergency Button */}
          <div className="bg-[#0f1422] border border-red-900/40 rounded-2xl p-5 shadow-xl relative overflow-hidden flex flex-col items-center text-center space-y-4">
            
            <div className="w-full flex items-center justify-between text-xs font-mono text-slate-400 border-b border-slate-800/80 pb-2">
              <span className="flex items-center gap-1 text-red-400 font-bold">
                <ShieldAlert className="w-3.5 h-3.5" />
                EMERGENCY TRIGGER
              </span>
              <span>HOLD 1.5s</span>
            </div>

            {/* Radial Hold Button */}
            <div className="relative my-2">
              <svg className="w-36 h-36 -rotate-90">
                <circle
                  cx="72"
                  cy="72"
                  r="62"
                  stroke="#1e293b"
                  strokeWidth="8"
                  fill="transparent"
                />
                <circle
                  cx="72"
                  cy="72"
                  r="62"
                  stroke="#ef4444"
                  strokeWidth="8"
                  fill="transparent"
                  strokeDasharray={389.5}
                  strokeDashoffset={389.5 - (389.5 * holdProgress) / 100}
                  strokeLinecap="round"
                  className="transition-all duration-75 ease-linear"
                />
              </svg>

              <button
                onMouseDown={startHold}
                onMouseUp={endHold}
                onMouseLeave={endHold}
                onTouchStart={startHold}
                onTouchEnd={endHold}
                onClick={() => {
                  if (holdProgress === 0) triggerImmediateSOS();
                }}
                className="absolute inset-2 m-auto w-28 h-28 rounded-full bg-gradient-to-br from-red-600 to-rose-800 hover:from-red-500 hover:to-rose-700 active:scale-95 shadow-2xl shadow-red-900/60 flex flex-col items-center justify-center text-white select-none transition-all group focus:outline-none"
              >
                <ShieldAlert className="w-8 h-8 mb-1 group-hover:scale-110 transition-transform" />
                <span className="font-black text-xs tracking-wider">HOLD FOR</span>
                <span className="font-extrabold text-sm tracking-widest text-red-100">SOS</span>
              </button>
            </div>

            <p className="text-xs text-slate-400 leading-relaxed px-2">
              Press and hold for 1.5s or click to trigger immediate encrypted mesh SOS dispatch.
            </p>
          </div>

          {/* Action 2: Simulate Dangerous Event */}
          <div className="bg-[#0f1422] border border-amber-900/40 rounded-2xl p-5 shadow-xl space-y-3">
            <div className="flex items-center gap-2 text-amber-400 text-xs font-mono font-bold uppercase">
              <Flame className="w-4 h-4" />
              <span>Simulate Incident</span>
            </div>

            <p className="text-xs text-slate-300 leading-relaxed">
              Simulate sudden vehicle deceleration (4.8G) combined with scream acoustic spike in late-night context.
            </p>

            <button
              onClick={simulateDanger}
              className="w-full flex items-center justify-center gap-2 py-3 px-4 rounded-xl bg-gradient-to-r from-amber-600 to-orange-600 hover:from-amber-500 hover:to-orange-500 text-white font-bold text-xs uppercase tracking-wider shadow-lg shadow-amber-950/40 transition-all active:scale-95"
            >
              <AlertTriangle className="w-4 h-4" />
              <span>Simulate Dangerous Event</span>
            </button>
          </div>

          {/* Trusted Contact Mini Card */}
          <div className="bg-[#0f1422] border border-slate-800 rounded-xl p-3.5 text-xs flex items-center justify-between text-slate-300">
            <div className="flex items-center gap-2">
              <PhoneCall className="w-4 h-4 text-emerald-400" />
              <div>
                <span className="text-[10px] text-slate-500 block uppercase font-mono">Trusted Contact</span>
                <span className="font-semibold text-slate-200">{journey.trustedContact.name}</span>
              </div>
            </div>
            <span className="text-[10px] font-mono text-slate-400 bg-slate-900 px-2 py-1 rounded border border-slate-800">
              {journey.trustedContact.phone}
            </span>
          </div>

        </div>

      </div>

    </div>
  );
};
