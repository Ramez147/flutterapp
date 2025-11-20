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
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Datenschutzerklärung',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrivacyPoint(
              '1. Datenverarbeitung',
              'Wir verarbeiten Ihre personenbezogenen Daten ausschließlich im Rahmen der gesetzlichen Bestimmungen der DSGVO und des BDSG.',
            ),
            _buildPrivacyPoint(
              '2. Erhobene Daten',
              'Wir erfassen nur die Daten, die für die Bereitstellung unserer Dienstleistungen notwendig sind. Dies umfasst Name, E-Mail-Adresse und bei Bedarf weitere Kontaktdaten.',
            ),
            _buildPrivacyPoint(
              '3. Datenweitergabe',
              'Ihre Daten werden nicht ohne Ihre ausdrückliche Zustimmung an Dritte weitergegeben. Ausnahmen gelten nur bei gesetzlichen Verpflichtungen.',
            ),
            _buildPrivacyPoint(
              '4. Datensicherheit',
              'Wir setzen moderne Verschlüsselungstechnologien und Sicherheitsmaßnahmen ein, um Ihre Daten vor unbefugtem Zugriff zu schützen.',
            ),
            _buildPrivacyPoint(
              '5. Ihre Rechte',
              'Sie haben jederzeit das Recht auf:\n• Auskunft über Ihre gespeicherten Daten\n• Berichtigung unrichtiger Daten\n• Löschung Ihrer Daten\n• Einschränkung der Verarbeitung\n• Datenübertragbarkeit\n• Widerspruch gegen die Verarbeitung',
            ),
            _buildPrivacyPoint(
              '6. Speicherdauer',
              'Ihre Daten werden nur so lange gespeichert, wie es für den jeweiligen Zweck erforderlich ist oder gesetzliche Aufbewahrungspflichten bestehen.',
            ),
            _buildPrivacyPoint(
              '7. Kontakt',
              'Bei Fragen zum Datenschutz kontaktieren Sie uns bitte unter:\nE-Mail: datenschutz@example.com',
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Stand: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}