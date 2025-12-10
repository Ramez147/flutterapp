// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:tucky/lib/Seite/Seite_1/first_page.dart';
import 'EinstellungLayout/einstellung_layout.dart';
import 'about_us_layout.dart';
import 'logout.dart';
import 'storageroom.dart';
import 'package:tucky/Screens/ChatBot/chatbot.dart';
import 'package:tucky/Screens/BudgetTracker/budget_tracker_layout.dart';
import 'package:tucky/Drawer/profilFolder/profil.dart';
import 'package:tucky/Drawer/profil_delete.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 239, 195, 202)),
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
                MaterialPageRoute(builder: (context) => StartSeite()),
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
            leading: const Icon(Icons.storage_outlined),
            title: const Text('storage room'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Storageroom()),
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
            leading: const Icon(Icons.logout),
            title: const Text('abmelden'),
            onTap: () {
              Logout(context).logout();
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
