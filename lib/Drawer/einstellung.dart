import 'package:flutter/material.dart';
import 'datei_open.dart';
import 'datenschutz.dart';
import 'font_size_manager.dart';
import 'theme_manager.dart'; // Die neue ThemeManager Klasse

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  String _language = 'Deutsch';

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
            Color backgroundColor = isDark ? Colors.grey[900]! : Colors.grey[50]!;
            Color cardColor = isDark ? Colors.grey[800]! : Colors.white;
            Color textColor = isDark ? Colors.white : Colors.black;
            Color subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;

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
                backgroundColor: isDark ? Colors.grey[800]! : Colors.blue,
                foregroundColor: Colors.white,
                elevation: isDark ? 0 : 2,
              ),
              body: ListView(
                children: [
                  // Benachrichtigungen
                  _buildSettingsSection(
                    title: 'Benachrichtigungen',
                    fontSize: fontSize,
                    backgroundColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    children: [
                      SwitchListTile(
                        title: Text(
                          'Push-Benachrichtigungen',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: textColor,
                          ),
                        ),
                        value: _notifications,
                        onChanged: (value) {
                          setState(() {
                            _notifications = value;
                          });
                        },
                        activeThumbColor: Colors.blue,
                      ),
                    ],
                  ),

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
                        activeThumbColor: Colors.blue,
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

                  // Vorschau Bereich
                  _buildPreviewSection(fontSize, cardColor, textColor, subtitleColor),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPreviewSection(double fontSize, Color cardColor, Color textColor, Color subtitleColor) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: cardColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vorschau',
              style: TextStyle(
                fontSize: fontSize * 1.1,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeManager.isDarkMode ? Colors.grey[700] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Überschrift',
                    style: TextStyle(
                      fontSize: fontSize * 1.3,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dies ist ein Beispieltext in der gewählten Schriftgröße.',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kleinerer Text',
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aktuelle Größe: ${fontSize.toInt()} pt',
              style: TextStyle(
                fontSize: fontSize * 0.9,
                color: subtitleColor,
              ),
            ),
          ],
        ),
      ),
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
            style: TextStyle(
              fontSize: fontSize * 1.1,
              color: textColor,
            ),
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
























// import 'package:flutter/material.dart';
// // import 'package:tucky/Drawer/FileDownloaderVersuch/datei_open.dart';
// import 'datei_open.dart';
// // import 'package:tucky/Drawer/downloader_klasse.dart';
// import 'datenschutz.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   bool _notifications = true;
//   bool _darkMode = false;
//   String _language = 'Deutsch';
//   double _fontSize = 16.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Einstellungen'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView(
//         children: [
//           // Benachrichtigungen
//           _buildSettingsSection(
//             title: 'Benachrichtigungen',
//             children: [
//               SwitchListTile(
//                 title: Text('Push-Benachrichtigungen'),
//                 value: _notifications,
//                 onChanged: (value) {
//                   setState(() {
//                     _notifications = value;
//                   });
//                 },
//               ),
//             ],
//           ),

//           // Darstellung
//           _buildSettingsSection(
//             title: 'Darstellung',
//             children: [
//               SwitchListTile(
//                 title: Text('Dark Mode'),
//                 value: _darkMode,
//                 onChanged: (value) {
//                   setState(() {
//                     _darkMode = value;
//                   });
//                 },
//               ),
//               ListTile(
//                 title: Text('Schriftgröße'),
//                 subtitle: Text('${_fontSize.toInt()} pt'),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.remove),
//                       onPressed: () {
//                         setState(() {
//                           if (_fontSize > 12) _fontSize -= 1;
//                         });
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.add),
//                       onPressed: () {
//                         setState(() {
//                           if (_fontSize < 24) _fontSize += 1;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // Sprache
//           _buildSettingsSection(
//             title: 'Sprache',
//             children: [
//               ListTile(
//                 title: Text('Sprache'),
//                 subtitle: Text(_language),
//                 trailing: Icon(Icons.arrow_forward_ios),
//                 onTap: () {
//                   _showLanguageDialog();
//                 },
//               ),
//             ],
//           ),

