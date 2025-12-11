import 'package:tucky/Screens/new_budget/Months_folder/month.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MonthDatenbank {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> createMonths(Months newMonths) async {
    try {
      final map = newMonths.toMap();

      await _client.from('Month').insert(map);
      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Months>> get stream {
    return _client.from('Month').stream(primaryKey: ['monthId']).map((data) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((m) => Months.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    });
  }

  Stream<List<Months>> get allMonthsStream {
    return _client.from('months').stream(primaryKey: ['']).map((data) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((m) => Months.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    });
  }

  Future<void> deleteMonths(Months months) async {
    try {
      if (months.id == null) {
        throw ArgumentError('Months ID cannot be null');
      }
      await _client.from('Month').delete().eq('id', months.id!);
    } catch (e) {
      rethrow;
    }
  }

  Future<Months?> getMonthsById(int id) async {
    try {
      print("getMonthsById: requesting id $id");
      final response = await _client
          .from('Month')
          .select()
          .eq('id', id)
          .single();
          print("getMonthsById: response = $response");
      return Months.fromMap(Map<String, dynamic>.from(response));
    } catch (e) {
      print("getMonthsById ERROR: $e");
      return null;
    }
  }

  Future<Months?> updateBudget(Months months, double newMonthlyBudget) async {
    if (months.id == null) {
      throw ArgumentError('Module ID cannot be null for update');
    }
    try {
      final response = await _client
          .from('Month')
          .update({'monthlyBudget': newMonthlyBudget})
          .eq('id', months.id!)
          .select()
          .single();
      print("Supabase response: $response");

      return Months.fromMap(Map<String, dynamic>.from(response));
    } catch (e) {
      // ignore: avoid_print
      print('updateModule error: $e');
      return null;
    }
  }
}
