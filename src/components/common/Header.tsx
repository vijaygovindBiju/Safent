import React from 'react';
import { 
  ShieldAlert, 
  Wifi, 
  WifiOff, 
  Radio, 
  Battery, 
  Volume2, 
  VolumeX, 
  Play, 
  RotateCcw,
  Layers,
  MapPin,
  AlertOctagon,
  Network,
  LifeBuoy
} from 'lucide-react';
import { useSafety } from '../../context/SafetyContext';
import { ScreenState } from '../../types';

export const Header: React.FC = () => {
  const { 
    currentScreen, 
    setScreen, 
    networkStatus, 
    toggleNetwork, 
    journey, 
    runFullDemo, 
    isDemoRunning, 
    resetAll,
    isMuted,
    toggleMute,
    incident
  } = useSafety();

  const navItems: { id: ScreenState; label: string; icon: React.ReactNode; badge?: string }[] = [
    { id: 'HOME', label: 'Home', icon: <Layers className="w-4 h-4" /> },
    { id: 'SETUP', label: 'Setup', icon: <MapPin className="w-4 h-4" /> },
    { id: 'ACTIVE', label: 'Traveller', icon: <Radio className="w-4 h-4" />, badge: journey.status === 'ACTIVE' ? 'LIVE' : undefined },
    { id: 'DANGER', label: 'Danger Check', icon: <AlertOctagon className="w-4 h-4" />, badge: incident && incident.status === 'CONFIRMATION_PENDING' ? 'ALERT' : undefined },
    { id: 'SOS_ACTIVE', label: 'SOS Beacon', icon: <ShieldAlert className="w-4 h-4" />, badge: incident && incident.status.includes('SOS') ? 'EMERGENCY' : undefined },
    { id: 'MESH_RELAY', label: 'Mesh Relay', icon: <Network className="w-4 h-4" />, badge: 'HOP A→B→C' },
    { id: 'RESPONDER', label: 'Safety Response', icon: <LifeBuoy className="w-4 h-4" />, badge: incident && incident.status.includes('DELIVERED') ? 'NEW' : undefined }
  ];

  return (
    <header className="sticky top-0 z-50 bg-[#0c101a]/95 backdrop-blur-md border-b border-slate-800/80 px-4 lg:px-6 py-2.5 transition-all">
      <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-3">
        
        {/* Brand & Mission Statement */}
        <div className="flex items-center justify-between w-full md:w-auto gap-4">
          <button 
            onClick={() => setScreen('HOME')}
            className="flex items-center gap-2.5 text-left group focus:outline-none"
          >
            <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-red-600 to-rose-700 p-0.5 shadow-lg shadow-red-950/40 flex items-center justify-center group-hover:scale-105 transition-transform">
              <ShieldAlert className="w-5 h-5 text-white" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="font-extrabold text-base tracking-tight text-white group-hover:text-red-400 transition-colors">
                  Travel SOS Mesh
                </span>
                <span className="text-[10px] font-mono px-1.5 py-0.5 rounded bg-slate-800 text-slate-300 border border-slate-700">
                  MVP v1.0
                </span>
              </div>
              <p className="text-[11px] text-slate-400 font-medium hidden sm:block">
                Late-Night Journey Safety Companion • Team Maravazha
              </p>
            </div>
          </button>

          {/* Quick status bar on mobile */}
          <div className="flex md:hidden items-center gap-2">
            <button
              onClick={toggleNetwork}
              className={`text-xs px-2.5 py-1 rounded-full border font-mono flex items-center gap-1.5 transition-all ${
                networkStatus === 'ONLINE'
                  ? 'bg-emerald-950/60 text-emerald-400 border-emerald-800/80'
                  : 'bg-amber-950/60 text-amber-300 border-amber-800/80'
              }`}
            >
              {networkStatus === 'ONLINE' ? <Wifi className="w-3 h-3" /> : <WifiOff className="w-3 h-3 text-amber-400" />}
              {networkStatus}
            </button>
          </div>
        </div>

        {/* Screen Switcher Tabs */}
        <nav className="flex items-center gap-1 overflow-x-auto w-full md:w-auto pb-1 md:pb-0 scrollbar-none">
          {navItems.map((item) => {
            const isActive = currentScreen === item.id;
            return (
              <button
                key={item.id}
                onClick={() => setScreen(item.id)}
                className={`relative flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium whitespace-nowrap transition-all ${
                  isActive
                    ? 'bg-slate-800 text-white shadow-sm border border-slate-700 font-semibold'
                    : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900/60'
                }`}
              >
                {item.icon}
                <span>{item.label}</span>
                {item.badge && (
                  <span className={`text-[9px] px-1 py-0.2 rounded font-mono font-bold ${
                    item.badge === 'EMERGENCY' || item.badge === 'ALERT'
                      ? 'bg-red-500 text-white animate-pulse'
                      : item.badge === 'LIVE'
                      ? 'bg-emerald-500 text-black'
                      : 'bg-indigo-500/20 text-indigo-300 border border-indigo-500/30'
                  }`}>
                    {item.badge}
                  </span>
                )}
              </button>
            );
          })}
        </nav>

        {/* Right Action & Control Hub */}
        <div className="flex items-center gap-2.5 w-full md:w-auto justify-end">
          
          {/* Network Toggle Button */}
          <button
            onClick={toggleNetwork}
            title="Click to toggle between Online cellular and Offline mesh-only mode"
            className={`hidden md:flex items-center gap-1.5 px-3 py-1.5 rounded-lg border text-xs font-mono transition-all hover:scale-[1.02] active:scale-95 ${
              networkStatus === 'ONLINE'
                ? 'bg-emerald-950/40 text-emerald-300 border-emerald-700/60 hover:bg-emerald-900/30'
                : 'bg-amber-950/40 text-amber-300 border-amber-700/60 hover:bg-amber-900/30'
            }`}
          >
            {networkStatus === 'ONLINE' ? (
              <>
                <Wifi className="w-3.5 h-3.5 text-emerald-400" />
                <span>ONLINE 4G/5G</span>
              </>
            ) : (
              <>
                <WifiOff className="w-3.5 h-3.5 text-amber-400 animate-pulse" />
                <span>OFFLINE (MESH ONLY)</span>
              </>
            )}
          </button>

          {/* Battery Status */}
          <div className="flex items-center gap-1 text-xs text-slate-400 font-mono px-2 py-1 bg-slate-900/80 rounded border border-slate-800">
            <Battery className="w-3.5 h-3.5 text-emerald-400" />
            <span>78%</span>
          </div>

          {/* Sound Toggle */}
          <button
            onClick={toggleMute}
            title={isMuted ? "Unmute audio feedback" : "Mute audio feedback"}
            className="p-1.5 text-slate-400 hover:text-slate-200 hover:bg-slate-800/80 rounded-lg transition-colors"
          >
            {isMuted ? <VolumeX className="w-4 h-4 text-slate-500" /> : <Volume2 className="w-4 h-4 text-cyan-400" />}
          </button>

          {/* Reset button */}
          <button
            onClick={resetAll}
            title="Reset system to initial state"
            className="p-1.5 text-slate-400 hover:text-slate-200 hover:bg-slate-800/80 rounded-lg transition-colors"
          >
            <RotateCcw className="w-4 h-4" />
          </button>

          {/* RUN FULL SOS DEMO Button */}
          <button
            onClick={runFullDemo}
            disabled={isDemoRunning}
            className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg text-xs font-bold transition-all shadow-md active:scale-95 ${
              isDemoRunning
                ? 'bg-amber-600 text-white cursor-wait animate-pulse'
                : 'bg-gradient-to-r from-red-600 to-amber-600 hover:from-red-500 hover:to-amber-500 text-white shadow-red-950/50'
            }`}
          >
            <Play className="w-3.5 h-3.5 fill-current" />
            <span>{isDemoRunning ? 'DEMO RUNNING...' : 'RUN FULL SOS DEMO'}</span>
          </button>

        </div>

      </div>
    </header>
  );
};
