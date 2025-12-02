import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tucky/Drawer/EinstellungLayout/theme_manager.dart';
import 'package:tucky/Screens/Authentifications/LogoFadeScreen.dart';
import 'package:tucky/Screens/Authentifications/auth_gate.dart';
import 'package:tucky/Screens/BudgetTracker/budget_tracker_layout.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeMode,
      builder: (context, themeMode, child) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          home: const LogoFadeScreen(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthGate(),
    );
  }
}
