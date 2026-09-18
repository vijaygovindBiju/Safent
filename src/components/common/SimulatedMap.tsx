import React from 'react';
import { Compass, Navigation, Radio, Shield, Wifi, WifiOff } from 'lucide-react';
import { LocationCoordinates, NetworkStatus } from '../../types';

interface SimulatedMapProps {
  location: LocationCoordinates;
  networkStatus: NetworkStatus;
  isEmergencyActive?: boolean;
  destination: string;
}

export const SimulatedMap: React.FC<SimulatedMapProps> = ({
  location,
  networkStatus,
  isEmergencyActive = false,
  destination
}) => {
  return (
    <div className="relative w-full h-[320px] md:h-[380px] bg-[#090d16] rounded-2xl overflow-hidden border border-slate-800 shadow-2xl flex flex-col justify-between p-4 select-none">
      
      {/* Background Cartographic Grid with Road Network SVG */}
      <svg className="absolute inset-0 w-full h-full pointer-events-none opacity-40" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <pattern id="tacticalGrid" width="40" height="40" patternUnits="userSpaceOnUse">
            <path d="M 40 0 L 0 0 0 40" fill="none" stroke="#1e293b" strokeWidth="0.75" />
            <circle cx="40" cy="40" r="1" fill="#334155" />
          </pattern>
          <radialGradient id="beaconPulse" cx="50%" cy="50%" r="50%">
            <stop offset="0%" stopColor={isEmergencyActive ? "#ef4444" : "#38bdf8"} stopOpacity="0.4" />
            <stop offset="100%" stopColor={isEmergencyActive ? "#ef4444" : "#38bdf8"} stopOpacity="0" />
          </radialGradient>
        </defs>

        {/* Grid pattern */}
        <rect width="100%" height="100%" fill="url(#tacticalGrid)" />

        {/* Simulated Road Arteries (Kochi Transit Lines) */}
        {/* Coastal Highway */}
        <path d="M -20 280 C 120 260, 240 310, 480 270 C 680 240, 850 300, 1100 250" fill="none" stroke="#334155" strokeWidth="12" strokeLinecap="round" opacity="0.6" />
        <path d="M -20 280 C 120 260, 240 310, 480 270 C 680 240, 850 300, 1100 250" fill="none" stroke="#475569" strokeWidth="2" strokeDasharray="6,6" opacity="0.8" />

        {/* MG Road Main Metro Corridor */}
        <path d="M 80 -20 C 140 120, 280 180, 520 210 C 720 230, 880 180, 1020 380" fill="none" stroke="#1e293b" strokeWidth="16" strokeLinecap="round" />
        <path d="M 80 -20 C 140 120, 280 180, 520 210 C 720 230, 880 180, 1020 380" fill="none" stroke="#0ea5e9" strokeWidth="3" opacity="0.4" />

        {/* Active Journey Route Path */}
        <path d="M 160 310 C 260 250, 420 220, 500 190" fill="none" stroke={isEmergencyActive ? "#ef4444" : "#10b981"} strokeWidth="5" strokeLinecap="round" strokeDasharray="8 4" className="mesh-path-active" />

        {/* BLE Mesh Range Beacon rings around Traveller */}
        <circle cx="500" cy="190" r="85" fill="url(#beaconPulse)" />
        <circle cx="500" cy="190" r="140" fill="none" stroke={isEmergencyActive ? "#ef4444" : "#6366f1"} strokeWidth="1" strokeDasharray="4 4" className="animate-ping-slow opacity-60" />
        <circle cx="500" cy="190" r="85" fill="none" stroke={isEmergencyActive ? "#ef4444" : "#38bdf8"} strokeWidth="1.5" opacity="0.7" />

        {/* Mesh connection vector lines to nearby simulated phones */}
        <line x1="500" y1="190" x2="630" y2="150" stroke="#6366f1" strokeWidth="1.5" strokeDasharray="4 2" opacity="0.7" />
        <line x1="630" y1="150" x2="740" y2="230" stroke="#10b981" strokeWidth="1.5" strokeDasharray="4 2" opacity="0.5" />
      </svg>

      {/* Top Map Overlay Controls */}
      <div className="relative z-10 flex items-start justify-between gap-2">
        <div className="bg-[#0c121e]/90 backdrop-blur-md border border-slate-700/80 px-3.5 py-2 rounded-xl shadow-lg flex items-center gap-2.5">
          <div className={`w-3 h-3 rounded-full ${isEmergencyActive ? 'bg-red-500 animate-ping' : 'bg-emerald-400 animate-pulse'}`} />
          <div>
            <div className="text-[11px] uppercase tracking-wider text-slate-400 font-semibold flex items-center gap-1.5">
              <span>{location.landmark}</span>
            </div>
            <div className="text-xs font-mono font-medium text-slate-200">
              {location.latitude.toFixed(4)}° N, {location.longitude.toFixed(4)}° E • ±{location.accuracyMeters}m
            </div>
          </div>
        </div>

        <div className="flex items-center gap-2">
          {/* Compass & Satellites indicator */}
          <div className="bg-[#0c121e]/90 backdrop-blur-md border border-slate-700/80 px-3 py-1.5 rounded-xl shadow-lg flex items-center gap-2 text-xs font-mono text-slate-300">
            <Compass className="w-4 h-4 text-cyan-400 animate-spin-slow" />
            <span>38° NE</span>
            <span className="text-slate-600">|</span>
            <span className="text-emerald-400 font-semibold">12 Sats</span>
          </div>

          {/* Network Banner */}
          <div className={`px-3 py-1.5 rounded-xl border text-xs font-mono font-bold flex items-center gap-1.5 shadow-lg ${
            networkStatus === 'ONLINE'
              ? 'bg-emerald-950/80 text-emerald-300 border-emerald-700'
              : 'bg-amber-950/80 text-amber-300 border-amber-700'
          }`}>
            {networkStatus === 'ONLINE' ? <Wifi className="w-3.5 h-3.5" /> : <WifiOff className="w-3.5 h-3.5 text-amber-400" />}
            <span>{networkStatus === 'ONLINE' ? 'LTE/5G LIVE' : 'MESH ONLY (OFFLINE)'}</span>
          </div>
        </div>
      </div>

      {/* Center Dynamic Nodes on Map (SVG absolute positioned) */}
      <div className="absolute inset-0 pointer-events-none flex items-center justify-center">
        {/* Traveller Node Pin */}
        <div className="absolute left-[45%] top-[46%] -translate-x-1/2 -translate-y-1/2 flex flex-col items-center">
          <div className={`w-8 h-8 rounded-full border-2 flex items-center justify-center shadow-xl transition-all ${
            isEmergencyActive 
              ? 'bg-red-600 border-white text-white scale-125 emergency-glow'
              : 'bg-indigo-600 border-white text-white'
          }`}>
            {isEmergencyActive ? <Shield className="w-4 h-4 animate-bounce" /> : <Navigation className="w-4 h-4 rotate-45" />}
          </div>
          <div className="mt-1 px-2 py-0.5 rounded bg-black/85 border border-slate-700 text-[10px] font-mono text-white whitespace-nowrap shadow">
            Traveller A (You)
          </div>
        </div>

        {/* Nearby Mesh Relay Device B */}
        <div className="absolute left-[62%] top-[36%] -translate-x-1/2 -translate-y-1/2 flex flex-col items-center">
          <div className="w-6 h-6 rounded-full bg-slate-800 border border-indigo-400/80 text-indigo-300 flex items-center justify-center shadow-md">
            <Radio className="w-3 h-3" />
          </div>
          <div className="mt-1 px-1.5 py-0.5 rounded bg-slate-900/90 border border-slate-700 text-[9px] font-mono text-indigo-300 whitespace-nowrap">
            Relay B (~35m)
          </div>
        </div>

        {/* Gateway Device C */}
        <div className="absolute left-[76%] top-[56%] -translate-x-1/2 -translate-y-1/2 flex flex-col items-center">
          <div className="w-6 h-6 rounded-full bg-slate-800 border border-emerald-400/80 text-emerald-300 flex items-center justify-center shadow-md">
            <Wifi className="w-3 h-3" />
          </div>
          <div className="mt-1 px-1.5 py-0.5 rounded bg-slate-900/90 border border-slate-700 text-[9px] font-mono text-emerald-300 whitespace-nowrap">
            Gateway C (5G)
          </div>
        </div>
      </div>

      {/* Bottom Map Info Footer */}
      <div className="relative z-10 flex flex-wrap items-center justify-between gap-2 pt-2 border-t border-slate-800/80 bg-[#090d16]/90 backdrop-blur-sm -mx-4 -mb-4 p-3 px-4">
        <div className="flex items-center gap-4 text-xs font-mono">
          <div className="flex items-center gap-1.5">
            <span className="text-slate-500">Destination:</span>
            <span className="font-semibold text-slate-200">{destination}</span>
          </div>
          <div className="hidden sm:flex items-center gap-1.5">
            <span className="text-slate-500">Speed:</span>
            <span className="font-semibold text-slate-200">{location.speedKmh} km/h</span>
          </div>
          <div className="hidden md:flex items-center gap-1.5">
            <span className="text-slate-500">Mesh Radius:</span>
            <span className="text-indigo-400 font-semibold">50m BLE 5.2</span>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <span className="text-[11px] font-mono text-slate-400">
            {networkStatus === 'OFFLINE' ? '⚡ Store-and-Forward Mesh Engine Standby' : '● Connected to Cellular Edge'}
          </span>
        </div>
      </div>

    </div>
  );
};
