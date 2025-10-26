// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:tucky/lib/Seite/Seite_1/first_page.dart';
import 'einstellung.dart';
import 'about_us.dart';
import 'logout.dart';
import 'package:tucky/Seite/Seite_3/third_page.dart';
import 'package:tucky/Seite/Seite_2/second_page.dart';
import 'package:tucky/Drawer/profilFolder/profil.dart';
import 'package:tucky/Drawer/profil_löschen.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Drawer gehört in Scaffold, nicht in AppBar!
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menü',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Startseite'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ToDo()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy),
            title: const Text('Chatbot'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chatbot()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Einstellungen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Über uns'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeamworkDialog()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('abmelden'),
            onTap: () {
              Logout(context).logout();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profil()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('löschen profil'),
            onTap: () {
              Delete(context).deleteAccount();
            },
          ),
        ],
      ),
    );
  }
}
