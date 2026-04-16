import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/checkin_screen.dart';
import 'screens/history_screen.dart';
import 'screens/startup_face_gate_screen.dart';
import 'services/sync_service.dart';
import 'utils/app_theme.dart';

/// WorkManager background task dispatcher.
/// This runs in a separate isolate — no Flutter UI access.
/// Registered once at startup; fires every 15 minutes when network is available.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == SyncService.syncTaskName) {
      await SyncService.runBackgroundSync();
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Portrait only — consistent behaviour across all Android screen sizes
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor          : Colors.transparent,
    statusBarIconBrightness : Brightness.light,
  ));

  // Register WorkManager for background offline sync
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    SyncService.syncTaskName,
    SyncService.syncTaskName,
    frequency          : const Duration(minutes: 15),
    existingWorkPolicy : ExistingPeriodicWorkPolicy.keep,
    constraints        : Constraints(networkType: NetworkType.connected),
    backoffPolicy      : BackoffPolicy.exponential,
    backoffPolicyDelay : const Duration(seconds: 10),
  );

  runApp(const ProviderScope(child: SentinelGateApp()));
}

class SentinelGateApp extends StatelessWidget {
  const SentinelGateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title            : 'SentinelGate',
      debugShowCheckedModeBanner: false,
      theme            : AppTheme.light,
      darkTheme        : AppTheme.dark,
      themeMode        : ThemeMode.system,
      initialRoute     : '/',
      routes: {
        '/'         : (_) => const SplashScreen(),
        '/login'    : (_) => const LoginScreen(),
        '/face-gate': (_) => const StartupFaceGateScreen(),
        '/home'     : (_) => const HomeScreen(),
        '/checkout' : (_) => const CheckoutScreen(),
        '/checkin'  : (_) => const CheckinScreen(),
        '/history'  : (_) => const HistoryScreen(),
      },
    );
  }
}
