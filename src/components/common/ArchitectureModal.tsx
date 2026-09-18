import React from 'react';
import { X, Cpu, Radio, Shield, Network, Lock, CheckCircle2, Layers } from 'lucide-react';

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
              Technical Architecture Whitepaper
            </span>
            <h2 className="text-xl sm:text-2xl font-black text-white tracking-tight mt-1">
              Travel SOS Mesh Protocol Specifications
            </h2>
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-xl text-slate-400 hover:text-white hover:bg-slate-800 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* 4 Pillars of the Architecture */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          
          {/* Pillar 1 */}
          <div className="p-4 rounded-2xl bg-[#090d16] border border-slate-800 space-y-2">
            <div className="w-8 h-8 rounded-lg bg-red-950/80 border border-red-800 flex items-center justify-center text-red-400">
              <Cpu className="w-4 h-4" />
            </div>
            <h3 className="font-bold text-sm text-white">1. Edge Risk Fusion Engine</h3>
            <p className="text-xs text-slate-400 leading-relaxed">
              Implemented on Android via native <code className="text-cyan-400">SensorManager</code> and on-device TFLite edge models. Samples 3-axis accelerometer, gyroscope, and acoustic RMS features at 100Hz locally. Raw audio is never recorded or streamed.
            </p>
          </div>

          {/* Pillar 2 */}
          <div className="p-4 rounded-2xl bg-[#090d16] border border-slate-800 space-y-2">
            <div className="w-8 h-8 rounded-lg bg-indigo-950/80 border border-indigo-800 flex items-center justify-center text-indigo-400">
              <Radio className="w-4 h-4" />
            </div>
            <h3 className="font-bold text-sm text-white">2. BLE 5.2 Store-and-Forward</h3>
            <p className="text-xs text-slate-400 leading-relaxed">
              When cell reception is lost (OFFLINE), the app utilizes non-connectable BLE 5.2 Extended Advertising PDUs (255 byte capacity). Nearby participating devices cache the packet and re-advertise it across a 50m radius.
            </p>
          </div>

          {/* Pillar 3 */}
          <div className="p-4 rounded-2xl bg-[#090d16] border border-slate-800 space-y-2">
            <div className="w-8 h-8 rounded-lg bg-emerald-950/80 border border-emerald-800 flex items-center justify-center text-emerald-400">
              <Network className="w-4 h-4" />
            </div>
            <h3 className="font-bold text-sm text-white">3. Opportunistic Internet Gateways</h3>
            <p className="text-xs text-slate-400 leading-relaxed">
              Any participating commuter with active cellular data (4G/5G) acts as a passive gateway node. Upon detecting the emergency beacon, it uplinks the encrypted packet via HTTPS to the cloud SOS backend within ~200ms.
            </p>
          </div>

          {/* Pillar 4 */}
          <div className="p-4 rounded-2xl bg-[#090d16] border border-slate-800 space-y-2">
            <div className="w-8 h-8 rounded-lg bg-cyan-950/80 border border-cyan-800 flex items-center justify-center text-cyan-400">
              <Lock className="w-4 h-4" />
            </div>
            <h3 className="font-bold text-sm text-white">4. Zero-Knowledge Encryption</h3>
            <p className="text-xs text-slate-400 leading-relaxed">
              Payloads are enveloped in AES-GCM-256 with public-key dispatch encryption. Relaying devices cannot read traveller identities, GPS coordinates, or emergency contacts, preventing privacy violations or eavesdropping.
            </p>
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
            Close Inspector
          </button>
        </div>

      </div>
    </div>
  );
};
