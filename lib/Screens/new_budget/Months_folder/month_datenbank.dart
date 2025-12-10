import 'package:tucky/Screens/new_budget/Months_folder/month.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DaysDatenbank {
  final SupabaseClient _client = Supabase.instance.client;
  
  Future<void> createMonths(Months newMonths) async {
    try {
      final map = newMonths.toMap();

      await _client.from('months').insert(map);
      await Future.delayed(Duration(milliseconds: 100));

    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Months>> get stream {
    return _client
        .from('months')
        .stream(primaryKey: ['monthId'])
        .map((data) {
          return data
              .whereType<Map<String, dynamic>>()
              .map((m) => Months.fromMap(Map<String, dynamic>.from(m)))
              .toList();
        });
  }

  Stream<List<Months>> get allMonthsStream {
    return _client
        .from('months')
        .stream(primaryKey: [''])
        .map((data) {
          return data
              .whereType<Map<String, dynamic>>()
              .map((m) => Months.fromMap(Map<String, dynamic>.from(m)))
              .toList();
        });
  }

  Future<void> deleteMonths(Months months) async {
    try {
      if (months.monthId == null) {
        throw ArgumentError('Months ID cannot be null');
      }
      await _client.from('months').delete().eq('monthId', months.monthId!);
    } catch (e) {
      rethrow;
    }
  }
}