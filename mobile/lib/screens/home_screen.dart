import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/safety_provider.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStartJourneyPressed;
  final VoidCallback onOpenSafetyPressed;

  const HomeScreen({
    super.key,
    required this.onStartJourneyPressed,
    required this.onOpenSafetyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final safety = context.watch<SafetyProvider>();
    final network = safety.network;
    final journey = safety.activeJourney;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Mission Statement
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.emergency, AppColors.emergencyDark],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shield_outlined, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Travel SOS Mesh',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Safety that works beyond the network',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Demo running badge
                  if (safety.isDemoRunning)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 8,
                            height: 8,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.warning,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${safety.demoProgress}%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 18),

              // Mesh Concept Callout
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.hub_outlined, color: AppColors.cyanAccent, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Store-and-Forward Mesh Concept',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.cyanAccent,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'If your phone loses Internet connectivity in late-night shadow zones, nearby participating devices autonomously relay an emergency SOS toward an Internet-connected gateway.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Status Header
              const Text(
                'CURRENT SYSTEM STATUS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 10),

              // Status Cards Grid
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.35,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Journey Status
                  _buildStatusCard(
                    title: 'JOURNEY',
                    value: journey != null ? journey.status : 'INACTIVE',
                    subtitle: journey != null ? journey.destination : 'No active route',
                    icon: Icons.navigation_outlined,
                    color: journey != null ? AppColors.success : AppColors.textMuted,
                  ),

                  // Network Status (Clickable to toggle)
                  InkWell(
                    onTap: () => network.toggleManualOffline(),
                    borderRadius: BorderRadius.circular(16),
                    child: _buildStatusCard(
                      title: 'NETWORK (TAP)',
                      value: network.isOnline ? 'ONLINE' : 'OFFLINE',
                      subtitle: network.isOnline ? 'Direct Cellular' : 'Mesh Standby Active',
                      icon: network.isOnline ? Icons.wifi : Icons.wifi_off,
                      color: network.isOnline ? AppColors.success : AppColors.warning,
                      isPulsing: network.isOffline,
                    ),
                  ),

                  // Safety Monitoring
                  _buildStatusCard(
                    title: 'SAFETY MONITOR',
                    value: safety.isMonitoringActive ? 'ACTIVE' : 'STANDBY',
                    subtitle: 'IMU + Acoustic + GPS',
                    icon: Icons.health_and_safety_outlined,
                    color: safety.isMonitoringActive ? AppColors.cyanAccent : AppColors.textMuted,
                  ),

                  // Battery & Peers
                  _buildStatusCard(
                    title: 'BATTERY & PEERS',
                    value: '${safety.batteryLevel}%',
                    subtitle: '2 Nearby Mesh Peers',
                    icon: Icons.battery_charging_full,
                    color: AppColors.meshIndigo,
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // Primary Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onStartJourneyPressed,
                      icon: const Icon(Icons.play_arrow_rounded, color: Colors.black),
                      label: Text(
                        journey == null ? 'START JOURNEY' : 'VIEW JOURNEY',
                        style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: safety.isDemoRunning ? safety.stopDemo : safety.runFullDemo,
                    icon: Icon(
                      safety.isDemoRunning ? Icons.stop : Icons.bolt,
                      color: Colors.white,
                    ),
                    label: Text(
                      safety.isDemoRunning ? 'STOP' : 'DEMO',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceElevated,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Emergency Quick Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onOpenSafetyPressed,
                  icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
                  label: const Text(
                    'EMERGENCY SOS CONTROLS',
                    style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emergency,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool isPulsing = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
