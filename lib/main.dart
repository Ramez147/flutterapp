import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tucky/Drawer/EinstellungLayout/theme_manager.dart';
import 'package:tucky/Screens/Authentifications/logo_fade_screen.dart';
import 'package:tucky/Screens/new_budget/budget_display.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kwsteetnurtvvdhaxkwt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3c3RlZXRudXJ0dnZkaGF4a3d0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1OTUxODIsImV4cCI6MjA3OTE3MTE4Mn0.4EnhjoEizAj6UEVBh2XVKOnVVyCvUDiY_8r4Xdv4DcM',
  );

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
          home: const TwoCardsScreen(),
        );
      },
    );
  }
}


