import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:tucky/Seite/Seite_2/einkaeufediagramm.dart';
import 'package:tucky/Seite/Seite_2/budget_data.dart';

class Kreisdarstellung extends StatefulWidget {
  final int Budget;
  const Kreisdarstellung({super.key, required this.Budget});
  @override
  State<Kreisdarstellung> createState() => _KreisdarstellungState();
}

class _KreisdarstellungState extends State<Kreisdarstellung> {
  // late Map<String, double> _categoryTotals;
  late int budget = widget.Budget;

  @override
  void initState() {
    super.initState();
    // _calculateCategoryTotals(Einkaeufe.einkaeufe);
    // _categoryTotals = Map.from(Einkaeufe.categoryTotals);
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
      ),
      child: ValueListenableBuilder<Map<String, double>>(
        // valueListenable: Einkaeufe.categoryNotifier,
        valueListenable: budgetData.categoryNotifier,
        builder: (context, categoryTotals, child) {
          if (categoryTotals.isEmpty) {
            return Center(
              child: Text(
                'Keine Daten verfügbar',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          return PieChart(
            PieChartData(
              sections: categoryTotals.entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value,
                  color: _getColor(entry.key),
                  // title: '${entry.key}\n${((entry.value)/ budget).toStringAsFixed(2)}%',
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
    );
  }
}

















  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
  //     ),
  //     child: _categoryTotals.isEmpty
  //         ? Center(
  //             child: Text(
  //               'Keine Daten verfügbar',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(color: Colors.white, fontSize: 16),
  //             ),
  //           )
  //         : Center(
  //             child: ValueListenableBuilder<Map<String, double>>(
  //               valueListenable: Einkaeufe.categoryNotifier,
  //               builder: (context, categoryTotals, child) {
  //                 return PieChart(
  //                   PieChartData(
  //                     sections: categoryTotals.entries.map((entry) {
  //                       return PieChartSectionData(
  //                         value: entry.value, // Der Wert (Preis)
  //                         color: _getColor(
  //                           entry.key,
  //                         ), // Farbe basierend auf Kategorie
  //                         title:
  //                             '${entry.key}\n${entry.value.toStringAsFixed(2)}€',
  //                         radius: 60,
  //                         titleStyle: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.white,
  //                         ),
  //                       );
  //                     }).toList(),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //   );
  // }
