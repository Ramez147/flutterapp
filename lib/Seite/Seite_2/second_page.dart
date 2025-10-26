import 'package:flutter/material.dart';
import 'package:tucky/Seite/Seite_2/einkaeufediagramm.dart';
import 'package:tucky/Seite/Seite_2/piechart.dart';
import 'package:tucky/Drawer/drawer_build.dart';
import 'package:tucky/Seite/Seite_2/budget_data.dart';
import 'package:tucky/Seite/Seite_2/rechner.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => ToDoState();
}

class ToDoState extends State<ToDo> {
  final TextEditingController budgetController = TextEditingController();
  int _budget = 0;

  void _addBudget() {
    if (budgetController.text.isEmpty) return;
    setState(() {
      _budget = int.parse(budgetController.text);
    });

    if (Einkaeufe.categoryNotifier.value.isNotEmpty) {
      // Erstelle eine Kopie mit aktualisierten Werten basierend auf neuem Budget
      final currentData = Map<String, double>.from(
        Einkaeufe.categoryNotifier.value,
      );
      Einkaeufe.categoryNotifier.value = currentData;
    }
    budgetData.setBudget(_budget);

    // budgetController.clear();
  }

  void _showCalculatorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CalculatorDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buget_Tracker'),
        backgroundColor: Color.fromARGB(255, 239, 195, 202),
        centerTitle: true,
      ),
      drawer: const MyNavigationDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              SizedBox(height: 100),
              SizedBox(
                width: 500,
                height: 100,

                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                    labelText: 'Enter deine Budget',
                    prefixIcon: Icon(Icons.wallet),
                    suffixIcon: Icon(Icons.euro_symbol),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                  controller: budgetController,
                ),
              ),
              // ...existing code...
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _addBudget,
                    child: Text('Set Budget', style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(width: 12),
                  IconButton(
                    onPressed: () => _showCalculatorDialog(context),
                    icon: Icon(Icons.calculate, size: 40, color: Colors.black),
                  ),
                ],
              ),

              SizedBox(height: 15),
              // Expanded entfernen und shrinkWrap hinzufügen
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent:
                      300, //_calculateHeight(context), // Responsive Höhe
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Einkaeufe(budget: _budget);
                  } else if (index == 1) {
                    return Kreisdarstellung(Budget: _budget);
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
