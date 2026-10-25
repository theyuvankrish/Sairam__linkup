// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'widgets/navigation/app_shell.dart';
import 'screens/auth/sign_in_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DemoProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => OpportunityProvider()),
        ChangeNotifierProvider(create: (_) => PeopleProvider()),
      ],
      child: const SairamLinkUpApp(),
    ),
  );
}

class SairamLinkUpApp extends StatelessWidget {
  const SairamLinkUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    final demo = context.watch<DemoProvider>();

    return MaterialApp(
      title: 'Sairam LinkUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: demo.isDark ? ThemeMode.dark : ThemeMode.light,
      home: demo.isSignedIn ? const AppShell() : const SignInScreen(),
    );
  }
}
