class Profil {
  final int id;
   final String username;
   final String adresse;
   final int plz;
   final String ort;
   final String geschlecht;

  Profil({
    required this.id,
    required this.username,
    required this.adresse,
    required this.plz,
    required this.ort,
    required this.geschlecht,
  });

  factory Profil.fromMap(Map<String, dynamic> map) {
    return Profil(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      adresse: map['adresse'] ?? '',
      plz: map['plz']?.toInt() ?? 0,
      ort: map['ort'] ?? '',
      geschlecht: map['geschlecht'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'adresse': adresse,
      'plz': plz,
      'ort': ort,
      'geschlecht': geschlecht,
    };
  }
}
