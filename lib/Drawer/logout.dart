import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tucky/Screens/Authentifications/sign_in.dart';

class Logout {
  final BuildContext context;

  Logout(this.context);

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erfolgreich abgemeldet")));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignIn()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Fehler beim Abmelden: $error")));
    }
  }

  void deleteAccount() {}
}
