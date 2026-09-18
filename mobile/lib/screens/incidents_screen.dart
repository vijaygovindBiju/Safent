import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../providers/safety_provider.dart';
import '../models/incident.dart';

class IncidentsScreen extends StatelessWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final safety = context.watch<SafetyProvider>();
    final incidents = safety.incidentHistory;
    final pendingQueue = safety.pendingSosQueue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Logs & Offline Queue'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Offline Queue Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'OFFLINE SOS STORAGE QUEUE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.textMuted,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: pendingQueue.isNotEmpty
                        ? AppColors.warning.withValues(alpha: 0.2)
                        : AppColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    pendingQueue.isNotEmpty
                        ? '${pendingQueue.length} QUEUED'
                        : 'QUEUE EMPTY (0 PENDING)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: pendingQueue.isNotEmpty ? AppColors.warning : AppColors.success,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (pendingQueue.isNotEmpty)
              ...pendingQueue.map(
                (msg) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.outbox, color: AppColors.warning, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.messageId,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'TTL: ${msg.ttl}s • Stored offline without network',
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'AWAITING UPLINK',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'No pending offline SOS messages. All generated emergency signals have been synchronized.',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ),

            const SizedBox(height: 24),

            // Incident History Section
            const Text(
              'RECORDED INCIDENTS & TIMELINE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 12),

            if (incidents.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.check_circle_outline, color: AppColors.success, size: 36),
                    SizedBox(height: 8),
                    Text(
                      'All Clear — Zero Incidents Logged',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Start a journey or simulate an emergency event to inspect the audit timeline.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            else
              ...incidents.map((incident) => _buildIncidentCard(context, incident)),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentCard(BuildContext context, Incident incident) {
    final dateFormat = DateFormat('HH:mm:ss');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: incident.status.contains('SOS') ? AppColors.emergency : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    incident.status.contains('SOS') ? Icons.error : Icons.shield_outlined,
                    color: incident.status.contains('SOS') ? AppColors.emergency : AppColors.cyanAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    incident.id,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.emergencyDark.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  incident.status,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.emergency),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            incident.type,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
          ),

          const SizedBox(height: 4),

          Text(
            'Risk Score: ${incident.riskScore}/100 • Location: ${incident.location.landmark}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),

          const Divider(color: AppColors.border, height: 20),

          // Timeline Events List
          const Text(
            'Audit Timeline:',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted),
          ),

          const SizedBox(height: 6),

          ...incident.timeline.map(
            (evt) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(evt.timestamp),
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'monospace'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${evt.title} — ${evt.description}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
