import 'package:tucky/Screens/new_budget/transactions_fodler/transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionDatenbank {
  final SupabaseClient _client = Supabase.instance.client;
  //  final RealtimeChannel _channel = Supabase.instance.client.channel('public:transaction');

  // void startListening(int monthId, Function(List<Transaction>) onTransactionsUpdated) {
  //   _channel
  //       .onPostgresChanges(
  //         event: PostgresChangeEvent.all,
  //         schema: 'public',
  //         table: 'transaction',
  //         callback: (payload) {
  //           print('Real-time event received: ${payload.eventType}');
  //           getTransactionsByMonthID(monthId);
  //           onTransactionsUpdated(_handlePayload(payload, monthId));
  //         },
  //       )
  //       .subscribe();
  // }
  //  List<Transaction> _handlePayload(PostgresChangePayload payload, int monthId) {
  //   // This is a simplified example - you'd need to maintain state
  //   // or refetch based on the event type
  //   switch (payload.eventType) {
  //     case 'DELETE':
  //       // Remove the deleted item from your local list
  //       // payload.old contains the deleted record's data
  //       break;
  //     case 'INSERT':
  //       // Add new item to your local list
  //       break;
  //     case 'UPDATE':
  //       // Update existing item in your local list
  //       break;
  //     case PostgresChangeEvent.all:
  //       // TODO: Handle this case.
  //       throw UnimplementedError();
  //     case PostgresChangeEvent.insert:
  //       // TODO: Handle this case.
  //       throw UnimplementedError();
  //     case PostgresChangeEvent.update:
  //       // TODO: Handle this case.
  //       throw UnimplementedError();
  //     case PostgresChangeEvent.delete:
  //       // TODO: Handle this case.
  //       throw UnimplementedError();
  //   }
  //   return []; // Return updated list
  // }

  // // 4. Clean up when done (call when disposing your widget/page)
  // void stopListening() {
  //   _channel.unsubscribe();
  // }



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
  
}

