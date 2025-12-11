import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tucky/Screens/new_budget/transactions_fodler/transactions_datenbank.dart';

class ChartDiagram extends StatefulWidget {
  const ChartDiagram({super.key, required this.monthId});

  final int monthId;

  @override
  State<ChartDiagram> createState() => _ChartDiagramState();
}

class _ChartDiagramState extends State<ChartDiagram> {
  TransactionDatenbank transactionDatabase = TransactionDatenbank();

  Stream<List<Map<String, dynamic>>> get _getChartData {
    return transactionDatabase.getChartData(widget.monthId);
  }

  Color _getColor(String category) {
    if (category == 'Übrig') {
      return Colors.green;
    }
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.deepOrange,
    ];

    int index = category.hashCode % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _getChartData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Fehler beim Laden',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final chartItems = snapshot.data ?? [];

            if (chartItems.isEmpty) {
              return Center(
                child: Text(
                  'Keine Daten verfügbar',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            // Map zu den benötigten Daten konvertieren
            final Map<String, double> categoryPercentages = {
              for (var item in chartItems)
                if (item['category'] != null && item['percentage'] != null)
                  item['category'] as String:
                      (item['percentage'] as num).toDouble(),
            };

            return PieChart(
              PieChartData(
                sections: categoryPercentages.entries.map((entry) {
                  return PieChartSectionData(
                    value: entry.value,
                    color: _getColor(entry.key),
                    title: '${entry.key}\n${entry.value.toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
