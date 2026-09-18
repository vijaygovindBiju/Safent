import React, { useState } from 'react';
import { SafetyProvider, useSafety } from './context/SafetyContext';
import { Header } from './components/common/Header';
import { HomeScreen } from './components/screens/HomeScreen';
import { JourneySetupScreen } from './components/screens/JourneySetupScreen';
import { ActiveJourneyScreen } from './components/screens/ActiveJourneyScreen';
import { DangerDetectionScreen } from './components/screens/DangerDetectionScreen';
import { SOSActiveScreen } from './components/screens/SOSActiveScreen';
import { MeshVisualizationScreen } from './components/screens/MeshVisualizationScreen';
import { ResponderDashboardScreen } from './components/screens/ResponderDashboardScreen';
import { DemoController } from './components/common/DemoController';
import { ArchitectureModal } from './components/common/ArchitectureModal';
import { ShieldAlert, BookOpen, Layers, ShieldCheck, Heart } from 'lucide-react';

const ScreenRenderer: React.FC = () => {
  const { currentScreen } = useSafety();

  switch (currentScreen) {
    case 'HOME':
      return <HomeScreen />;
    case 'SETUP':
      return <JourneySetupScreen />;
    case 'ACTIVE':
      return <ActiveJourneyScreen />;
    case 'DANGER':
      return <DangerDetectionScreen />;
    case 'SOS_ACTIVE':
      return <SOSActiveScreen />;
    case 'MESH_RELAY':
      return <MeshVisualizationScreen />;
    case 'RESPONDER':
      return <ResponderDashboardScreen />;
    default:
      return <HomeScreen />;
  }
};

const AppContent: React.FC = () => {
  const [isArchModalOpen, setIsArchModalOpen] = useState(false);

  return (
    <div className="min-h-screen flex flex-col bg-[#080b11] text-slate-100 selection:bg-red-500 selection:text-white">
      {/* Sticky Global Navigation Header */}
      <Header />

      {/* Main Screen Stage */}
      <main className="flex-1 pb-24">
        <ScreenRenderer />
      </main>

      {/* Floating Demo Mode Controller */}
      <DemoController />

      {/* Technical Architecture Whitepaper Modal */}
      <ArchitectureModal 
        isOpen={isArchModalOpen} 
        onClose={() => setIsArchModalOpen(false)} 
      />

      {/* Bottom Global Footer */}
      <footer className="border-t border-slate-800/80 bg-[#090d16] py-6 px-4 text-xs text-slate-400">
        <div className="max-w-6xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-2">
            <ShieldAlert className="w-4 h-4 text-red-500" />
            <span className="font-semibold text-slate-200">Travel SOS Mesh</span>
            <span>—</span>
            <span>Late-Night Journey Safety Companion</span>
          </div>

          <div className="flex items-center gap-4">
            <button
              onClick={() => setIsArchModalOpen(true)}
              className="text-cyan-400 hover:text-cyan-300 font-mono font-semibold flex items-center gap-1.5 transition-colors"
            >
              <BookOpen className="w-3.5 h-3.5" />
              <span>Technical Whitepaper & Architecture</span>
            </button>

            <span className="text-slate-600">|</span>

            <span className="font-mono text-slate-400">
              Team Maravazha • SC-03
            </span>
          </div>
        </div>
      </footer>
    </div>
  );
};

export const App: React.FC = () => {
  return (
    <SafetyProvider>
      <AppContent />
    </SafetyProvider>
  );
};

export default App;