//           // Über die App
//           _buildSettingsSection(
//             title: 'Über die App',
//             children: [
//               ListTile(title: Text('Version'), subtitle: Text('1.0.0')),
//               ListTile(
//                 title: Text('Datenschutz'),
//                 trailing: Icon(Icons.arrow_forward_ios),
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => Dialog(
//                       child: SizedBox(width: 600, child: Datenschutz()),
//                     ),
//                   );

//                   // Navigator.of(context).push(
//                   //   MaterialPageRoute(builder: (context) => Datenschutz()),
//                   // );
//                 },
//               ),
//               ListTile(
//                 title: Text('Nutzungsbedingungen'),
//                 trailing: Icon(Icons.arrow_forward_ios),
//                 onTap: () async {
//                   // FileDownloadService.downloadFile(context);
//                   // FileDownloadService.shareFile(context);
//                   // await FileDownloadService.downloadFile(context);
//                   await FileDownloadService.downloadFile(
//                     context,
//                     assetPath: 'assets/documents/sample.pdf',
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsSection({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Card(
//       margin: EdgeInsets.all(8.0),
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[700],
//               ),
//             ),
//             SizedBox(height: 8),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   void _showLanguageDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Sprache auswählen'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: Text('Deutsch'),
//                 onTap: () {
//                   setState(() {
//                     _language = 'Deutsch';
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text('English'),
//                 onTap: () {
//                   setState(() {
//                     _language = 'English';
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text('Français'),
//                 onTap: () {
//                   setState(() {
//                     _language = 'Français';
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'datei_open.dart';
// import 'datenschutz.dart';
// import 'fontsizechanger.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   bool _notifications = true;
//   bool _darkMode = false;
//   String _language = 'Deutsch';

//   // ValueNotifier für Schriftgröße - wird global verwendet
//   final ValueNotifier<double> _fontSize = ValueNotifier<double>(16.0);

//   @override
//   void dispose() {
//     _fontSize.dispose(); // Wichtig für Cleanup
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<double>(
//       valueListenable: _fontSize,
//       builder: (context, fontSize, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text(
//               'Einstellungen',
//               style: TextStyle(fontSize: fontSize * 1.2), // AppBar Titel größer
//             ),
//             backgroundColor: Colors.blue,
//             foregroundColor: Colors.white,
//           ),
//           body: ListView(
//             children: [
//               // Benachrichtigungen
//               _buildSettingsSection(
//                 title: 'Benachrichtigungen',
//                 fontSize: fontSize,
//                 children: [
//                   SwitchListTile(
//                     title: Text(
//                       'Push-Benachrichtigungen',
//                       style: TextStyle(fontSize: fontSize),
//                     ),
//                     value: _notifications,
//                     onChanged: (value) {
//                       setState(() {
//                         _notifications = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),

//               // Darstellung
//               _buildSettingsSection(
//                 title: 'Darstellung',
//                 fontSize: fontSize,
//                 children: [
//                   SwitchListTile(
//                     title: Text(
//                       'Dark Mode',
//                       style: TextStyle(fontSize: fontSize),
//                     ),
//                     value: _darkMode,
//                     onChanged: (value) {
//                       setState(() {
//                         _darkMode = value;
//                       });
//                     },
//                   ),
//                   // _buildFontSizeControl(fontSize),
//                   // Vereinfachte SettingsPage - nur der relevante Teil
//                   ListTile(
//                     title: Text('Schriftgröße'),
//                     subtitle: Text('${GlobalFontSize.currentSize.toInt()} pt'),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.remove),
//                           onPressed:
//                               GlobalFontSize.decrease, // Einfacher Aufruf!
//                         ),
//                         Text('${GlobalFontSize.currentSize.toInt()}'),
//                         IconButton(
//                           icon: Icon(Icons.add),
//                           onPressed:
//                               GlobalFontSize.increase, // Einfacher Aufruf!
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               // Sprache
//               _buildSettingsSection(
//                 title: 'Sprache',
//                 fontSize: fontSize,
//                 children: [
//                   ListTile(
//                     title: Text(
//                       'Sprache',
//                       style: TextStyle(fontSize: fontSize),
//                     ),
//                     subtitle: Text(
//                       _language,
//                       style: TextStyle(fontSize: fontSize * 0.9),
//                     ),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       _showLanguageDialog(fontSize);
//                     },
//                   ),
//                 ],
//               ),

//               // Über die App
//               _buildSettingsSection(
//                 title: 'Über die App',
//                 fontSize: fontSize,
//                 children: [
//                   ListTile(
//                     title: Text(
//                       'Version',
//                       style: TextStyle(fontSize: fontSize),
//                     ),
//                     subtitle: Text(
//                       '1.0.0',
//                       style: TextStyle(fontSize: fontSize * 0.9),
//                     ),
//                   ),
//                   ListTile(
//                     title: Text(
//                       'Datenschutz',
//                       style: TextStyle(fontSize: fontSize),
//                     ),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => Dialog(
//                           child: SizedBox(
//                             width: 600,
//                             child: Datenschutz(
//                               customFontSize:
//                                   fontSize, // Schriftgröße übergeben
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   ListTile(
//                     title: Text(
//                       'Nutzungsbedingungen',
//                       style: TextStyle(fontSize: fontSize),
//                     ),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                     onTap: () async {
//                       await FileDownloadService.downloadFile(
//                         context,
//                         assetPath: 'assets/documents/sample.pdf',
//                       );
//                     },
//                   ),
//                 ],
//               ),

//               // Vorschau Bereich
//               // _buildPreviewSection(fontSize),
//             ],
//           ),
//         );
//       },
//     );
//   }

  // Schriftgrößen-Steuerung mit ValueNotifier
  // Widget _buildFontSizeControl(double currentFontSize) {
  //   return ListTile(
  //     title: Text('Schriftgröße', style: TextStyle(fontSize: currentFontSize)),
  //     subtitle: Text(
  //       '${currentFontSize.toInt()} pt',
  //       style: TextStyle(fontSize: currentFontSize * 0.9),
  //     ),
  //     trailing: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         IconButton(
  //           icon: Icon(Icons.remove, size: currentFontSize),
  //           onPressed: () {
  //             if (_fontSize.value > 12) {
  //               _fontSize.value -= 1; // ValueNotifier - kein setState nötig!
  //             }
  //           },
  //         ),
  //         Container(
  //           width: 40,
  //           alignment: Alignment.center,
  //           child: Text(
  //             '${currentFontSize.toInt()}',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: currentFontSize,
  //             ),
  //           ),
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.add, size: currentFontSize),
  //           onPressed: () {
  //             if (_fontSize.value < 24) {
  //               _fontSize.value += 1; // ValueNotifier - kein setState nötig!
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Vorschau Bereich um sofortige Änderungen zu sehen
  // Widget _buildPreviewSection(double fontSize) {
  //   return Card(
  //     margin: EdgeInsets.all(8.0),
  //     child: Padding(
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Vorschau',
  //             style: TextStyle(
  //               fontSize: fontSize * 1.1,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey[700],
  //             ),
  //           ),
  //           SizedBox(height: 12),
  //           Container(
  //             padding: EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: Colors.grey[100],
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Überschrift',
  //                   style: TextStyle(
  //                     fontSize: fontSize * 1.3,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 SizedBox(height: 8),
  //                 Text(
  //                   'Dies ist ein Beispieltext in der gewählten Schriftgröße.',
  //                   style: TextStyle(fontSize: fontSize),
  //                 ),
  //                 SizedBox(height: 4),
  //                 Text(
  //                   'Kleinerer Text',
  //                   style: TextStyle(
  //                     fontSize: fontSize * 0.8,
  //                     color: Colors.grey[600],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: 8),
  //           Text(
  //             'Aktuelle Größe: ${fontSize.toInt()} pt',
  //             style: TextStyle(
  //               fontSize: fontSize * 0.9,
  //               color: Colors.grey[600],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

//   Widget _buildSettingsSection({
//     required String title,
//     required double fontSize,
//     required List<Widget> children,
//   }) {
//     return Card(
//       margin: EdgeInsets.all(8.0),
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: fontSize * 1.1,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[700],
//               ),
//             ),
//             SizedBox(height: 8),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   void _showLanguageDialog(double fontSize) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Sprache auswählen',
//             style: TextStyle(fontSize: fontSize * 1.1),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: Text('Deutsch', style: TextStyle(fontSize: fontSize)),
//                 onTap: () {
//                   setState(() {
//                     _language = 'Deutsch';
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text('English', style: TextStyle(fontSize: fontSize)),
//                 onTap: () {
//                   setState(() {
//                     _language = 'English';
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text('Français', style: TextStyle(fontSize: fontSize)),
//                 onTap: () {
//                   setState(() {
//                     _language = 'Français';
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
