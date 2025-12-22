import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'datei_open.dart';
import 'datenschutz_layout.dart';
import 'font_size_manager.dart';
import 'theme_manager.dart'; // Die neue ThemeManager Klasse

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // bool _notifications = false;
  String _language = 'Deutsch';

  @override
  void initState() {
    super.initState();
    // _setupFirebase();
  }

  // final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  // Future<void> _setupFirebase() async {
  //   try {
  //     await _messaging.requestPermission(alert: true, badge: true, sound: true);
  //     final token = await _messaging.getToken();
  //     debugPrint('FCM Token: $token');
  //   } catch (e) {
  //     debugPrint('FCM init fehlgeschlagen: $e');
  //   }
  // }

  void _onSwitchChanged(bool value) async {
  setState(() {
    // _notifications = value;
  });
  
  // if (value) {
  //   // Benachrichtigungen aktivieren
  //   await _setupFirebase();
  // } else {
  //   // Benachrichtigungen deaktivieren
  //   await _messaging.deleteToken();
  //   await _messaging.unsubscribeFromTopic('all');
  // }
  
  // if (mounted) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(value 
  //         ? 'Push-Benachrichtigungen aktiviert'
  //         : 'Push-Benachrichtigungen deaktiviert'),
  //       backgroundColor: value ? Colors.green : Colors.grey,
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }
}

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeMode,
      builder: (context, themeMode, child) {
        return ValueListenableBuilder<double>(
          valueListenable: FontSizeManager.fontSize,
          builder: (context, fontSize, child) {
            // Farben basierend auf Theme
            bool isDark = themeMode == ThemeMode.dark;
            Color backgroundColor = isDark
                ? Colors.grey[900]!
                : Colors.grey[50]!;
            Color cardColor = isDark ? Colors.grey[800]! : Colors.white;
            Color textColor = isDark ? Colors.white : Colors.black;
            Color subtitleColor = isDark
                ? Colors.grey[400]!
                : Colors.grey[600]!;

            return Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                title: Text(
                  'Einstellungen',
                  style: TextStyle(
                    fontSize: fontSize * 1.2,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: isDark
                    ? Colors.grey[800]!
                    : Color.fromARGB(255, 239, 195, 202),
                foregroundColor: Colors.white,
                elevation: isDark ? 0 : 2,
              ),
              body: ListView(
                children: [
                  // Benachrichtigungen
                  // _buildSettingsSection(
                  //   title: 'Benachrichtigungen',
                  //   fontSize: fontSize,
                  //   backgroundColor: cardColor,
                  //   textColor: textColor,
                  //   subtitleColor: subtitleColor,
                  //   children: [
                  //     SwitchListTile(
                  //       title: Text(
                  //         'Push-Benachrichtigungen',
                  //         style: TextStyle(
                  //           fontSize: fontSize,
                  //           color: textColor,
                  //         ),
                  //       ),
                  //       value: _notifications,
                  //       onChanged: _onSwitchChanged, // Direkt die Methode übergeben, nicht setState wrappen
                  //       activeThumbColor: Color.fromARGB(255, 239, 195, 202),
                  //     ),
                  //   ],
                  // ),

                  // Darstellung
                  _buildSettingsSection(
                    title: 'Darstellung',
                    fontSize: fontSize,
                    backgroundColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    children: [
                      SwitchListTile(
                        title: Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: textColor,
                          ),
                        ),
                        value: isDark,
                        onChanged: (value) {
                          ThemeManager.toggleTheme(value);
                        },
                        activeThumbColor: Color.fromARGB(255, 239, 195, 202),
                      ),
                      ListTile(
                        title: Text(
                          'Schriftgröße',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          '${fontSize.toInt()} pt',
                          style: TextStyle(
                            fontSize: fontSize * 0.9,
                            color: subtitleColor,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                size: fontSize,
                                color: textColor,
                              ),
                              onPressed: FontSizeManager.decrease,
                            ),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                '${fontSize.toInt()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                  color: textColor,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                size: fontSize,
                                color: textColor,
                              ),
                              onPressed: FontSizeManager.increase,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Sprache
                  _buildSettingsSection(
                    title: 'Sprache',
                    fontSize: fontSize,
                    backgroundColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    children: [
                      ListTile(
                        title: Text(
                          'Sprache',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          _language,
                          style: TextStyle(
                            fontSize: fontSize * 0.9,
                            color: subtitleColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: fontSize,
                          color: textColor,
                        ),
                        onTap: () {
                          _showLanguageDialog(fontSize, textColor);
                        },
                      ),
                    ],
                  ),

                  // Über die App
                  _buildSettingsSection(
                    title: 'Über die App',
                    fontSize: fontSize,
                    backgroundColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    children: [
                      ListTile(
                        title: Text(
                          'Version',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          '1.0.0',
                          style: TextStyle(
                            fontSize: fontSize * 0.9,
                            color: subtitleColor,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Datenschutz',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: textColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: fontSize,
                          color: textColor,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Datenschutz(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Nutzungsbedingungen',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: textColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: fontSize,
                          color: textColor,
                        ),
                        onTap: () async {
                          await FileDownloadService.downloadFile(
                            context,
                            assetPath: 'assets/documents/sample.pdf',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required double fontSize,
    required Color backgroundColor,
    required Color textColor,
    required Color subtitleColor,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: backgroundColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: fontSize * 1.1,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(double fontSize, Color textColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isDark = ThemeManager.isDarkMode;

        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          title: Text(
            'Sprache auswählen',
            style: TextStyle(fontSize: fontSize * 1.1, color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Deutsch',
                  style: TextStyle(fontSize: fontSize, color: textColor),
                ),
                onTap: () {
                  setState(() {
                    _language = 'Deutsch';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(
                  'English',
                  style: TextStyle(fontSize: fontSize, color: textColor),
                ),
                onTap: () {
                  setState(() {
                    _language = 'English';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(
                  'Français',
                  style: TextStyle(fontSize: fontSize, color: textColor),
                ),
                onTap: () {
                  setState(() {
                    _language = 'Français';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
