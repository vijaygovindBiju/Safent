import React from 'react';
import { X, Cpu, Radio, Shield, Network, Lock, CheckCircle2, Layers, EyeOff, Clock, AlertTriangle } from 'lucide-react';

interface ArchitectureModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const ArchitectureModal: React.FC<ArchitectureModalProps> = ({ isOpen, onClose }) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="bg-[#0f1422] border border-slate-700 rounded-3xl max-w-3xl w-full p-6 sm:p-8 shadow-2xl space-y-6 max-h-[90vh] overflow-y-auto">
        
        {/* Modal Header */}
        <div className="flex items-center justify-between pb-4 border-b border-slate-800">
          <div>
            <span className="text-[10px] font-mono font-bold px-2 py-0.5 rounded bg-indigo-950/80 text-indigo-300 border border-indigo-800 uppercase">
              System Architecture & Transparency
            </span>
            <h2 className="text-xl sm:text-2xl font-black text-white tracking-tight mt-1">
              Travel SOS Mesh Architecture
            </h2>
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-xl text-slate-400 hover:text-white hover:bg-slate-800 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Prototype Transparency Notice */}
        <div className="p-4 rounded-2xl bg-amber-950/30 border border-amber-800/80 space-y-1.5 text-xs text-slate-300">
          <div className="flex items-center gap-2 text-amber-300 font-bold font-mono text-[11px] uppercase">
            <AlertTriangle className="w-4 h-4 text-amber-400" />
            <span>Prototype Reality Notice (Honest Technical Distinction)</span>
          </div>
          <p className="text-slate-400 leading-relaxed">
            This browser application simulates the networking and sensor layers to demonstrate the end-to-end architecture for hackathon evaluation. The production mobile deployment is designed for native Android using C++ and Kotlin.
          </p>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 pt-1 font-mono text-[10px]">
            <div className="p-1.5 rounded bg-slate-900/80 border border-slate-800 text-emerald-400">
              ✓ IMPLEMENTED: State engine, UI, Audio synthesizer, Demo flow
            </div>
            <div className="p-1.5 rounded bg-slate-900/80 border border-slate-800 text-amber-400">
              ⚡ SIMULATED: Sensor inputs, BLE packets, 5G uplink, Dispatch
            </div>
            <div className="p-1.5 rounded bg-slate-900/80 border border-slate-800 text-cyan-400">
              📋 PLANNED: Native Android SensorManager, BLE daemon, PSAP API
            </div>
          </div>
        </div>

        {/* 6 Architectural Layers */}
        <div className="space-y-3">
          <h3 className="text-xs font-bold text-slate-300 uppercase font-mono tracking-wider">
            Layer-by-Layer Architectural Pipeline
          </h3>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
            
            <div className="p-3.5 rounded-xl bg-[#090d16] border border-slate-800 space-y-1">
              <span className="text-cyan-400 font-bold font-mono text-[10px] block">LAYER 1: LOCAL DETECTION</span>
              <h4 className="font-bold text-white text-sm">On-Device Risk Fusion</h4>
              <p className="text-slate-400 leading-relaxed text-[11px]">
                Samples 3-axis accelerometer (impact &gt;4G), gyroscope (&gt;80°/s tumble), and acoustic RMS features locally. Raw microphone sound is never recorded or streamed.
              </p>
            </div>

            <div className="p-3.5 rounded-xl bg-[#090d16] border border-slate-800 space-y-1">
              <span className="text-cyan-400 font-bold font-mono text-[10px] block">LAYER 2: USER VERIFICATION</span>
              <h4 className="font-bold text-white text-sm">10s Safety Challenge</h4>
              <p className="text-slate-400 leading-relaxed text-[11px]">
                Eliminates false alarms when a phone is dropped. A single tap on "I'M SAFE" aborts transmission. If the user is unresponsive, SOS triggers automatically.
              </p>
            </div>

            <div className="p-3.5 rounded-xl bg-[#090d16] border border-slate-800 space-y-1">
              <span className="text-cyan-400 font-bold font-mono text-[10px] block">LAYER 3: COMPACT PAYLOAD</span>
              <h4 className="font-bold text-white text-sm">Offline-First Distress PDU</h4>
              <p className="text-slate-400 leading-relaxed text-[11px]">
                Compresses GPS fix, risk score, device ID, and timestamp into a 255-byte advertising payload protected with public-key dispatch envelope encryption.
              </p>
            </div>

            <div className="p-3.5 rounded-xl bg-[#090d16] border border-slate-800 space-y-1">
              <span className="text-cyan-400 font-bold font-mono text-[10px] block">LAYER 4: PEER RELAY</span>
              <h4 className="font-bold text-white text-sm">Store-and-Forward Mesh</h4>
              <p className="text-slate-400 leading-relaxed text-[11px]">
                Nearby participating commuter phones receive packets via BLE 5.2 Extended Advertisements, decrement TTL, and re-broadcast across a 50m radius without cellular data.
              </p>
            </div>

            <div className="p-3.5 rounded-xl bg-[#090d16] border border-slate-800 space-y-1">
              <span className="text-cyan-400 font-bold font-mono text-[10px] block">LAYER 5: UPLINK GATEWAY</span>
              <h4 className="font-bold text-white text-sm">Opportunistic 5G Uplink</h4>
              <p className="text-slate-400 leading-relaxed text-[11px]">
                Any participating device with active cellular reception acts as a passive bridge, forwarding the encrypted packet via HTTPS to the cloud ingestion backend.
              </p>
            </div>

            <div className="p-3.5 rounded-xl bg-[#090d16] border border-slate-800 space-y-1">
              <span className="text-cyan-400 font-bold font-mono text-[10px] block">LAYER 6: EMERGENCY DISPATCH</span>
              <h4 className="font-bold text-white text-sm">Response Center Console</h4>
              <p className="text-slate-400 leading-relaxed text-[11px]">
                Authorized safety dispatchers decrypt the payload to display exact coordinates, route history, and vector response units (Ambulance 108 / Police).
              </p>
            </div>

          </div>
        </div>

        {/* Phase 16: Privacy & Ethical Safeguards */}
        <div className="p-4 rounded-2xl bg-[#090d16] border border-slate-800 space-y-2 text-xs">
          <div className="flex items-center gap-2 text-slate-200 font-bold uppercase font-mono">
            <Shield className="w-4 h-4 text-emerald-400" />
            <span>Privacy & Ethical Safeguards</span>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-slate-400 text-[11px] leading-relaxed pt-1">
            <div className="space-y-1">
              <span className="text-slate-200 font-semibold block">● Local On-Device Processing:</span>
              Sensor telemetry is evaluated locally. Audio classification runs on-device via quantized neural network weights without streaming audio.
            </div>

            <div className="space-y-1">
              <span className="text-slate-200 font-semibold block">● Zero-Knowledge Relaying:</span>
              Participating relay nodes carry opaque ciphertexts. Relay users cannot view your name, photos, contacts, or location.
            </div>

            <div className="space-y-1">
              <span className="text-slate-200 font-semibold block">● Time-To-Live (TTL) Automatic Purge:</span>
              Emergency packets automatically expire after 300 seconds, preventing stale message loops across peer devices.
            </div>

            <div className="space-y-1">
              <span className="text-slate-200 font-semibold block">● Opt-in Community Participation:</span>
              Commuters opt in to act as relay nodes, with battery throttling guards ensuring under 1% background consumption.
            </div>
          </div>
        </div>

        {/* Team Credits */}
        <div className="p-4 rounded-2xl bg-slate-900/60 border border-slate-800 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 text-xs">
          <div>
            <span className="font-bold text-slate-200">Team Maravazha</span>
            <p className="text-slate-400 mt-0.5">Vijaygovind Biju • Noel Paul Tomy</p>
          </div>
          <span className="font-mono text-cyan-400 bg-cyan-950/80 px-2.5 py-1 rounded-lg border border-cyan-800">
            Challenge: SC-03 Late-Night Safety
          </span>
        </div>

        <div className="text-center pt-2">
          <button
            onClick={onClose}
            className="px-6 py-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-white text-xs font-bold transition-colors"
          >
            Close Whitepaper
          </button>
        </div>

      </div>
    </div>
  );
};
