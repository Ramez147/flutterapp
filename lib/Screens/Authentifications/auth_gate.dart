import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tucky/Screens/Authentifications/sign_in.dart';
import 'package:tucky/Screens/BudgetTracker/budget_tracker_layout.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // return  ToDo();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => StartSeite()),
              );
            });
            return Container(); // Leeres Container-Widget zurückgeben
          } else if (snapshot.hasError) {
            return const Center(child: Text('Etwas ist schief gelaufen!'));
          } else {
            return SignIn();
          }
        },
      );
  }
}