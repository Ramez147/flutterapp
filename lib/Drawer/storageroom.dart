import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Storageroom extends StatefulWidget {
  const Storageroom({super.key});

  @override
  State<Storageroom> createState() => _StorageroomState();
}

class _StorageroomState extends State<Storageroom> {

  File? _imageFile;

  Future<void> _pickImage() async {
    // Implementiere die Logik zum Auswählen eines Bildes aus der Galerie oder Kamera
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future _saveImageToStorage(File image) async {
    if(_imageFile == null) return;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = '/storage/emulated/0/Storageroom/$fileName.png';
    await Supabase.instance.client.storage
        .from('images')
        .upload(path, image).then((value) =>SnackBar(content:Text('Bild erfolgreich gespeichert!')) );
  }
 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lagerraum'),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? const Text('Kein Bild ausgewählt.')
                : Image.file(_imageFile!),

            const SizedBox(height: 20),
             ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Bild auswählen'),
            ),
             ElevatedButton(
              onPressed: () {
                if (_imageFile != null) {
                  _saveImageToStorage(_imageFile!);
                }
              },
              child: const Text('Bild speichern'),
            ),  
          ],
        ),
      ),
    );
  }
}
