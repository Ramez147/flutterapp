import 'package:flutter/foundation.dart';
import 'package:tucky/Screens/new_budget/transactions_fodler/transactions_datenbank.dart';
import 'package:tucky/Screens/new_budget/transactions_fodler/transaction.dart';

class ItemListProvider extends ChangeNotifier {
  final TransactionDatenbank _datenbank = TransactionDatenbank();
  int? _currentMonthId;

  // Stream getter
  Stream<List<Transaction>> get itemsStream {
    if (_currentMonthId == null) {
      return Stream.value([]);
    }
    return _datenbank.getTransactionsByMonthID(_currentMonthId!);
  }

  // MonthId setzen
  void setMonthId(int monthId) {
    _currentMonthId = monthId;
    notifyListeners();
  }

  // Items hinzufügen
  Future<void> addItem(Transaction item) async {
    await _datenbank.createTransaction(item);
  }

  // Item entfernen
  Future<void> removeItem(Transaction tra) async {
    await _datenbank.deleteTransaction(tra);
    notifyListeners();
  }
}
