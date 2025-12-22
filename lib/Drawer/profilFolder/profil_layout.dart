import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tucky/Drawer/profilFolder/profil_datenbank.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final profil_datenbank = ProfilDatenbank();
  String? selectedGender;
  File? selectedImage;
  // final ImagePicker _picker = ImagePicker();

  // TextEditingController für die TextFields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  // Vereinfachte Geschlechter-Liste
  final List<String> genders = [
    'Männlich',
    'Weiblich',
    'Divers',
    'Keine Angabe',
  ];

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

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    try {
      final existingProfile = await profil_datenbank.getProfilById(this.widget.key.toString());
      if (existingProfile != null) {
        setState(() {
          nameController.text = existingProfile.username;
          streetController.text = existingProfile.adresse;
          zipController.text = existingProfile.plz.toString();
          cityController.text = existingProfile.ort;
          selectedGender = existingProfile.geschlecht;
        });
      }
    } catch (e) {
      _showSnackbar('Fehler beim Laden des Profils: $e');
    }
  }

  void _selectPokemonImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Pokémon auswählen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[700],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: pokemonImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPokemonImage = pokemonImages[index];
                          selectedImage = null;
                        });
                        Navigator.of(context).pop();
                        _showSnackbar('Avatar ausgewählt');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedPokemonImage == pokemonImages[index]
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                        child: Image.asset(
                          pokemonImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage() {
    setState(() {
      selectedPokemonImage = null;
      selectedImage = null;
    });
    _showSnackbar('Profilbild entfernt');
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('Fehler') ? Colors.red : Colors.green,
      ),
    );
  }

  // Vereinfachte Hilfsmethode für Text-Felder
  Widget _buildSimpleField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }

  // Vereinfachte Geschlecht-Auswahl
  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Geschlecht',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: selectedGender,
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text('Bitte wählen...'),
            items: genders.map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    streetController.dispose();
    zipController.dispose();
    super.dispose();
  }

  // Future<void> _submitProfile() async {
  //   // Validierung
  //   if (nameController.text.isEmpty ||
  //       streetController.text.isEmpty ||
  //       zipController.text.isEmpty ||
  //       cityController.text.isEmpty ||
  //       selectedGender == null) {
  //     _showSnackbar('Bitte alle Felder ausfüllen');
  //     return;
  //   }

  //   // PLZ Validierung
  //   final plz = int.tryParse(zipController.text);
  //   if (plz == null) {
  //     _showSnackbar('Bitte eine gültige Postleitzahl eingeben');
  //     return;
  //   }

  //   try {
  //     // Erstelle neues Profil
  //     final newProfil = Profil(
  //       id: 1, // oder generiere eine ID
  //       username: nameController.text,
  //       adresse: streetController.text,
  //       plz: plz,
  //       ort: cityController.text,
  //       geschlecht: selectedGender!,
  //     );
      
  //     await profil_datenbank.insertProfil(newProfil);
  //     _showSnackbar('Profil gespeichert');
  //   } catch (e) {
  //     _showSnackbar('Fehler: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.pink[50],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profilbild Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Profilbild
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : selectedPokemonImage != null
                            ? AssetImage(selectedPokemonImage!)
                            : const AssetImage('assets/images/placeholder.png')
                                as ImageProvider,
                    backgroundColor: Colors.grey[200],
                    child: selectedImage == null && selectedPokemonImage == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Bild-Auswahl Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // _buildImageButton(
                      //   Icons.library_add,
                      //   'Kamera',
                      //   _selectPhotoFromGallery,
                      // ),
                      _buildImageButton(
                        Icons.photo_library,
                        'Avatar',
                        _selectPokemonImage,
                      ),
                      _buildImageButton(
                        Icons.delete,
                        'Löschen',
                        (selectedImage != null || selectedPokemonImage != null)
                            ? _removeImage
                            : null,
                        isDelete: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Formular Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSimpleField('Vor- und Nachname', nameController),
                  const SizedBox(height: 12),
                  _buildSimpleField('Straße und Hausnummer', streetController),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSimpleField('Postleitzahl', zipController),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSimpleField('Wohnort', cityController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildGenderSelection(),

                  // Ausgewähltes Geschlecht anzeigen
                  if (selectedGender != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Ausgewählt: $selectedGender',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Freature ist in Entwicklung!'),
                        backgroundColor: Colors.orange,),
                        
                      );
                    },
                    child: const Text(
                      'Speichern',
                      style: TextStyle(
                        fontSize: 16,
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
    );
  }

  Widget _buildImageButton(
    IconData icon,
    String text,
    VoidCallback? onPressed, {
    bool isDelete = false,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          iconSize: 28,
          color: isDelete ? Colors.red : Colors.blue,
          onPressed: onPressed,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isDelete ? Colors.red : Colors.blue,
          ),
        ),
      ],
    );
  }
}