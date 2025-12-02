import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tucky/Screens/Authentifications/sign_in.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final usercontroller = TextEditingController();
  final passwortcontroller = TextEditingController();



  @override
  void dispose() {
    usercontroller.dispose();
    passwortcontroller.dispose();
    super.dispose();
  }

  Future<void> createUser() async {
    try {
      // final UserCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usercontroller.text.trim(),
        password: passwortcontroller.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler bei der Benutzererstellung: ${e.message}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/clouds.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              // Linke Seite: Bild
              crossAxisAlignment:
                  CrossAxisAlignment.center, // WICHTIG: In der Mitte vertikal
              children: [
                // Linke Seite: Bild
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      // Zentriere das Bild im Container
                      child: Container(
                        height: 200, // Feste Höhe oder responsive
                        width: 250, // Feste Breite oder responsive
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/tucky.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Vertikale Trennlinie
                Container(
                  width: 1,
                  height: MediaQuery.of(context).size.height * 0.6,
                  color: Colors.grey.withOpacity(0.3),
                ),

                // Rechte Seite: Formular
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(10, 21, 58, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),

                        // Benutzername Feld
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Benutzername/E-Mail',
                            hintText: 'Geben Sie Ihren Namen oder E-Mail ein',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: Colors.pink),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(10, 21, 58, 1),
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(Icons.person, color: Color.fromRGBO(10, 21, 58, 1)),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          controller: usercontroller,
                        ),
                        const SizedBox(height: 20),

                        // Passwort Feld
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Passwort',
                            hintText: 'Geben Sie Ihr Passwort ein',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: Color.fromRGBO(10, 21, 58, 1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(10, 21, 58, 1),
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(Icons.lock, color: Color.fromRGBO(10, 21, 58, 1)),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          obscureText: true,
                          controller: passwortcontroller,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: createUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(10, 21, 58, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            elevation: 5,
                          ),
                          child: Text(
                            'Registrieren',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Registrieren Link
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignIn(),
                              ),
                            );
                          },
                          child: Text(
                            'Bereits ein Konto? Jetzt anmelden',
                            style: TextStyle(
                              color: Color.fromRGBO(10, 21, 58, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
