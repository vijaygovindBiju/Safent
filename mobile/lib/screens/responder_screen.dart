import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../providers/safety_provider.dart';
import '../models/incident.dart';

class ResponderScreen extends StatelessWidget {
  const ResponderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final safety = context.watch<SafetyProvider>();
    final currentIncident = safety.currentIncident;
    final allIncidents = safety.incidentHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responder Command Console'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceBorder,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.badge_outlined, size: 14, color: AppColors.textMuted),
                SizedBox(width: 6),
                Text(
                  'CONSOLE #04',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: currentIncident != null && currentIncident.status != 'RESOLVED'
                    ? AppColors.emergencyDark.withValues(alpha: 0.3)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: currentIncident != null && currentIncident.status != 'RESOLVED'
                      ? AppColors.emergency.withValues(alpha: 0.6)
                      : AppColors.surfaceBorder,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: currentIncident != null && currentIncident.status != 'RESOLVED'
                          ? AppColors.emergency
                          : AppColors.safe,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      currentIncident != null && currentIncident.status != 'RESOLVED'
                          ? Icons.warning_rounded
                          : Icons.verified_user_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentIncident != null && currentIncident.status != 'RESOLVED'
                              ? 'ACTIVE DISTRESS INCIDENT'
                              : 'NO ACTIVE INCIDENTS',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: currentIncident != null && currentIncident.status != 'RESOLVED'
                                ? AppColors.emergency
                                : AppColors.safe,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentIncident != null && currentIncident.status != 'RESOLVED'
                              ? 'Telemetry received via multi-hop mesh / cellular relay.'
                              : 'Emergency monitoring operational. Waiting for dispatch trigger.',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (currentIncident != null) ...[
              // Incident Detail Card
              _buildIncidentDetailCard(context, safety, currentIncident),
              const SizedBox(height: 20),

              // Actions Panel
              _buildActionPanel(context, safety, currentIncident),
              const SizedBox(height: 20),

              // SMS Preview
              _buildSmsPreview(currentIncident),
              const SizedBox(height: 20),
            ],

            // Historical Incidents Section
            const Text(
              'Incident History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            if (allIncidents.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.history_toggle_off, size: 36, color: AppColors.textMuted),
                    SizedBox(height: 8),
                    Text(
                      'No past incidents recorded on this device.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allIncidents.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final inc = allIncidents[index];
                  return _buildHistoryItem(inc);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentDetailCard(BuildContext context, SafetyProvider safety, Incident inc) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                inc.id,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.emergency,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(inc.status).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _statusColor(inc.status)),
                ),
                child: Text(
                  inc.status.replaceAll('_', ' '),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(inc.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Metadata Grid
          _buildInfoRow('Traveller', inc.travellerName),
          _buildInfoRow('Trigger Reason', inc.type),
          _buildInfoRow('Risk Score', '${inc.riskScore} / 100 (${inc.riskFusion.riskLevel})'),
          _buildInfoRow(
            'GPS Coordinates',
            '${inc.location.latitude.toStringAsFixed(5)}, ${inc.location.longitude.toStringAsFixed(5)}',
          ),
          _buildInfoRow('Device Battery', '${inc.battery}%'),
          _buildInfoRow(
            'Reported Time',
            DateFormat('HH:mm:ss (dd MMM yyyy)').format(inc.timestamp),
          ),
          if (inc.acknowledgedBy != null)
            _buildInfoRow('Acknowledged By', inc.acknowledgedBy!),
          if (inc.responderNotes != null)
            _buildInfoRow('Dispatch Notes', inc.responderNotes!),

          const SizedBox(height: 14),

          // Audit Timeline
          const Text(
            'Audit Timeline (Immutable Log)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          ...inc.timeline.map((evt) => _buildTimelineTile(evt)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTile(IncidentEvent evt) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _eventSeverityColor(evt.severity),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      evt.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm:ss').format(evt.timestamp),
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Text(
                  evt.description,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel(BuildContext context, SafetyProvider safety, Incident inc) {
    final isAcked = inc.status == 'ACKNOWLEDGED';
    final isResolved = inc.status == 'RESOLVED';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergency Response Actions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isAcked || isResolved
                      ? null
                      : () {
                          safety.acknowledgeIncident();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Incident acknowledged. Dispatch logged.'),
                              backgroundColor: AppColors.safe,
                            ),
                          );
                        },
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(isAcked || isResolved ? 'ACKNOWLEDGED' : 'ACKNOWLEDGE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isResolved
                      ? null
                      : () {
                          safety.resolveIncident();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Incident marked RESOLVED & secured.'),
                              backgroundColor: AppColors.safe,
                            ),
                          );
                        },
                  icon: const Icon(Icons.done_all, size: 18),
                  label: Text(isResolved ? 'RESOLVED' : 'RESOLVE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.safe,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmsPreview(Incident inc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.sms_outlined, size: 16, color: AppColors.warning),
              SizedBox(width: 8),
              Text(
                'Trusted Contact Emergency SMS (Simulated)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Text(
              'EMERGENCY ALERT: ${inc.travellerName} triggered an SOS at ${inc.location.landmark.isNotEmpty ? inc.location.landmark : "${inc.location.latitude.toStringAsFixed(4)}, ${inc.location.longitude.toStringAsFixed(4)}"}. Response units notified. Live tracking: https://travel-sos.maravazha.org/track/${inc.id}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Incident inc) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inc.id,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('dd MMM yyyy, HH:mm').format(inc.timestamp),
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor(inc.status).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              inc.status.replaceAll('_', ' '),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: _statusColor(inc.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'CONFIRMED_SAFE':
      case 'RESOLVED':
        return AppColors.safe;
      case 'ACKNOWLEDGED':
        return AppColors.primary;
      case 'CONFIRMATION_PENDING':
        return AppColors.warning;
      case 'SOS_CREATED':
      case 'DELIVERED':
      default:
        return AppColors.emergency;
    }
  }

  Color _eventSeverityColor(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return AppColors.emergency;
      case 'WARNING':
        return AppColors.warning;
      case 'SUCCESS':
        return AppColors.safe;
      default:
        return AppColors.primary;
    }
  }
}
