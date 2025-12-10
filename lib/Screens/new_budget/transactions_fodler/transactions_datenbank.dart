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

  Stream<List<Transaction>> get stream {
    return _client
        .from('transaction')
        .stream(primaryKey: ['id'])
        .map((data) {
          return data
              .whereType<Map<String, dynamic>>()
              .map((m) => Transaction.fromMap(Map<String, dynamic>.from(m)))
              .toList();
        });
  }

  Stream<List<Transaction>> get allTransactionsStream {
    return _client
        .from('transaction')
        .stream(primaryKey: ['id'])
        .map((data) {
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
}