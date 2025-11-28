import 'package:flutter/material.dart';

class TeamworkDialog extends StatelessWidget {
  const TeamworkDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Über Teamarbeit',
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
            _buildTeamworkPoint(
              'Gemeinsame Ziele',
              'Erfolgreiche Teams haben klare, gemeinsame Ziele, auf die alle hinarbeiten.',
            ),
            const SizedBox(height: 12),
            _buildTeamworkPoint(
              'Offene Kommunikation',
              'Regelmäßiger Austausch und transparente Kommunikation sind essentiell für den Teamerfolg.',
            ),
            const SizedBox(height: 12),
            _buildTeamworkPoint(
              'Vertrauen und Respekt',
              'Teamarbeit basiert auf gegenseitigem Vertrauen und respektvollem Umgang miteinander.',
            ),
            const SizedBox(height: 12),
            _buildTeamworkPoint(
              'Stärken nutzen',
              'Jedes Teammitglied bringt einzigartige Fähigkeiten ein - diese zu erkennen und zu nutzen ist entscheidend.',
            ),
            const SizedBox(height: 12),
            _buildTeamworkPoint(
              'Konstruktives Feedback',
              'Regelmäßiges Feedback hilft dem Team, sich kontinuierlich zu verbessern.',
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
    );
  }

  Widget _buildTeamworkPoint(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
