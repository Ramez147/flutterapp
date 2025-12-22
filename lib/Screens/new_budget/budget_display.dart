// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tucky/Drawer/drawer_build_layout.dart';
import 'package:tucky/Screens/new_budget/chart.dart';
import 'package:tucky/Screens/new_budget/list_provider.dart';
import 'package:tucky/Screens/new_budget/transactions_fodler/transaction.dart';
import 'package:tucky/Screens/new_budget/transactions_fodler/transactions_datenbank.dart';
import 'package:tucky/Screens/new_budget/Months_folder/month_datenbank.dart';
import 'package:tucky/Screens/ChatBot/chatbot.dart';

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
  final Color primaryColor = const Color.fromARGB(255, 239, 195, 202);
  final Color secondaryColor = const Color.fromARGB(255, 250, 240, 242);
  final Color accentColor = const Color.fromARGB(255, 200, 150, 160);
  final Color textColor = const Color.fromARGB(255, 80, 60, 70);

  void addNewTransaction() {
    _amountController.clear();
    _typeController.clear();
    _categoryController.clear();
    _descriptionController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25),
          ),
          border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
        ),
        child: Padding(
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Neue Transaktion hinzufügen',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: textColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _amountController,
                  label: 'Betrag',
                  icon: Icons.attach_money,
                  isRequired: true,
                ),
                _buildTextField(
                  controller: _typeController,
                  label: 'Typ',
                  icon: Icons.category,
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
                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_amountController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Bitte geben Sie einen Betrag ein'),
                            backgroundColor: accentColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                            SnackBar(
                              content: const Text(
                                'Transaktion erfolgreich hinzugefügt',
                              ),
                              backgroundColor: Colors.green.withOpacity(0.8),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Fehler: $e'),
                              backgroundColor: Colors.red.withOpacity(0.8),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          'Transaktion hinzufügen',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRequired)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4),
              child: Text(
                '$label *',
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: !isRequired ? label : null,
                hintText: hintText,
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: primaryColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
              ),
              style: TextStyle(color: textColor),
              keyboardType: keyboardType,
              maxLines: maxLines,
            ),
          ),
        ],
      ),
    );
  }

  void saveBudget(double newBudget) async {
    MonthDatenbank monthDatabase = MonthDatenbank();
    try {
      final months = await monthDatabase.getMonthsById(picked.month);
      if (months != null) {
        await monthDatabase.updateBudget(
          months,
          newBudget.toDouble(),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Aktualisieren: $e'),
          backgroundColor: accentColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> sendDataToChatbot() async {
    try {
      final chartDataText = await transactionDatabase.getChartDataAsText(picked.month);
      
      if (!mounted) return;
      
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Chatbot(
            initialMessage: chartDataText,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Laden der Daten: $e'),
          backgroundColor: accentColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemListProvider>(
        context,
        listen: false,
      ).setMonthId(picked.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
        title: Text(
          'Budget',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.chat, color: primaryColor),
              onPressed: sendDataToChatbot,
              tooltip: 'An Chatbot senden',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
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
                        colorScheme: ColorScheme.light(
                          primary: primaryColor,
                          onPrimary: Colors.white,
                        ),
                        dialogBackgroundColor: secondaryColor,
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    this.picked = picked;
                  });
                  Provider.of<ItemListProvider>(
                    context,
                    listen: false,
                  ).setMonthId(picked.month);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, 
                    color: primaryColor, 
                    size: 18
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${picked.day}/${picked.month}/${picked.year}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: MyNavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showChatbotDialog(context);
        },
        backgroundColor: Color.fromARGB(255, 239, 195, 202),
        child: Icon(Icons.chat_bubble_outline),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linke Card mit ListBuilder
            Expanded(
              flex: 2,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: primaryColor.withOpacity(0.2), width: 1),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.list_alt,
                              color: primaryColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Liste der Elemente',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: primaryColor.withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Budget für den ausgewählten Monat:",
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Geben Sie Ihr Budget ein',
                                labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                                prefixIcon: Icon(Icons.account_balance_wallet, 
                                  color: primaryColor
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: primaryColor, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              controller: budgetController,
                              style: TextStyle(color: textColor),
                              onSubmitted: (value) {
                                final double? newBudget = double.tryParse(value);
                                if (newBudget != null) {
                                  saveBudget(newBudget);
                                  transactionDatabase.getChartData(picked.month);

                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Budget aktualisiert'),
                                        backgroundColor: primaryColor,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Ungültiger Budgetwert'),
                                        backgroundColor: accentColor,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    primaryColor,
                                    primaryColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: addNewTransaction,
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const Text(
                                  'Transaktion hinzufügen',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // ListView
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: secondaryColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: StreamBuilder<List<Transaction>>(
                                  stream: Provider.of<ItemListProvider>(
                                    context,
                                  ).itemsStream,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      );
                                    }
                                    final transactions = snapshot.data!;

                                    if (transactions.isEmpty) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.receipt_long,
                                              size: 60,
                                              color: primaryColor.withOpacity(0.4),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Keine Transaktionen gefunden.',
                                              style: TextStyle(
                                                color: textColor.withOpacity(0.5),
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    return ListView.separated(
                                      itemCount: transactions.length,
                                      separatorBuilder: (context, index) => Divider(
                                        color: primaryColor.withOpacity(0.1),
                                        height: 8,
                                      ),
                                      itemBuilder: (context, index) {
                                        final transaction = transactions[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.05),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          margin: const EdgeInsets.only(bottom: 6),
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            leading: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: primaryColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.monetization_on,
                                                color: primaryColor,
                                              ),
                                            ),
                                            title: Text(
                                              '${transaction.amount.toString()} €',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                            subtitle: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${transaction.type} - ${transaction.category}',
                                                  style: TextStyle(
                                                    color: textColor.withOpacity(0.6),
                                                  ),
                                                ),
                                                // if (transaction.category.isNotEmpty)
                                                //   Text(
                                                //     transaction.category,
                                                //     style: TextStyle(
                                                //       color: textColor.withOpacity(0.5),
                                                //       fontSize: 12,
                                                //     ),
                                                //   ),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                              onPressed: () {
                                                final provider =
                                                    Provider.of<ItemListProvider>(
                                                      context,
                                                      listen: false,
                                                    );
                                                provider.removeItem(transaction);
                                                if (mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                        'Element gelöscht',
                                                      ),
                                                      backgroundColor: Colors.orange,
                                                      behavior: SnackBarBehavior.floating,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
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

            const SizedBox(width: 20),

            // Rechte Card
            Expanded(
              flex: 1, 
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: primaryColor.withOpacity(0.2), width: 1),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.pie_chart,
                              color: primaryColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Budget',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ChartDiagram(monthId: picked.month),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}