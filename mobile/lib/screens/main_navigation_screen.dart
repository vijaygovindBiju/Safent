import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/safety_provider.dart';
import 'home_screen.dart';
import 'journey_screen.dart';
import 'safety_screen.dart';
import 'incidents_screen.dart';
import 'settings_screen.dart';
import 'mesh_screen.dart';
import 'responder_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final safety = context.watch<SafetyProvider>();
    final network = safety.network;
    final isDanger = safety.isDangerActive;

    final pages = [
      HomeScreen(
        onStartJourneyPressed: () => _onTabSelected(1),
        onOpenSafetyPressed: () => _onTabSelected(2),
      ),
      const JourneyScreen(),
      const SafetyScreen(),
      const IncidentsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
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
            const SizedBox(width: 10),
            const Text(
              'Travel SOS Mesh',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          // Network toggle pill
          GestureDetector(
            onTap: () {
              network.toggleManualOffline();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    network.isManualOffline
                        ? 'Simulating Cellular Dead Zone (OFFLINE mode)'
                        : 'Simulating Cellular Restored (ONLINE mode)',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: network.isOnline
                    ? AppColors.safe.withValues(alpha: 0.15)
                    : AppColors.emergency.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: network.isOnline ? AppColors.safe : AppColors.emergency,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    network.isOnline ? Icons.wifi : Icons.wifi_off_rounded,
                    size: 14,
                    color: network.isOnline ? AppColors.safe : AppColors.emergency,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    network.isOnline ? 'ONLINE' : 'OFFLINE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: network.isOnline ? AppColors.safe : AppColors.emergency,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Mesh Visualizer Icon
          IconButton(
            tooltip: 'Mesh Visualizer',
            icon: const Icon(Icons.hub_outlined, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MeshScreen()),
              );
            },
          ),

          // Responder Console Icon
          IconButton(
            tooltip: 'Responder Console',
            icon: const Icon(Icons.shield_outlined, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResponderScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // High Priority Danger Alert Banner
          if (isDanger)
            Material(
              color: AppColors.emergency,
              child: InkWell(
                onTap: () => _onTabSelected(2), // Jump to safety screen
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CRITICAL: POSSIBLE DANGER DETECTED',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Countdown active: ${safety.dangerCountdown}s left! Tap to verify safety.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'RESPOND',
                          style: TextStyle(
                            color: AppColors.emergency,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Active tab page
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: safety.activeJourney != null && safety.activeJourney!.status == 'ACTIVE',
              smallSize: 8,
              backgroundColor: AppColors.safe,
              child: const Icon(Icons.navigation_outlined),
            ),
            selectedIcon: const Icon(Icons.navigation_rounded, color: AppColors.primary),
            label: 'Journey',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: isDanger,
              backgroundColor: AppColors.emergency,
              child: const Icon(Icons.health_and_safety_outlined),
            ),
            selectedIcon: const Icon(Icons.health_and_safety_rounded, color: AppColors.primary),
            label: 'Safety',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: safety.pendingSosQueue.isNotEmpty,
              label: Text('${safety.pendingSosQueue.length}'),
              child: const Icon(Icons.history_edu_outlined),
            ),
            selectedIcon: const Icon(Icons.history_edu_rounded, color: AppColors.primary),
            label: 'Incidents',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded, color: AppColors.primary),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
