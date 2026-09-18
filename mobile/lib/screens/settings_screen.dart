import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/safety_provider.dart';
import 'permissions_screen.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _audioMonitoring = true;
  bool _motionMonitoring = true;
  bool _locationTracking = true;
  bool _meshRelayParticipation = true;
  int _countdownDuration = 10;
  final int _riskThreshold = 70;

  @override
  Widget build(BuildContext context) {
    final safety = context.watch<SafetyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Privacy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Sensor Monitoring
            _buildSectionHeader('Sensor & Journey Monitoring', Icons.sensors),
            const SizedBox(height: 10),
            _buildCard([
              SwitchListTile(
                value: _audioMonitoring,
                activeThumbColor: AppColors.primary,
                title: const Text(
                  'Acoustic Anomaly Detection',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: const Text(
                  'Analyzes local RMS sound windows for crashes/screams. Never uploads raw audio.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                onChanged: (val) => setState(() => _audioMonitoring = val),
              ),
              const Divider(height: 1, color: AppColors.surfaceBorder),
              SwitchListTile(
                value: _motionMonitoring,
                activeThumbColor: AppColors.primary,
                title: const Text(
                  'Motion & Gyroscope Fusion',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: const Text(
                  'Monitors accelerometer linear G-force and rotational velocity for rollover/impact.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                onChanged: (val) => setState(() => _motionMonitoring = val),
              ),
              const Divider(height: 1, color: AppColors.surfaceBorder),
              SwitchListTile(
                value: _locationTracking,
                activeThumbColor: AppColors.primary,
                title: const Text(
                  'Adaptive GPS Location Tracking',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: const Text(
                  'Logs breadcrumbs with high accuracy during active travel and emergencies.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                onChanged: (val) => setState(() => _locationTracking = val),
              ),
            ]),

            const SizedBox(height: 24),

            // Section: Safety & Thresholds
            _buildSectionHeader('Safety Thresholds & False-Alarm Guards', Icons.shield_outlined),
            const SizedBox(height: 10),
            _buildCard([
              ListTile(
                title: const Text(
                  'Confirmation Challenge Duration',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  '$_countdownDuration seconds before automatic SOS trigger',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                trailing: DropdownButton<int>(
                  value: _countdownDuration,
                  dropdownColor: AppColors.surface,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('5s (Rapid)')),
                    DropdownMenuItem(value: 10, child: Text('10s (Standard)')),
                    DropdownMenuItem(value: 15, child: Text('15s (Extended)')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _countdownDuration = val);
                  },
                ),
              ),
              const Divider(height: 1, color: AppColors.surfaceBorder),
              ListTile(
                title: const Text(
                  'Risk Trigger Threshold',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  'Score >= $_riskThreshold / 100 initiates emergency countdown',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                trailing: Text(
                  '$_riskThreshold',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 24),

            // Section: Mesh Relay
            _buildSectionHeader('Offline Mesh Relay Network', Icons.hub_outlined),
            const SizedBox(height: 10),
            _buildCard([
              SwitchListTile(
                value: _meshRelayParticipation,
                activeThumbColor: AppColors.primary,
                title: const Text(
                  'Participate as Mesh Relay Peer',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: const Text(
                  'Allows encrypted zero-knowledge SOS packets from nearby offline travellers to hop through this device toward 5G gateways.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                onChanged: (val) => setState(() => _meshRelayParticipation = val),
              ),
              const Divider(height: 1, color: AppColors.surfaceBorder),
              const ListTile(
                title: Text(
                  'Store-and-Forward TTL',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  'Packets expire automatically after 300 seconds to prevent network spam.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                trailing: Text(
                  '300s',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                ),
              ),
            ]),

            const SizedBox(height: 24),

            // Section: Privacy & Ethical Architecture
            _buildSectionHeader('Privacy & Data Governance', Icons.privacy_tip_outlined),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                children: [
                  _buildPrivacyBullet(
                    Icons.lock_clock_outlined,
                    'Zero-Knowledge Audio Processing',
                    'Acoustic signal processing evaluates dB levels on-device. Audio samples are never recorded, cached, or transmitted.',
                  ),
                  const SizedBox(height: 12),
                  _buildPrivacyBullet(
                    Icons.location_off_outlined,
                    'Need-to-Know Geolocation',
                    'GPS breadcrumbs remain isolated in secure local phone storage. Coordinates are packaged only if an SOS is dispatched.',
                  ),
                  const SizedBox(height: 12),
                  _buildPrivacyBullet(
                    Icons.vpn_key_outlined,
                    'End-to-End Encryption Envelope',
                    'SOS payloads are sealed using AES-GCM-256 and signed with Ed25519. Intermediary relay phones cannot inspect traveller identity.',
                  ),
                  const SizedBox(height: 12),
                  _buildPrivacyBullet(
                    Icons.auto_delete_outlined,
                    'Self-Expiring Ephemeral Mesh Packets',
                    'All broadcasted packets enforce strict 300-second TTL limits with hop-count boundaries to prevent relay tracking.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section: Permissions & Educational Guides
            _buildSectionHeader('Permissions & Walkthrough', Icons.security_outlined),
            const SizedBox(height: 10),
            _buildCard([
              ListTile(
                leading: const Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 22),
                title: const Text(
                  'Permissions & Privacy Hub',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: const Text(
                  'Inspect live status of Location, Microphone, Notifications, and Bluetooth.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PermissionsScreen()),
                  );
                },
              ),
              const Divider(height: 1, color: AppColors.surfaceBorder),
              ListTile(
                leading: const Icon(Icons.menu_book_outlined, color: AppColors.cyanAccent, size: 22),
                title: const Text(
                  'Replay Onboarding Guide',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: const Text(
                  'Review the 4-step walkthrough on journey monitoring, offline SOS, and mesh relay.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  );
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Section: App Metadata & Reset
            _buildSectionHeader('System & Diagnostics', Icons.info_outline),
            const SizedBox(height: 10),
            _buildCard([
              const ListTile(
                title: Text(
                  'Application',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: Text('Travel SOS Mesh (Flutter Android)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                trailing: Text('v1.0.0 (Build 1)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ),
              const Divider(height: 1, color: AppColors.surfaceBorder),
              const ListTile(
                title: Text(
                  'Team / Challenge',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: Text('Maravazha (Vijaygovind Biju, Noel Paul Tomy)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                trailing: Text('SC-03', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
              const Divider(height: 1, color: AppColors.surfaceBorder),
              ListTile(
                title: const Text(
                  'Reset Demo State',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.warning),
                ),
                subtitle: const Text('Clears cached journeys, simulated nodes, and resets telemetry.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                trailing: OutlinedButton(
                  onPressed: () {
                    safety.resetDemo();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('State reset complete.')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: const BorderSide(color: AppColors.warning),
                  ),
                  child: const Text('RESET'),
                ),
              ),
            ]),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildPrivacyBullet(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.safe),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
