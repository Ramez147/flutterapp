import 'package:flutter/material.dart';
import 'package:tucky/Screens/Authentifications/auth_gate.dart';

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
    _startFadeAnimation();
  }

  void _startFadeAnimation() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      _opacity = 0.0;
    });
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthGate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _opacity,
          child: Image.asset(
            'assets/images/tucky.png',
            height: 350,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
