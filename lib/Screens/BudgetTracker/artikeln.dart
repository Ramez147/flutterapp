import 'package:flutter/material.dart';

class Artikel {
  final String titel;
  final double preis;
  final String kategorien;

  Artikel({required this.titel, required this.preis, required this.kategorien});
}

class ArtikelWidget extends StatelessWidget {
  final Artikel artikel;
  final VoidCallback onDelete;

  const ArtikelWidget({
    super.key,
    required this.artikel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(artikel.titel),
      subtitle: Text('${artikel.preis}€ , ${artikel.kategorien}'),
      leading: Icon(Icons.shopping_cart),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
