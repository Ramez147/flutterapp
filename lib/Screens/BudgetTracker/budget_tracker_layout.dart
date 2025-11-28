import 'package:flutter/material.dart';
import 'package:tucky/Screens/BudgetTracker/list_layout.dart';
import 'package:tucky/Screens/BudgetTracker/kreis_diagramm_layout.dart';
import 'package:tucky/Drawer/drawer_build_layout.dart';
import 'package:tucky/Screens/BudgetTracker/budget_data.dart';
import 'package:tucky/Screens/BudgetTracker/taschenrechner_layout.dart';
import 'package:tucky/Screens/ChatBot/chatbot.dart';

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

  void _showChatbotDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ClipRRect(
            // Wichtig: ClipRRect hinzufügen
            borderRadius: BorderRadius.circular(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Chatbot(),
            ),
          ),
        );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showChatbotDialog(context);
        },
        backgroundColor: Color.fromARGB(255, 239, 195, 202),
        child: Icon(Icons.chat_bubble_outline),
      ),
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
                    return Kreisdarstellung(budget: _budget);
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
