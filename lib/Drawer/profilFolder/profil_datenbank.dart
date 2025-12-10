import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tucky/Drawer/profilFolder/profil.dart';

class ProfilDatenbank {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> createProfil(Profil newProfil) async {
    try {
      final map = newProfil.toMap();

      await _client.from('profil').insert(map);

      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Profil>> get stream {
    return _client.from('profil').stream(primaryKey: ['id']).map((data) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((m) => Profil.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    });
  }

  Future<void> deleteProfil(Profil profil) async {
    try {
      await _client.from('profil').delete().eq('id', profil.id);
    } catch (e) {
      rethrow;
    }
  }

    Future<Profil?> getProfilById(String id) async {
    try {
      final response = await _client
          .from('profil')
          .select()
          .eq('id', id)
          .single();
      
      return Profil.fromMap(Map<String, dynamic>.from(response));
    } catch (e) {
      return null;
    }
  }

}
