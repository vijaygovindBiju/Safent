import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../services/storage_service.dart';
import 'main_navigation_screen.dart';
import 'permissions_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final StorageService _storage = StorageService();
  int _currentPage = 0;

  final List<_OnboardingItem> _pages = const [
    _OnboardingItem(
      title: 'Late-Night Journey Safety',
      subtitle: 'Real-Time Path & Arrival Vigilance',
      description:
          'Travel with confidence after hours. Track your transit path with adaptive GPS breadcrumbs, duration timers, and trusted contacts notified from the start.',
      icon: Icons.navigation_rounded,
      badgeText: 'JOURNEY MONITORING',
      accentColor: AppColors.primary,
      features: ['Real-Time GPS Breadcrumbs', 'Trusted Contact Link', 'Battery Adaptive Sampling'],
    ),
    _OnboardingItem(
      title: 'Multi-Sensor Danger Fusion',
      subtitle: 'Impact & Rollover Anomaly Detection',
      description:
          'On-device accelerometer and gyroscope analyze sudden deceleration and tumbling. A 10-second "Are you safe?" challenge prevents false alarms before alerting anyone.',
      icon: Icons.health_and_safety_rounded,
      badgeText: 'SAFETY DETECTION',
      accentColor: AppColors.emergency,
      features: ['3-Axis Accelerometer & Gyro', '10s False-Alarm Challenge', 'Zero Raw Audio Uploaded'],
    ),
    _OnboardingItem(
      title: 'Offline-First Distress SOS',
      subtitle: 'Safety That Survives Dead-Zones',
      description:
          'Emergency SOS never fails just because cellular signal drops. Distress beacons are encrypted and stored in local phone storage across app restarts until delivered.',
      icon: Icons.signal_cellular_connected_no_internet_0_bar_rounded,
      badgeText: 'OFFLINE SOS',
      accentColor: AppColors.warning,
      features: ['Local Queue Storage', 'Radial Hold-for-SOS (1.5s)', 'Auto-Flush on Signal Recovery'],
    ),
    _OnboardingItem(
      title: 'Store-and-Forward Mesh Relay',
      subtitle: 'Relaying Beyond the Cellular Edge',
      description:
          'When offline, encrypted SOS beacons hop anonymously across nearby participating phones over Bluetooth Low Energy until reaching an Internet-connected gateway.',
      icon: Icons.hub_rounded,
      badgeText: 'MESH RELAY NETWORK',
      accentColor: AppColors.cyanAccent,
      features: ['BLE Store-and-Forward', 'Anonymous Zero-Knowledge Hopping', 'Self-Expiring 300s TTL'],
    ),
  ];

  Future<void> _completeOnboarding() async {
    await _storage.saveOnboardingCompleted(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App branding
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.emergency, AppColors.emergencyDark],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Travel SOS Mesh',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  // Skip or Permissions Hub
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text(
                      'SKIP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return _buildPage(item);
                },
              ),
            ),

            // Bottom Control Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? _pages[_currentPage].accentColor
                              : AppColors.surfaceBorder,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Action Buttons
                  Row(
                    children: [
                      // Permissions Hub Button
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PermissionsScreen()),
                          );
                        },
                        icon: const Icon(Icons.lock_outline, size: 16),
                        label: const Text('PERMISSIONS'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.surfaceBorder),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Next / Get Started Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage < _pages.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _completeOnboarding();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pages[_currentPage].accentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1 ? 'GET STARTED' : 'NEXT',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingItem item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: item.accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: item.accentColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              item.badgeText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: item.accentColor,
                letterSpacing: 1.0,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Central Icon Hero
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  item.accentColor.withValues(alpha: 0.25),
                  item.accentColor.withValues(alpha: 0.05),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: item.accentColor.withValues(alpha: 0.3), width: 2),
            ),
            child: Icon(item.icon, size: 54, color: item.accentColor),
          ),

          const SizedBox(height: 28),

          // Title & Subtitle
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: item.accentColor,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 24),

          // Key Feature Highlights
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Column(
              children: item.features.map((feat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 16, color: item.accentColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feat,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final String badgeText;
  final Color accentColor;
  final List<String> features;

  const _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.badgeText,
    required this.accentColor,
    required this.features,
  });
}
