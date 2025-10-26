import 'package:flutter/material.dart';
// import 'package:tucky/Drawer/FileDownloaderVersuch/datei_open.dart';
import 'datei_open.dart';
// import 'package:tucky/Drawer/downloader_klasse.dart';
import 'datenschutz.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _darkMode = false;
  String _language = 'Deutsch';
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // Benachrichtigungen
          _buildSettingsSection(
            title: 'Benachrichtigungen',
            children: [
              SwitchListTile(
                title: Text('Push-Benachrichtigungen'),
                value: _notifications,
                onChanged: (value) {
                  setState(() {
                    _notifications = value;
                  });
                },
              ),
            ],
          ),

          // Darstellung
          _buildSettingsSection(
            title: 'Darstellung',
            children: [
              SwitchListTile(
                title: Text('Dark Mode'),
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
              ListTile(
                title: Text('Schriftgröße'),
                subtitle: Text('${_fontSize.toInt()} pt'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_fontSize > 12) _fontSize -= 1;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          if (_fontSize < 24) _fontSize += 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Sprache
          _buildSettingsSection(
            title: 'Sprache',
            children: [
              ListTile(
                title: Text('Sprache'),
                subtitle: Text(_language),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showLanguageDialog();
                },
              ),
            ],
          ),

          // Über die App
          _buildSettingsSection(
            title: 'Über die App',
            children: [
              ListTile(title: Text('Version'), subtitle: Text('1.0.0')),
              ListTile(
                title: Text('Datenschutz'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: SizedBox(width: 600, child: Datenschutz()),
                    ),
                  );

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => Datenschutz()),
                  // );
                },
              ),
              ListTile(
                title: Text('Nutzungsbedingungen'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  // FileDownloadService.downloadFile(context);
                  // FileDownloadService.shareFile(context);
                  // await FileDownloadService.downloadFile(context);
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
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sprache auswählen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Deutsch'),
                onTap: () {
                  setState(() {
                    _language = 'Deutsch';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('English'),
                onTap: () {
                  setState(() {
                    _language = 'English';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Français'),
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
