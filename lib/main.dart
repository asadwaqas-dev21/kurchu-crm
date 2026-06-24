import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/core/router/app_router.dart';
import 'package:crm_kurchudashboard/core/services/auth_service.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  configureDependencies();
  final authService = getIt<AuthService>();
  await authService.initialize();

  if (!authService.isLoggedIn()) {
    print('🔑 User not logged in, attempting auto-login...');
    // Auto-login with seeded admin credentials
    final success = await authService.login(
      'admin@kurchucrm.com',
      'Admin@123!',
    );
    print(success ? '✅ Auto-login SUCCESS!' : '❌ Auto-login FAILED!');
  } else {
    print('🔓 User already logged in!');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppColors.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          key: ValueKey(themeMode),
          debugShowCheckedModeBanner: false,
          title: 'Kurchu CRM',
          themeMode: themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF0F172A),
          ),
          routerConfig: appRouter,
        );
      },
    );
  }
}
