import React from 'react';
import { 
  Clock, 
  AlertTriangle, 
  ShieldCheck, 
  Radio, 
  Wifi, 
  CheckCircle2, 
  Server, 
  Activity,
  ArrowUpRight
} from 'lucide-react';
import { IncidentTimelineEvent } from '../../types';

interface IncidentTimelineProps {
  events: IncidentTimelineEvent[];
  maxEvents?: number;
}

export const IncidentTimeline: React.FC<IncidentTimelineProps> = ({ events, maxEvents }) => {
  const displayEvents = maxEvents ? events.slice(0, maxEvents) : events;

  const getCategoryIcon = (category: IncidentTimelineEvent['category'], severity: IncidentTimelineEvent['severity']) => {
    switch (category) {
      case 'DETECTION':
        return <AlertTriangle className="w-4 h-4 text-amber-400" />;
      case 'ASSESSMENT':
        return <Activity className="w-4 h-4 text-cyan-400" />;
      case 'SAFETY_CHECK':
        return <ShieldCheck className="w-4 h-4 text-emerald-400" />;
      case 'SOS':
        return <Radio className="w-4 h-4 text-red-400 animate-pulse" />;
      case 'MESH':
        return <Radio className="w-4 h-4 text-indigo-400" />;
      case 'GATEWAY':
        return <Wifi className="w-4 h-4 text-emerald-400" />;
      case 'RESPONDER':
        return <Server className="w-4 h-4 text-rose-400" />;
      default:
        return <CheckCircle2 className="w-4 h-4 text-slate-400" />;
    }
  };

  const getBadgeStyle = (severity: IncidentTimelineEvent['severity']) => {
    switch (severity) {
      case 'CRITICAL':
        return 'bg-red-950/80 text-red-300 border-red-800/80';
      case 'WARNING':
        return 'bg-amber-950/80 text-amber-300 border-amber-800/80';
      case 'SUCCESS':
        return 'bg-emerald-950/80 text-emerald-300 border-emerald-800/80';
      default:
        return 'bg-slate-800 text-slate-300 border-slate-700';
    }
  };

  return (
    <div className="bg-[#0f1422] border border-slate-800 rounded-2xl p-5 shadow-xl">
      <div className="flex items-center justify-between mb-4 pb-3 border-b border-slate-800/80">
        <div className="flex items-center gap-2">
          <Clock className="w-4 h-4 text-slate-400" />
          <h3 className="font-bold text-sm text-slate-200 tracking-wide uppercase">
            Real-Time Audit Timeline
          </h3>
        </div>
        <span className="text-[11px] font-mono text-slate-500">
          {events.length} event{events.length !== 1 ? 's' : ''} logged
        </span>
      </div>

      {displayEvents.length === 0 ? (
        <div className="py-8 text-center text-slate-500 text-xs font-mono">
          No incidents logged yet. System operating in active telemetry surveillance mode.
        </div>
      ) : (
        <div className="relative pl-6 space-y-4 before:absolute before:left-2 before:top-2 before:bottom-2 before:w-0.5 before:bg-slate-800">
          {displayEvents.map((event) => (
            <div key={event.id} className="relative group">
              {/* Timeline node circle */}
              <div className="absolute -left-[27px] top-0.5 w-6 h-6 rounded-full bg-[#0c101a] border border-slate-700 flex items-center justify-center shadow-md">
                {getCategoryIcon(event.category, event.severity)}
              </div>

              {/* Event Content */}
              <div className="bg-[#131929]/70 hover:bg-[#161e32] transition-colors p-3 rounded-xl border border-slate-800/80">
                <div className="flex items-center justify-between gap-2 mb-1">
                  <span className="font-semibold text-xs text-slate-100 flex items-center gap-1.5">
                    {event.title}
                  </span>
                  <span className="text-[11px] font-mono text-slate-400 px-1.5 py-0.5 rounded bg-slate-900 border border-slate-800 flex items-center gap-1">
                    <Clock className="w-3 h-3 text-slate-500" />
                    {event.timeString}
                  </span>
                </div>
                <p className="text-xs text-slate-300 leading-relaxed">
                  {event.description}
                </p>
                <div className="mt-2 flex items-center gap-2 text-[10px] font-mono">
                  <span className={`px-2 py-0.5 rounded border ${getBadgeStyle(event.severity)}`}>
                    {event.category}
                  </span>
                  <span className="text-slate-500">
                    ID: {event.id}
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
