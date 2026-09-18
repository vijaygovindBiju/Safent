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

            // Manual Hop Advance Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: currentHop < 4 ? () => mesh.advanceHop() : null,
                    icon: const Icon(Icons.fast_forward, color: Colors.white),
                    label: Text(
                      currentHop < 4 ? 'STEP NEXT HOP (HOP ${currentHop + 1})' : 'DELIVERY COMPLETE',
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
