import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String? selectedGender;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> genders = [
    'Männlich',
    'Weiblich',
    'Divers',
    'Keine Angabe',
    'Nicht-binär',
    'ladyboy',
    'Genderqueer',
    'Genderfluid',
    'Agender',
    'Bigender',
    'Demiboy',
    'Demigirl',
    'Androgyn',
    'Transmann',
    'Transfrau',
    'Two-Spirit',
    'Pangender',
    'Neutrois',
    'Genderflux',
    'Deminonbinary',
    'Intergeschlechtlich',
    'Aporagender',
    'Maverique',
    'Xenogender',
    'Polygender',
  ];

  // Future<void> _pickImageFromGallery() async {
  //   try {
  //     final XFile? image = await _picker.pickImage(
  //       source: ImageSource.gallery,
  //       maxWidth: 1800,
  //       maxHeight: 1800,
  //       imageQuality: 80,
  //     );

  //     if (image != null) {
  //       setState(() {
  //         selectedImage = File(image.path);
  //       });
  //     }
  //   } catch (e) {
  //     print('Fehler beim Auswählen des Bildes: $e');
  //     _showErrorSnackbar('Fehler beim Auswählen des Bildes');
  //   }
  // }
  String? selectedPokemonImage;

  final List<String> pokemonImages = [
    'assets/images/pokemon/butterfly.webp',
    'assets/images/pokemon/charizard.webp',
    'assets/images/pokemon/charmander.webp',
    'assets/images/pokemon/eevee.webp',
    'assets/images/pokemon/endynalos.webp',
    'assets/images/pokemon/ghost.webp',
    'assets/images/pokemon/lugia.webp',
    'assets/images/pokemon/myu.webp',
    'assets/images/pokemon/pikatchu.webp',
    'assets/images/pokemon/poketball.webp',
    'assets/images/pokemon/profile_picture.webp',
    'assets/images/pokemon/sadafa.webp',
    'assets/images/pokemon/sandak.webp',
  ];

  void _selectPokemonImage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pokémon auswählen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Pokémon Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemCount: pokemonImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPokemonImage = pokemonImages[index];
                            selectedImage =
                                null; // Entferne das File-Bild wenn Pokémon ausgewählt
                          });
                          Navigator.of(context).pop();
                          _showSuccessSnackbar('Pokémon ausgewählt');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  selectedPokemonImage == pokemonImages[index]
                                  ? Colors.blue
                                  : Colors.grey[300]!,
                              width:
                                  selectedPokemonImage == pokemonImages[index]
                                  ? 3
                                  : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              pokemonImages[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _takePhotoWithCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          selectedImage = File(photo.path);
        });
      }
    } catch (e) {
      print('Fehler beim Aufnehmen des Fotos: $e');
      _showErrorSnackbar('Fehler beim Aufnehmen des Fotos');
    }
  }

  void _removeImage() {
    setState(() {
      selectedPokemonImage = null;
    });
    _showSuccessSnackbar('Profilbild entfernt');
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profil Card mit weißem Hintergrund
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : selectedPokemonImage != null
                          ? AssetImage(selectedPokemonImage!)
                          : const AssetImage('assets/images/placeholder.png')
                                as ImageProvider,
                      backgroundColor: Colors.grey[300],
                      child:
                          selectedImage == null && selectedPokemonImage == null
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Icon Buttons für Foto-Auswahl
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          iconSize: 24,
                          color: Colors.blue,
                          onPressed: _takePhotoWithCamera,
                          tooltip: 'Foto aufnehmen',
                        ),
                        IconButton(
                          icon: const Icon(Icons.photo_library),
                          iconSize: 24,
                          color: Colors.blue,
                          onPressed: _selectPokemonImage,
                          tooltip: 'Aus Galerie auswählen',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          iconSize: 24,
                          color: Colors.red,
                          onPressed: selectedPokemonImage != null
                              ? _removeImage
                              : null,
                          tooltip: 'Profilbild entfernen',
                        ),
                      ],
                    ),

                    // Info Text
                    if (selectedImage == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Kein Profilbild ausgewählt',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Formular Card mit weißem Hintergrund
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Name & Surname',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Wohnort',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Straße & Hausnummer',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Postleitzahl',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dropdown für Geschlecht
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedGender,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: const Text(
                          'Geschlecht auswählen',
                          style: TextStyle(color: Colors.grey),
                        ),
                        items: genders.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(
                              gender,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                    if (selectedGender != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Text(
                          'Ausgewählt: $selectedGender',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
