import 'package:tucky/Screens/new_budget/transactions_fodler/transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionDatenbank {
  final SupabaseClient _client = Supabase.instance.client;
 


  Future<void> createTransaction(Transaction newTransaction) async {
    try {
      final map = newTransaction.toMap();

      await _client.from('transaction').insert(map);

      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      rethrow;
    }
  }
Stream<List<Transaction>> getTransactionsByMonthID(int monthId) => 
  Supabase.instance.client
    .from('transaction')
    .stream(primaryKey: ['id'])
    .eq('monthId', monthId)
    .map((data) => data
        .whereType<Map<String, dynamic>>()
        .map((m) => Transaction.fromMap(m))
        .toList());

  Stream<List<Transaction>> get stream {
    return _client.from('transaction').stream(primaryKey: ['id']).map((data) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((m) => Transaction.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    });
  }

  Stream<List<Transaction>> get allTransactionsStream {
    return _client.from('transaction').stream(primaryKey: ['id']).map((data) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((m) => Transaction.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    });
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    try {
      if (transaction.id == null) {
        throw ArgumentError('Transaction ID cannot be null');
      }
      await _client.from('transaction').delete().eq('id', transaction.id!);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Transaction>> getTransactions(int monthId) {
    return _client
      .from('transaction')
        .stream(primaryKey: ['id'])
        .eq('monthId', monthId)
        .map((data) {
          return data
              .whereType<Map<String, dynamic>>()
              .map((m) => Transaction.fromMap(Map<String, dynamic>.from(m)))
              .toList();
        });
  }

  Stream<List<Map<String, dynamic>>> getChartData(int monthId) {
    return _client
        .from('transaction')
        .stream(primaryKey: ['id'])
        .eq('monthId', monthId)
        .asyncMap((data) async {
      // Budget jedes Mal neu holen, nicht nur einmal
      final monthlyBudget = await _fetchMonthlyBudget(monthId);
      
      final transactions = data
          .whereType<Map<String, dynamic>>()
          .where((m) => m['category'] != null && m['category'] != '')
          .map((m) => Transaction.fromMap(Map<String, dynamic>.from(m)))
          .toList();

      return _calculateChartData(transactions, monthlyBudget);
    });
  }

  Future<double> _fetchMonthlyBudget(int monthId) async {
    final response = await _client
        .from('Month')
        .select('monthlyBudget')
        .eq('id', monthId)
        .single();

    final budgetValue = response['monthlyBudget'];
    if (budgetValue is num) {
      return budgetValue.toDouble();
    }

    throw StateError('MonthlyBudget not found for monthId=$monthId');
  }

  List<Map<String, dynamic>> _calculateChartData(
    List<Transaction> transactions,
    double monthlyBudget,
  ) {
    final Map<String, double> categorySums = {};
    final double totalAmount = transactions.fold(
      0.0,
      (sum, transaction) => sum + transaction.amount,
    );
    final double remainingBudget = monthlyBudget - totalAmount;

    for (final transaction in transactions) {
      categorySums.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }
    categorySums.update(
      'Übrig',
      (value) => value + remainingBudget,
      ifAbsent: () => remainingBudget,
    );

    return categorySums.entries.map((entry) {
      final percentage = monthlyBudget <= 0
          ? 0.0
          : (entry.value / monthlyBudget) * 100;
      return {
        'category': entry.key,
        'percentage': percentage,
        'amount': entry.value,
        'budget': monthlyBudget,
      };
    }).toList();
  }
  
  // Neue Methode: Chart-Daten als Text für Chatbot formatieren
  Future<String> getChartDataAsText(int monthId) async {
    try {
      final response = await _client
          .from('transaction')
          .select()
          .eq('monthId', monthId);
      
      final transactions = (response as List)
          .map((e) => Transaction.fromMap(e))
          .toList();
      
      final monthlyBudget = await _fetchMonthlyBudget(monthId);
      
      final totalSpent = transactions.fold(
        0.0,
        (sum, t) => sum + t.amount,
      );
      
      final buffer = StringBuffer();
      buffer.writeln('📊 Finanzübersicht Monat $monthId');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln('💰 Budget: ${monthlyBudget.toStringAsFixed(2)}€');
      buffer.writeln('💸 Ausgegeben: ${totalSpent.toStringAsFixed(2)}€');
      buffer.writeln('📈 Verbleibend: ${(monthlyBudget - totalSpent).toStringAsFixed(2)}€');
      buffer.writeln('\n📋 Transaktionen nach Kategorie:');
      
      final categoryMap = <String, double>{};
      for (final t in transactions) {
        categoryMap[t.category] = (categoryMap[t.category] ?? 0) + t.amount;
      }
      
      categoryMap.forEach((category, amount) {
        buffer.writeln('  • $category: ${amount.toStringAsFixed(2)}€');
      });
      
      return buffer.toString();
    } catch (e) {
      return 'Fehler beim Laden der Daten: $e';
    }
  }
  

  // Future<String> getChartDataAsText(int monthId) async {
  //   try {
  //     final response = await _client
  //         .from('transaction')
  //         .select()
  //         .eq('monthId', monthId);
      
  //     final transactions = (response as List)
  //         .map((e) => Transaction.fromMap(e as Map<String, dynamic>))
  //         .toList();
      
  //     final categoryMap = <String, double>{};
  //     for (final t in transactions) {
  //       categoryMap[t.category] = (categoryMap[t.category] ?? 0) + t.amount;
  //     }
      
  //     final totalSpent = categoryMap.values.fold(0.0, (sum, amount) => sum + amount);
      
  //     final buffer = StringBuffer();
  //     buffer.writeln('📊 Finanzübersicht Monat $monthId:');
  //     buffer.writeln('💰 Gesamtausgaben: ${totalSpent.toStringAsFixed(2)}€');
  //     buffer.writeln('📋 Kategorien:');
      
  //     categoryMap.forEach((category, amount) {
  //       buffer.writeln('$category: ${amount.toStringAsFixed(2)}€');
  //     });
      
  //     return buffer.toString();
  //   } catch (e) {
  //     return 'Fehler beim Laden: $e';
  //   }
  // }


}

