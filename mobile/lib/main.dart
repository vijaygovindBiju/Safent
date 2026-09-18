import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/safety_provider.dart';
import 'services/storage_service.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  await storage.init();
  final isOnboardingCompleted = await storage.isOnboardingCompleted();

  final safetyProvider = SafetyProvider();
  await safetyProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: safetyProvider),
      ],
      child: TravelSosMeshApp(isOnboardingCompleted: isOnboardingCompleted),
    ),
  );
}

class TravelSosMeshApp extends StatelessWidget {
  final bool isOnboardingCompleted;

  const TravelSosMeshApp({
    super.key,
    this.isOnboardingCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel SOS Mesh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: isOnboardingCompleted ? const MainNavigationScreen() : const OnboardingScreen(),
    );
  }
}
