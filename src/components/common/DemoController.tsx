import React from 'react';
import { Play, Square, FastForward, CheckCircle2, Radio, Info } from 'lucide-react';
import { useSafety } from '../../context/SafetyContext';

export const DemoController: React.FC = () => {
  const { 
    isDemoRunning, 
    demoProgress, 
    demoStepText, 
    stopDemo, 
    runFullDemo 
  } = useSafety();

  if (!isDemoRunning) return null;

  return (
    <div className="fixed bottom-4 left-1/2 -translate-x-1/2 z-50 w-[95%] max-w-2xl bg-[#0c121e]/95 backdrop-blur-md border-2 border-amber-500/80 rounded-2xl p-4 shadow-2xl shadow-amber-950/40 text-slate-100 animate-in fade-in slide-in-from-bottom-5 duration-300">
      
      {/* Top status bar */}
      <div className="flex items-center justify-between gap-3 mb-2.5">
        <div className="flex items-center gap-2">
          <span className="relative flex h-3 w-3">
            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
            <span className="relative inline-flex rounded-full h-3 w-3 bg-amber-500"></span>
          </span>
          <span className="font-mono text-xs font-black tracking-wider text-amber-400 uppercase">
            LIVE HACKATHON DEMO MODE ACTIVE
          </span>
        </div>

        <div className="flex items-center gap-2">
          <span className="text-xs font-mono text-slate-400 font-bold">
            {demoProgress}%
          </span>
          <button
            onClick={stopDemo}
            className="flex items-center gap-1 px-2.5 py-1 rounded-lg bg-red-900/60 hover:bg-red-800/80 text-red-300 border border-red-700/80 text-xs font-semibold transition-colors"
          >
            <Square className="w-3 h-3 fill-current" />
            <span>Stop</span>
          </button>
        </div>
      </div>

      {/* Progress Bar */}
      <div className="w-full bg-slate-800/80 rounded-full h-2.5 overflow-hidden mb-2.5">
        <div 
          className="bg-gradient-to-r from-amber-500 via-orange-500 to-emerald-400 h-full rounded-full transition-all duration-300"
          style={{ width: `${demoProgress}%` }}
        />
      </div>

      {/* Current Step Description for Judges */}
      <div className="flex items-start gap-2 text-xs">
        <Radio className="w-4 h-4 text-amber-400 shrink-0 mt-0.5 animate-pulse" />
        <p className="text-slate-200 font-medium">
          {demoStepText}
        </p>
      </div>

    </div>
  );
};
