import 'package:flutter/material.dart';
import 'package:tucky/Screens/BudgetTracker/artikeln.dart';
import 'package:tucky/Screens/BudgetTracker/artikeln_eingabe_dialog.dart';
// import 'package:tucky/Seite/Seite_2/second_page.dart';
import 'package:tucky/Screens/BudgetTracker/budget_data.dart';

class Einkaeufe extends StatefulWidget {
  final int budget;
  const Einkaeufe({super.key, required this.budget});
  static final ValueNotifier<Map<String, double>> categoryNotifier =
      ValueNotifier({});

  @override
  State<Einkaeufe> createState() => _EinkaeufeState();
}

class _EinkaeufeState extends State<Einkaeufe> {
  List<ArtikelWidget> einkaeufe = [];
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _preisController = TextEditingController();
  final TextEditingController _kategorieController = TextEditingController();
  final List<String> categories = [];
  void addArtikel() {
    // Funktion zum Hinzufügen eines Artikels
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          textController: _textController,
          preisController: _preisController,
          kategorieController: _kategorieController,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void saveNewTask() {
    setState(() {
      einkaeufe.add(
        ArtikelWidget(
          artikel: Artikel(
            titel: _textController.text,
            preis: double.tryParse(_preisController.text) ?? 0.0,
            kategorien: _kategorieController.text,
          ),
          onDelete:
              () {}, // Leerer Callback, wird in ListView.builder überschrieben
        ),
      );
    });
    calculateCategoryTotals();
    _textController.clear();
    _preisController.clear();
    _kategorieController.clear();
    Navigator.of(context).pop();
  }

  void calculateCategoryTotals() {
    Map<String, double> sums = {};

    for (var einkauf in einkaeufe) {
      String category = einkauf.artikel.kategorien;
      double price = einkauf.artikel.preis;

      sums[category] = (sums[category] ?? 0) + price;
    }

    // Berechne Gesamtausgaben
    double totalAusgaben = sums.values.fold(0, (sum, price) => sum + price);
    double uebrig = widget.budget - totalAusgaben;

    // Teile dann durch das Budget und berechne Prozent
    Map<String, double> percents = {};
    final budget = widget.budget > 0 ? widget.budget : 1;

    sums.forEach((category, price) {
      double pct = (price / budget) * 100;
      percents[category] = double.parse(pct.toStringAsFixed(2));
    });

    // Füge "Übrig" als eigene Kategorie hinzu
    if (uebrig > 0) {
      double uebrigPct = (uebrig / budget) * 100;
      percents['Übrig'] = double.parse(uebrigPct.toStringAsFixed(2));
    }
    budgetData.updateCategoryTotals(percents);
  }

  void deleteItem(int index) {
    setState(() {
      einkaeufe.removeAt(index);
    });
    calculateCategoryTotals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 249, 209, 243),
              Color.fromARGB(255, 239, 195, 202),
            ],
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: addArtikel,
                      icon: Icon(Icons.add, size: 50, color: Colors.black),
                      tooltip: 'Artikel hinzufügen',
                    ),
                    SizedBox(height: 10),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit, size: 50, color: Colors.black),
                      tooltip: 'Artikel bearbeiten',
                    ),
                    SizedBox(height: 10),
                    IconButton(
                      onPressed: () {
                        if (einkaeufe.isNotEmpty) {
                          deleteItem(
                            einkaeufe.length - 1,
                          ); // deletes the last item as an example
                        }
                      },
                      icon: Icon(Icons.delete, size: 50, color: Colors.black),
                      tooltip: 'Artikel löschen',
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                child: einkaeufe.isEmpty
                    ? Center(
                        child: Text(
                          'Keine Einkäufe vorhanden',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        itemCount: einkaeufe.length,
                        itemBuilder: (context, index) {
                          return
                          
                          ArtikelWidget(
                            artikel: einkaeufe[index].artikel,
                            onDelete: () =>
                                deleteItem(index), 
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
