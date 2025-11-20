import 'package:flutter/material.dart';


class Storageroom extends StatefulWidget {
  const Storageroom({super.key});

  @override
  State<Storageroom> createState() => _StorageroomState();
}

class _StorageroomState extends State<Storageroom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lagerraum'),
      ),
      body: const Center(
        child: Text('Inhalt des Lagerraums'),
      ),
    );
  }
}
