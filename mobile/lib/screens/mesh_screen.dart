import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/safety_provider.dart';
import '../models/mesh_node.dart';

class MeshScreen extends StatelessWidget {
  const MeshScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final safety = context.watch<SafetyProvider>();
    final mesh = safety.mesh;
    final nodes = mesh.nodes;
    final currentHop = mesh.currentHopIndex;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesh Relay Visualizer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Explainer Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.share, color: AppColors.meshIndigo, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Store-and-Forward Mesh Pipeline',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.meshIndigo),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Watch the encrypted SOS packet propagate peer-to-peer from the disconnected traveller to a 5G-connected gateway.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Packet Telemetry Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CURRENT HOP: $currentHop / 4',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.cyanAccent),
                  ),
                  Text(
                    'STATUS: ${currentHop >= 4 ? "DELIVERED" : currentHop >= 2 ? "UPLOADING" : "RELAYING"}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: currentHop >= 4 ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 5 Nodes Vertical Stepper / Cards
            ...nodes.asMap().entries.map((entry) {
              final idx = entry.key;
              final node = entry.value;
              final isCurrent = idx == currentHop;
              final hasReached = idx <= currentHop;

              return _buildNodeCard(context, node, idx, isCurrent, hasReached);
            }),

            const SizedBox(height: 14),

            // Controls: Step Hop, Inject SOS, Reset
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: currentHop < 4 && mesh.activeMessage != null
                        ? () => mesh.advanceHop()
                        : null,
                    icon: const Icon(Icons.fast_forward, color: Colors.white),
                    label: Text(
                      currentHop < 4 && mesh.activeMessage != null
                          ? 'STEP NEXT HOP (${currentHop + 1}/4)'
                          : currentHop >= 4
                              ? 'DELIVERY COMPLETE'
                              : 'NO ACTIVE PACKET',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.meshIndigo,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => mesh.reset(),
                  icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
                  tooltip: 'Reset Mesh',
                ),
              ],
            ),

            if (mesh.activeMessage == null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    safety.triggerImmediateSOS(isAuto: false);
                  },
                  icon: const Icon(Icons.add_alert_rounded, color: AppColors.warning),
                  label: const Text(
                    'INJECT DISTRESS BEACON INTO MESH',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.warning),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.textMuted),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '[REAL] 31-byte PDU framing & local queue. [SIMULATED] Multi-hop forwarder across Nodes B & C for single-phone evaluation.',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeCard(BuildContext context, MeshNode node, int index, bool isCurrent, bool hasReached) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.surfaceElevated : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? AppColors.warning
              : hasReached
                  ? AppColors.success
                  : AppColors.border,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Hop Circle
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasReached ? AppColors.success.withValues(alpha: 0.2) : AppColors.border,
              border: Border.all(color: hasReached ? AppColors.success : AppColors.textMuted),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: hasReached ? AppColors.success : AppColors.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      node.name,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      node.protocol.split('_').first,
                      style: const TextStyle(fontSize: 9, color: AppColors.cyanAccent, fontFamily: 'monospace'),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  node.roleDescription,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
