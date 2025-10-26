import 'package:flutter/material.dart';

class Datenschutz extends StatelessWidget {
  const Datenschutz({super.key});

  Widget _buildPrivacyPoint(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Datenschutzinformationen',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPrivacyPoint(
              'Datenverarbeitung',
              'Wir verarbeiten Ihre Daten gemäß den geltenden Datenschutzbestimmungen.',
            ),
            const SizedBox(height: 12),
            _buildPrivacyPoint(
              'Datenweitergabe',
              'Ihre Daten werden nicht ohne Ihre Zustimmung an Dritte weitergegeben.',
            ),
            const SizedBox(height: 12),
            _buildPrivacyPoint(
              'Datensicherheit',
              'Wir setzen technische und organisatorische Maßnahmen ein, um Ihre Daten zu schützen.',
            ),
            const SizedBox(height: 12),
            _buildPrivacyPoint(
              'Rechte der Nutzer',
              'Sie haben das Recht auf Auskunft, Berichtigung und Löschung Ihrer Daten.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Verstanden',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
