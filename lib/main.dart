// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:tucky/Seite/Seite_1/sign_in.dart';
// import 'package:tucky/Drawer/profil.dart';
// import 'package:tucky/Seite/Seite_1/first_page.dart';
// import 'package:tucky/Seite/Seite_1/sign_in.dart';
import 'package:tucky/Seite/Seite_2/second_page.dart';
import 'firebase_options.dart';
// import 'package:tucky/Drawer/drawer_build.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meine Webseite',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // Doppelpunkt statt Gleichheitszeichen
      //   title: const Text('Startseite'),
      //   backgroundColor: Color.fromARGB(255, 239, 195, 202),
      // ),
      // body: StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasData) {
      //       // return  ToDo();
      //       WidgetsBinding.instance.addPostFrameCallback((_) {
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(builder: (context) => ToDo()),
      //         );
      //       });
      //       return Container(); // Leeres Container-Widget zurückgeben
      //     } else if (snapshot.hasError) {
      //       return const Center(child: Text('Etwas ist schief gelaufen!'));
      //     } else {
      //       return SignIn();
      //     }
      //   },
      // ),
      body: ToDo(),
    );
  }
}
