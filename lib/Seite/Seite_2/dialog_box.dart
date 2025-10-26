import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final textController;
  final preisController;
  final kategorieController;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  const DialogBox({
    super.key,
    required this.textController,
    required this.preisController,
    required this.kategorieController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Artikel Titel',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: preisController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Preis',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: kategorieController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Kategorie',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logik zum Hinzufügen des Artikels
                onSave();
              },
              child: Text('Hinzufügen'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Logik zum Hinzufügen des Artikels
                onCancel();
              },
              child: Text('Abbrechen'),
            ),
          ],
        ),
      ),
    );
  }
}
