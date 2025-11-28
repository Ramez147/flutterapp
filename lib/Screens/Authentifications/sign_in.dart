import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tucky/Screens/Authentifications/sign_up.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isChecked = false; // Variable für Checkbox-Status
  final usercontroller = TextEditingController();
  final passwortcontroller = TextEditingController();

  void updateCheckbox(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  @override
  void dispose() {
    usercontroller.dispose();
    passwortcontroller.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (usercontroller.text.trim().isEmpty ||
        passwortcontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte füllen Sie alle Felder aus!')),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usercontroller.text.trim(),
        password: passwortcontroller.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login erfolgreich!')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login fehlgeschlagen: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/clouds.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(70.0),
                child: Stack(
                  children: [
                    // Weißer Hintergrund
                    Container(width: 250, height: 150, color: Colors.white),
                    // Bild darüber
                    Image.asset(
                      'assets/images/tucky.png',
                      width: 250,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                width: 300,

                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Benutzername',
                    hintText: 'Geben Sie Ihren Namen ein',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  controller: usercontroller,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Passwort',
                    hintText: 'Geben Sie Ihr Passwort ein',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  obscureText: true,
                  controller: passwortcontroller,
                ),
              ),
              const SizedBox(height: 10),
              // Variable für Checkbox-Status
              SizedBox(
                height: 40,
                width: 150,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(value: isChecked, onChanged: updateCheckbox),

                    const Text(
                      'Sign in page',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
                width: 40,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await login();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                    child: Text('Anmelden'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                width: 40,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                    child: Text('Gehe zu first page'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
