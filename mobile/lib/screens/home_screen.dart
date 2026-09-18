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
    final location = safety.location;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.emergency, AppColors.emergencyDark],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.emergency.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.shield_rounded, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Travel SOS Mesh',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Safety that works beyond the network.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Demo Running Badge
                  if (safety.isDemoRunning)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 10,
                            height: 10,
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
                              fontWeight: FontWeight.w800,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              // Live Demo Step Ticker
              if (safety.isDemoRunning && safety.demoStepText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.record_voice_over_rounded, size: 16, color: AppColors.warning),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          safety.demoStepText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Mesh Concept Callout Banner
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
                    const Row(
                      children: [
                        Icon(Icons.hub_rounded, color: AppColors.cyanAccent, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'HOW IT WORKS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.cyanAccent,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'If your phone loses Internet connectivity, nearby participating devices can relay an emergency message toward an Internet-connected gateway.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Status Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CURRENT STATUS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBorder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'LIVE TELEMETRY',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: safety.isMonitoringActive ? AppColors.safe : AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 6-Card Status Grid
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.35,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // 1. Journey Status
                  _buildStatusCard(
                    title: 'JOURNEY',
                    value: journey != null ? journey.status : 'INACTIVE',
                    subtitle: journey != null ? journey.destination : 'No active trip',
                    icon: Icons.navigation_rounded,
                    color: journey != null ? AppColors.safe : AppColors.textMuted,
                  ),

                  // 2. Network Status (Clickable simulation toggle)
                  InkWell(
                    onTap: () {
                      network.toggleManualOffline();
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: _buildStatusCard(
                      title: 'NETWORK (TAP)',
                      value: network.isOnline ? 'ONLINE' : 'OFFLINE',
                      subtitle: network.isOnline ? 'Cellular / Wi-Fi' : 'Mesh Standby Active',
                      icon: network.isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                      color: network.isOnline ? AppColors.safe : AppColors.warning,
                      isPulsing: network.isOffline,
                    ),
                  ),

                  // 3. Safety Monitoring
                  _buildStatusCard(
                    title: 'SAFETY MONITOR',
                    value: safety.isMonitoringActive ? 'MONITORING' : 'NOT MONITORING',
                    subtitle: safety.isMonitoringActive ? 'IMU + Gyro Active' : 'Standby Mode',
                    icon: Icons.health_and_safety_rounded,
                    color: safety.isMonitoringActive ? AppColors.cyanAccent : AppColors.textMuted,
                  ),

                  // 4. Battery Level
                  _buildStatusCard(
                    title: 'DEVICE BATTERY',
                    value: '${safety.batteryLevel}%',
                    subtitle: safety.batteryLevel > 20 ? 'Battery Optimal' : 'Power-Save Mode',
                    icon: safety.batteryLevel > 50
                        ? Icons.battery_full_rounded
                        : Icons.battery_alert_rounded,
                    color: safety.batteryLevel > 20 ? AppColors.safe : AppColors.warning,
                  ),

                  // 5. Nearby Relay Peers
                  _buildStatusCard(
                    title: 'NEARBY RELAY',
                    value: '2 DEVICES',
                    subtitle: 'BLE 5.2 Store-&-Forward',
                    icon: Icons.hub_rounded,
                    color: AppColors.meshIndigo,
                  ),

                  // 6. Location / GPS
                  _buildStatusCard(
                    title: 'LOCATION (GPS)',
                    value: location.isRealGps ? 'GPS FIX' : 'ESTIMATED',
                    subtitle: '${location.currentLocation.latitude.toStringAsFixed(4)}° N, ${location.currentLocation.longitude.toStringAsFixed(4)}° E',
                    icon: location.isRealGps ? Icons.gps_fixed_rounded : Icons.gps_not_fixed_rounded,
                    color: location.isRealGps ? AppColors.safe : AppColors.textMuted,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Primary Actions
              Row(
                children: [
                  // START JOURNEY (Primary CTA)
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: onStartJourneyPressed,
                      icon: Icon(
                        journey == null ? Icons.play_arrow_rounded : Icons.visibility_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                      label: Text(
                        journey == null ? 'START JOURNEY' : 'VIEW JOURNEY',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // RUN DEMO / STOP DEMO (Secondary CTA)
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: safety.isDemoRunning ? safety.stopDemo : safety.runFullDemo,
                      icon: Icon(
                        safety.isDemoRunning ? Icons.stop_rounded : Icons.bolt_rounded,
                        color: safety.isDemoRunning ? AppColors.warning : Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        safety.isDemoRunning ? 'STOP' : 'RUN DEMO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: safety.isDemoRunning ? AppColors.warning : Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceElevated,
                        side: BorderSide(
                          color: safety.isDemoRunning ? AppColors.warning : AppColors.border,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Emergency SOS Button (Emergency CTA)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onOpenSafetyPressed,
                  icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
                  label: const Text(
                    'EMERGENCY SOS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emergency,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                    shadowColor: AppColors.emergency.withValues(alpha: 0.4),
                  ),
                ),
              ),

              const SizedBox(height: 18),
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
        border: Border.all(
          color: isPulsing ? color.withValues(alpha: 0.6) : AppColors.border,
        ),
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
                  letterSpacing: 0.3,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
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
