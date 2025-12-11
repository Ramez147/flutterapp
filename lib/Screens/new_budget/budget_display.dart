import 'package:flutter/material.dart';
import 'package:tucky/Screens/new_budget/chart.dart';
import 'package:tucky/Screens/new_budget/transactions_fodler/transaction.dart';
import 'package:tucky/Screens/new_budget/transactions_fodler/transactions_datenbank.dart';
import 'package:tucky/Screens/new_budget/Months_folder/month_datenbank.dart';
class TwoCardsScreen extends StatefulWidget {
  const TwoCardsScreen({super.key});

  @override
  State<TwoCardsScreen> createState() => _TwoCardsScreenState();
}

class _TwoCardsScreenState extends State<TwoCardsScreen> {
  
  DateTime picked = DateTime.now();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TransactionDatenbank transactionDatabase = TransactionDatenbank();

  Stream<List<Transaction>> get _TransactionsStream {
    return transactionDatabase
        .getTransactions(picked.month)
        .asBroadcastStream();
  }

  void addNewTransaction() {
    _amountController.clear();
    _typeController.clear();
    _categoryController.clear();
    _descriptionController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Neue Transaktion hinzufügen',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CloseButton(),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _amountController,
                label: 'Betrag',
                icon: Icons.book,
                isRequired: true,
              ),
              _buildTextField(
                controller: _typeController,
                label: 'Typ',
                icon: Icons.person,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _categoryController,
                      label: 'Kategorie',
                      icon: Icons.school,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _descriptionController,
                      label: 'Beschreibung',
                      icon: Icons.description,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bitte geben Sie einen Betrag ein'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      final neutransaction = Transaction(
                        amount: double.tryParse(_amountController.text) ?? 0.0,
                        type: _typeController.text,
                        category: _categoryController.text,
                        description: _descriptionController.text,
                        monthId: picked.month,
                      );

                      await transactionDatabase.createTransaction(
                        neutransaction,
                      );

                      if (mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Transaktion erfolgreich hinzugefügt',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Fehler: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Transaktion hinzufügen',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  void saveBudget(double newBudget) async {
      print("updateBudget START");
    MonthDatenbank monthDatabase = MonthDatenbank();
    try {
      print("calling getMonthsById...");
      final months = await monthDatabase.getMonthsById(picked.month);
      print("months loaded: $months");
      if (months != null) {
        print("calling updateBudget DB...");
        await monthDatabase.updateBudget(months, newBudget.toDouble()); // updateModule -> updateBudget
        print("DB update done");
      }
    } catch (e) {
      print('Error updating budget: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Aktualisieren: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zwei Cards Layout'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        // Anpassung des Designs
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    this.picked = picked;
                  });
                }
              },

              child: Row(
                children: [
                  Text('${picked.day}/${picked.month}/${picked.year}'),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linke Card mit ListBuilder
            Expanded(
              flex: 2,
              child: Card(
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
                        'Liste der Elemente',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Budget für den ausgewählten Monat:"),

                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Geben Sie Ihr Budget ein',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        controller: budgetController,
                        onSubmitted: (value) {
                          final double? newBudget = double.tryParse(value);
                          if (newBudget != null) {
                            saveBudget(newBudget);
                            transactionDatabase.getChartData(picked.month);
                            
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Budget aktualisiert'),
                                ),
                              );
                            }
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ungültiger Budgetwert'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Column(
                          children: [
                            // Add Button
                            ElevatedButton.icon(
                              onPressed: () {
                                // Hier: Neues Element hinzufügen
                                addNewTransaction();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Element hinzugefügt'),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Transaktion hinzufügen'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // ListView
                            Expanded(
                              child: StreamBuilder<List<Transaction>>(
                                stream: _TransactionsStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (snapshot.hasError) {
                                    return Text('Fehler: ${snapshot.error}');
                                  }

                                  final transactions = snapshot.data!;

                                  if (transactions.isEmpty) {
                                    return const Text(
                                      'Keine Transaktionen gefunden.',
                                    );
                                  }

                                  return ListView.builder(
                                    itemCount: transactions.length,
                                    itemBuilder: (context, index) {
                                      final transaction = transactions[index];
                                      return ListTile(
                                        title: Text(transaction.amount.toString()),
                                        subtitle: Text(transaction.type),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue.shade100,
                                          child: Icon(
                                            Icons.monetization_on,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            transactionDatabase.deleteTransaction(transaction);
                                            if (mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Element gelöscht'),
                                                  backgroundColor: Colors.orange,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Rechte Card
            Expanded(
              flex: 1,
              child: ChartDiagram(
                monthId: picked.month,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


