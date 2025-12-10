import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChartDiagram extends StatefulWidget {
  const ChartDiagram({super.key});

  @override
  State<ChartDiagram> createState() => _ChartDiagramState();
}

class _ChartDiagramState extends State<ChartDiagram> {
  @override
  Widget build(BuildContext context) {
    return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      
                    ],
                  ),
                ),
              );
  }
}