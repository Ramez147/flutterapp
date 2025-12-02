import 'package:flutter/material.dart';
import 'package:tucky/Screens/Authentifications/auth_gate.dart';
// import 'package:moduleverwaltung/screens/home_screen.dart';

class LogoFadeScreen extends StatefulWidget {
  const LogoFadeScreen({super.key});
  @override
  LogoFadeScreenState createState() => LogoFadeScreenState();
}

class LogoFadeScreenState extends State<LogoFadeScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    // Starte die Fade-Animation nach kurzer Verzögerung
    _startFadeAnimation();
  }

  void _startFadeAnimation() async {
    // Kurze Pause damit Logo sichtbar ist (z.B. 1 Sekunde)
    await Future.delayed(Duration(milliseconds: 1000));
    
    // Logo ausblenden
    setState(() {
      _opacity = 0.0;
    });
    
    // Warten bis Fade-Animation fertig ist, dann zur HomeScreen navigieren
    await Future.delayed(Duration(milliseconds: 500));
    
    // Zur Hauptseite navigieren (HomeScreen)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthGate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Oder deine gewünschte Hintergrundfarbe
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _opacity,
          child: Image.asset(
            'assets/images/tucky.png',
            height: 350, // Etwas größer für Splash Screen
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}