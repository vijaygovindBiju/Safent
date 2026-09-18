import React from 'react';
import { 
  AlertTriangle, 
  ShieldCheck, 
  ShieldAlert, 
  Volume2, 
  Activity, 
  Clock, 
  Moon, 
  RotateCcw, 
  Send,
  HelpCircle,
  Sparkles,
  Info
} from 'lucide-react';
import { useSafety } from '../../context/SafetyContext';

export const DangerDetectionScreen: React.FC = () => {
  const { 
    dangerCountdown, 
    confirmSafe, 
    triggerImmediateSOS, 
    incident, 
    sensorTelemetry 
  } = useSafety();

  const riskFusion = incident?.riskFusion || {
    audioAnomaly: 25,
    impactDetected: 40,
    suddenRotation: 20,
    lateNightContext: 10,
    totalScore: 95,
    confidences: {
      impact: 98,
      audio: 88,
      rotation: 92,
      context: 99
    },
    level: 'HIGH'
  };

  return (
    <div className="max-w-3xl mx-auto py-6 px-4 sm:px-6 space-y-6">
      
      {/* High Alert Banner */}
      <div className="bg-red-950/50 border-2 border-red-600/80 rounded-3xl p-6 sm:p-8 shadow-2xl text-center relative overflow-hidden emergency-glow">
        
        {/* Pulsing Warning Icon */}
        <div className="w-16 h-16 rounded-full bg-red-600 border-4 border-red-400/80 mx-auto flex items-center justify-center text-white shadow-xl shadow-red-900/60 mb-4 animate-bounce">
          <AlertTriangle className="w-8 h-8 stroke-[2.5]" />
        </div>

        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-red-900/80 border border-red-700 text-xs font-mono font-bold text-red-200 mb-2">
          <span className="w-2 h-2 rounded-full bg-white animate-ping" />
          <span>AUTONOMOUS CRASH / DANGER SURVEILLANCE</span>
        </div>

        <h2 className="text-2xl sm:text-4xl font-black text-white tracking-tight">
          POSSIBLE DANGER DETECTED
        </h2>

        <p className="text-sm sm:text-base text-red-200 font-medium max-w-lg mx-auto mt-2 leading-relaxed">
          Multiple on-device anomalies detected simultaneously. Confirm your safety before emergency beacon dispatch.
        </p>

        {/* 10-Second Countdown Dial */}
        <div className="my-6 flex flex-col items-center">
          <div className="text-xs uppercase tracking-widest text-red-300 font-mono font-bold mb-2">
            Are you safe? Auto-SOS in
          </div>
          
          <div className="w-28 h-28 rounded-full border-4 border-red-500 bg-[#0a0d16] flex flex-col items-center justify-center shadow-inner relative">
            <span className="text-5xl font-black text-white font-mono tracking-tight animate-pulse">
              {dangerCountdown}
            </span>
            <span className="text-[10px] text-red-400 font-mono uppercase">seconds</span>
          </div>
        </div>

        {/* Core Dual Action Buttons */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 max-w-xl mx-auto pt-2">
          
          {/* I'M SAFE Button (False-positive dismiss) */}
          <button
            onClick={confirmSafe}
            className="flex items-center justify-center gap-2.5 py-4 px-6 rounded-2xl bg-emerald-600 hover:bg-emerald-500 active:scale-95 text-white font-black text-sm uppercase tracking-wider shadow-xl shadow-emerald-950/50 transition-all border border-emerald-400"
          >
            <ShieldCheck className="w-5 h-5 stroke-[2.5]" />
            <span>I'M SAFE</span>
          </button>

          {/* SEND SOS NOW Button */}
          <button
            onClick={triggerImmediateSOS}
            className="flex items-center justify-center gap-2.5 py-4 px-6 rounded-2xl bg-red-700 hover:bg-red-600 active:scale-95 text-white font-black text-sm uppercase tracking-wider shadow-xl shadow-red-950/60 transition-all border border-red-500"
          >
            <ShieldAlert className="w-5 h-5 stroke-[2.5]" />
            <span>SEND SOS NOW</span>
          </button>

        </div>

        <div className="mt-4 text-[11px] text-slate-300 font-mono bg-black/40 py-2 px-3 rounded-xl max-w-md mx-auto">
          <strong>False-Positive Protection:</strong> If the phone is dropped accidentally, tapping "I'M SAFE" dismisses the alert immediately. Unresponsive users trigger automatic SOS upon countdown expiry.
        </div>

      </div>

      {/* Sensor Fusion Risk Breakdown Card */}
      <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-6 shadow-xl space-y-5">
        
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pb-4 border-b border-slate-800/80">
          <div>
            <div className="flex items-center gap-2">
              <Activity className="w-4 h-4 text-cyan-400" />
              <h3 className="font-bold text-sm text-slate-200 uppercase tracking-wider font-mono">
                Multi-Sensor Risk Fusion Model
              </h3>
            </div>
            <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-amber-950/80 text-amber-300 border border-amber-800 inline-block mt-1">
              DEMO / SIMULATED SENSOR INPUT
            </span>
          </div>

          {/* Total Score Badge */}
          <div className="flex items-center gap-2 bg-red-950/80 border border-red-800 px-3.5 py-1.5 rounded-xl self-start sm:self-auto">
            <span className="text-xs font-mono text-red-300">TOTAL RISK:</span>
            <span className="text-base font-mono font-black text-white">{riskFusion.totalScore} / 100</span>
            <span className="text-[10px] font-bold px-1.5 py-0.5 rounded bg-red-600 text-white uppercase">
              {riskFusion.level}
            </span>
          </div>
        </div>

        {/* Signals Table Breakdown with Contribution & Confidence (Phase 6 requirement) */}
        <div className="space-y-3">
          
          {/* Signal 1: Impact */}
          <div className="p-3.5 rounded-xl bg-[#090d16] border border-slate-800 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-red-950/80 border border-red-800 flex items-center justify-center text-red-400">
                <Activity className="w-4 h-4" />
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <span className="text-xs font-bold text-slate-200">
                    Impact / Rapid Deceleration
                  </span>
                  <span className="text-[10px] font-mono text-emerald-400 bg-emerald-950/60 px-1.5 py-0.2 rounded border border-emerald-800">
                    Confidence: {riskFusion.confidences?.impact || 98}%
                  </span>
                </div>
                <span className="text-[11px] text-slate-400 font-mono">
                  {sensorTelemetry.accelerometerG}G force registered by 3-axis Accelerometer
                </span>
              </div>
            </div>
            <span className="text-xs font-mono font-extrabold text-red-400 px-2.5 py-1 rounded bg-red-950/60 border border-red-900">
              +{riskFusion.impactDetected}
            </span>
          </div>

          {/* Signal 2: Audio */}
          <div className="p-3.5 rounded-xl bg-[#090d16] border border-slate-800 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-amber-950/80 border border-amber-800 flex items-center justify-center text-amber-400">
                <Volume2 className="w-4 h-4" />
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <span className="text-xs font-bold text-slate-200">
                    Acoustic Anomaly / Distress Spike
                  </span>
                  <span className="text-[10px] font-mono text-emerald-400 bg-emerald-950/60 px-1.5 py-0.2 rounded border border-emerald-800">
                    Confidence: {riskFusion.confidences?.audio || 88}%
                  </span>
                </div>
                <span className="text-[11px] text-slate-400 font-mono">
                  {sensorTelemetry.ambientDecibels} dB acoustic spike (shatter / scream classifier)
                </span>
              </div>
            </div>
            <span className="text-xs font-mono font-extrabold text-amber-400 px-2.5 py-1 rounded bg-amber-950/60 border border-amber-900">
              +{riskFusion.audioAnomaly}
            </span>
          </div>

          {/* Signal 3: Sudden Rotation */}
          <div className="p-3.5 rounded-xl bg-[#090d16] border border-slate-800 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-indigo-950/80 border border-indigo-800 flex items-center justify-center text-indigo-400">
                <RotateCcw className="w-4 h-4" />
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <span className="text-xs font-bold text-slate-200">
                    Sudden Vehicle / Device Rotation
                  </span>
                  <span className="text-[10px] font-mono text-emerald-400 bg-emerald-950/60 px-1.5 py-0.2 rounded border border-emerald-800">
                    Confidence: {riskFusion.confidences?.rotation || 92}%
                  </span>
                </div>
                <span className="text-[11px] text-slate-400 font-mono">
                  {sensorTelemetry.gyroscopeDps}°/s angular tumble registered by Gyroscope
                </span>
              </div>
            </div>
            <span className="text-xs font-mono font-extrabold text-indigo-400 px-2.5 py-1 rounded bg-indigo-950/60 border border-indigo-900">
              +{riskFusion.suddenRotation}
            </span>
          </div>

          {/* Signal 4: Journey Context */}
          <div className="p-3.5 rounded-xl bg-[#090d16] border border-slate-800 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-cyan-950/80 border border-cyan-800 flex items-center justify-center text-cyan-400">
                <Moon className="w-4 h-4" />
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <span className="text-xs font-bold text-slate-200">
                    Late-Night Transit Context
                  </span>
                  <span className="text-[10px] font-mono text-emerald-400 bg-emerald-950/60 px-1.5 py-0.2 rounded border border-emerald-800">
                    Confidence: {riskFusion.confidences?.context || 99}%
                  </span>
                </div>
                <span className="text-[11px] text-slate-400 font-mono">
                  Active journey past 22:00 IST in unfamiliar transit corridor
                </span>
              </div>
            </div>
            <span className="text-xs font-mono font-extrabold text-cyan-400 px-2.5 py-1 rounded bg-cyan-950/60 border border-cyan-900">
              +{riskFusion.lateNightContext}
            </span>
          </div>

        </div>

        {/* Technical Architecture Note */}
        <div className="mt-4 pt-3 border-t border-slate-800/80 text-[11px] text-slate-400 font-mono flex flex-col sm:flex-row sm:items-center justify-between gap-2">
          <span>Proposed implementation: Android SensorManager + TFLite Audio Classifier</span>
          <span className="text-cyan-400">100% Local On-Device Processing</span>
        </div>

      </div>

    </div>
  );
};
