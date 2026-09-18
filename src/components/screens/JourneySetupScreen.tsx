import React, { useState } from 'react';
import { 
  MapPin, 
  User, 
  Phone, 
  ShieldCheck, 
  Navigation, 
  Clock, 
  Battery, 
  Radio, 
  Check, 
  ArrowRight,
  Info
} from 'lucide-react';
import { useSafety } from '../../context/SafetyContext';

export const JourneySetupScreen: React.FC = () => {
  const { startJourney, setScreen, networkStatus } = useSafety();

  const [destination, setDestination] = useState<string>("Kochi, Kerala");
  const [journeyName, setJourneyName] = useState<string>("Late Night Commute Home");
  const [contactName, setContactName] = useState<string>("Anjali Menon");
  const [contactPhone, setContactPhone] = useState<string>("+91 98470 12345");
  const [audioMonitoring, setAudioMonitoring] = useState<boolean>(true);
  const [motionMonitoring, setMotionMonitoring] = useState<boolean>(true);
  const [meshRelayEnabled, setMeshRelayEnabled] = useState<boolean>(true);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    startJourney(destination, contactName, contactPhone);
  };

  const presetDestinations = [
    "MG Road Metro Station, Kochi",
    "Marine Drive Walkway, Ernakulam",
    "InfoPark Expressway, Kakkanad",
    "Edappally Toll Junction, Kochi"
  ];

  return (
    <div className="max-w-3xl mx-auto py-6 px-4 sm:px-6 space-y-6">
      
      {/* Header section */}
      <div className="space-y-1">
        <button
          onClick={() => setScreen('HOME')}
          className="text-xs text-slate-400 hover:text-slate-200 flex items-center gap-1 mb-2 font-mono"
        >
          ← Back to Overview
        </button>
        <h2 className="text-2xl sm:text-3xl font-black text-white tracking-tight">
          Initialize Safe Journey
        </h2>
        <p className="text-sm text-slate-400">
          Configure journey destination and autonomous late-night safety surveillance parameters.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-6">
        
        {/* Destination & Journey Details Card */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 sm:p-6 space-y-4 shadow-xl">
          <div className="flex items-center gap-2 pb-3 border-b border-slate-800/80">
            <Navigation className="w-4 h-4 text-emerald-400" />
            <h3 className="font-bold text-sm text-slate-200 tracking-wide uppercase">
              Destination & Route
            </h3>
          </div>

          <div className="space-y-3">
            <div>
              <label className="block text-xs font-semibold text-slate-300 mb-1.5">
                Journey Name
              </label>
              <input
                type="text"
                value={journeyName}
                onChange={(e) => setJourneyName(e.target.value)}
                placeholder="e.g. Late Night Commute Home"
                className="w-full px-3.5 py-2.5 bg-[#090d16] border border-slate-700 rounded-xl text-sm text-white placeholder-slate-500 focus:outline-none focus:border-cyan-500 focus:ring-1 focus:ring-cyan-500"
                required
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-300 mb-1.5">
                Target Destination
              </label>
              <div className="relative">
                <MapPin className="absolute left-3 top-3 w-4 h-4 text-slate-500" />
                <input
                  type="text"
                  value={destination}
                  onChange={(e) => setDestination(e.target.value)}
                  placeholder="e.g. Kochi, Kerala"
                  className="w-full pl-9 pr-3.5 py-2.5 bg-[#090d16] border border-slate-700 rounded-xl text-sm text-white placeholder-slate-500 focus:outline-none focus:border-cyan-500 focus:ring-1 focus:ring-cyan-500"
                  required
                />
              </div>
            </div>

            {/* Presets */}
            <div className="flex flex-wrap items-center gap-2 pt-1">
              <span className="text-[11px] text-slate-500">Quick Presets:</span>
              {presetDestinations.map((preset) => (
                <button
                  key={preset}
                  type="button"
                  onClick={() => setDestination(preset)}
                  className="text-[11px] px-2.5 py-1 rounded-lg bg-slate-900 border border-slate-800 text-slate-300 hover:border-slate-600 hover:text-white transition-colors"
                >
                  {preset.split(',')[0]}
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* Trusted Contact Information Card */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 sm:p-6 space-y-4 shadow-xl">
          <div className="flex items-center justify-between pb-3 border-b border-slate-800/80">
            <div className="flex items-center gap-2">
              <User className="w-4 h-4 text-cyan-400" />
              <h3 className="font-bold text-sm text-slate-200 tracking-wide uppercase">
                Emergency Trusted Contact
              </h3>
            </div>
            <span className="text-[10px] font-mono text-emerald-400 px-2 py-0.5 rounded bg-emerald-950/60 border border-emerald-800/80">
              Auto-Alert on SOS
            </span>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-300 mb-1.5">
                Contact Name & Relation
              </label>
              <input
                type="text"
                value={contactName}
                onChange={(e) => setContactName(e.target.value)}
                placeholder="e.g. Anjali Menon (Sister)"
                className="w-full px-3.5 py-2.5 bg-[#090d16] border border-slate-700 rounded-xl text-sm text-white placeholder-slate-500 focus:outline-none focus:border-cyan-500 focus:ring-1 focus:ring-cyan-500"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-300 mb-1.5">
                Phone Number
              </label>
              <div className="relative">
                <Phone className="absolute left-3 top-3 w-4 h-4 text-slate-500" />
                <input
                  type="text"
                  value={contactPhone}
                  onChange={(e) => setContactPhone(e.target.value)}
                  placeholder="+91 98470 12345"
                  className="w-full pl-9 pr-3.5 py-2.5 bg-[#090d16] border border-slate-700 rounded-xl text-sm text-white font-mono placeholder-slate-500 focus:outline-none focus:border-cyan-500 focus:ring-1 focus:ring-cyan-500"
                />
              </div>
            </div>
          </div>
        </div>

        {/* Safety & Monitoring Toggles Card */}
        <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 sm:p-6 space-y-4 shadow-xl">
          <div className="flex items-center justify-between pb-3 border-b border-slate-800/80">
            <div className="flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-amber-400" />
              <h3 className="font-bold text-sm text-slate-200 tracking-wide uppercase">
                Active Monitoring Sensors
              </h3>
            </div>
            <span className="text-[11px] font-mono text-slate-400">
              All sensors run on-device
            </span>
          </div>

          <div className="space-y-3">
            {/* Audio Toggle */}
            <div 
              onClick={() => setAudioMonitoring(!audioMonitoring)}
              className="flex items-center justify-between p-3 rounded-xl bg-[#090d16] border border-slate-800 hover:border-slate-700 cursor-pointer transition-colors"
            >
              <div>
                <span className="text-xs font-semibold text-slate-200 block">
                  Acoustic Scream & Anomaly Detection
                </span>
                <span className="text-[11px] text-slate-400">
                  Runs local edge audio classifier (shatter, crash, distress vocalization)
                </span>
              </div>
              <div className={`w-5 h-5 rounded flex items-center justify-center border ${audioMonitoring ? 'bg-cyan-600 border-cyan-500 text-white' : 'border-slate-700'}`}>
                {audioMonitoring && <Check className="w-3.5 h-3.5 stroke-[3]" />}
              </div>
            </div>

            {/* Motion Toggle */}
            <div 
              onClick={() => setMotionMonitoring(!motionMonitoring)}
              className="flex items-center justify-between p-3 rounded-xl bg-[#090d16] border border-slate-800 hover:border-slate-700 cursor-pointer transition-colors"
            >
              <div>
                <span className="text-xs font-semibold text-slate-200 block">
                  Sudden Deceleration & Roll Impact
                </span>
                <span className="text-[11px] text-slate-400">
                  High-frequency Accelerometer & Gyroscope 4G+ impact trigger
                </span>
              </div>
              <div className={`w-5 h-5 rounded flex items-center justify-center border ${motionMonitoring ? 'bg-cyan-600 border-cyan-500 text-white' : 'border-slate-700'}`}>
                {motionMonitoring && <Check className="w-3.5 h-3.5 stroke-[3]" />}
              </div>
            </div>

            {/* Mesh Relay Toggle */}
            <div 
              onClick={() => setMeshRelayEnabled(!meshRelayEnabled)}
              className="flex items-center justify-between p-3 rounded-xl bg-[#090d16] border border-slate-800 hover:border-slate-700 cursor-pointer transition-colors"
            >
              <div>
                <span className="text-xs font-semibold text-slate-200 block">
                  Peer-to-Peer Mesh Relay Participation
                </span>
                <span className="text-[11px] text-slate-400">
                  Allows anonymous forwarding of encrypted SOS packets when offline
                </span>
              </div>
              <div className={`w-5 h-5 rounded flex items-center justify-center border ${meshRelayEnabled ? 'bg-indigo-600 border-indigo-500 text-white' : 'border-slate-700'}`}>
                {meshRelayEnabled && <Check className="w-3.5 h-3.5 stroke-[3]" />}
              </div>
            </div>
          </div>
        </div>

        {/* Network & Battery Status Notice */}
        <div className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 flex items-start gap-3">
          <Info className="w-4 h-4 text-amber-400 shrink-0 mt-0.5" />
          <p className="text-xs text-slate-400 leading-relaxed">
            Current network status is <strong className="text-white font-mono">{networkStatus}</strong>. Even if your cell reception drops to zero in dark transit stretches, Travel SOS Mesh maintains local peer discovery and is ready to forward an emergency signal.
          </p>
        </div>

        {/* Start Safe Journey CTA */}
        <button
          type="submit"
          className="w-full flex items-center justify-center gap-2 py-4 px-6 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-bold text-base shadow-xl shadow-emerald-950/40 transition-all hover:scale-[1.01] active:scale-[0.99]"
        >
          <span>Start Safe Journey</span>
          <ArrowRight className="w-5 h-5" />
        </button>

      </form>

    </div>
  );
};
