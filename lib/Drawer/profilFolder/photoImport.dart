// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// // class PhotoPickerScreen extends StatefulWidget {
// //   @override
// //   _PhotoPickerScreenState createState() => _PhotoPickerScreenState();
// // }

// class PhotoPickerScreenState  {
//   File? selectedImage;

//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImageFromGallery() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 80,
//       );
      
//       if (image != null) {
//         setState(() {
//           selectedImage = File(image.path);
//         });
//       }
//     } catch (e) {
//       print('Fehler beim Auswählen des Bildes: $e');
//     }
//   }

//   Future<void> _takePhotoWithCamera() async {
//     try {
//       final XFile? photo = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 80,
//       );
      
//       if (photo != null) {
//         setState(() {
//           selectedImage = File(photo.path);
//         });
//       }
//     } catch (e) {
//       print('Fehler beim Aufnehmen des Fotos: $e');
//     }
//   }
// }