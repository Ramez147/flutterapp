import 'package:flutter/foundation.dart';

class BudgetData extends ChangeNotifier {
  int _budget = 0;
  final ValueNotifier<Map<String, double>> _categoryNotifier = ValueNotifier<Map<String, double>>({});
  
  int get budget => _budget;
  ValueNotifier<Map<String, double>> get categoryNotifier => _categoryNotifier;
  
  void setBudget(int newBudget) {
    _budget = newBudget;
    notifyListeners(); // Notify für Budget-Änderungen
  }
  
  void updateCategoryTotals(Map<String, double> newTotals) {
    _categoryNotifier.value = newTotals;
    // notifyListeners() nicht nötig, da ValueNotifier sich selbst benachrichtigt
  }
}

final budgetData = BudgetData();