// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// // import 'package:share_plus/share_plus.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class FileDownloadService {
  
//   // Private Methoden (nur innerhalb der Klasse)
//   // static Future<File> _getAssetAsFile() async {
//   //   final byteData = await rootBundle.load('assets/documents/sample.pdf');
//   //   final tempDir = await getTemporaryDirectory();
//   //   final file = File('${tempDir.path}/sample_${DateTime.now().millisecondsSinceEpoch}.pdf');
    
//   //   await file.writeAsBytes(
//   //     byteData.buffer.asUint8List(
//   //       byteData.offsetInBytes, 
//   //       byteData.lengthInBytes
//   //     )
//   //   );
    
//   //   return file;
//   // }

//   static Future<bool> _checkPermission() async {
//     if (Platform.isAndroid) {
//       final status = await Permission.storage.status;
//       if (!status.isGranted) {
//         final result = await Permission.storage.request();
//         return result.isGranted;
//       }
//     }
//     return true;
//   }

//   // Öffentliche Methoden (von überall aufrufbar)
//   static Future<void> saveToDownloads(BuildContext context) async {
//     try {
//       if (!await _checkPermission()) return;
      
//       final byteData = await rootBundle.load('assets/documents/sample.pdf');
//       final directory = await getExternalStorageDirectory();
//       final downloadsPath = '${directory?.path}/Download/sample.pdf';
      
//       final file = File(downloadsPath);
//       await file.create(recursive: true);
//       await file.writeAsBytes(
//         byteData.buffer.asUint8List(
//           byteData.offsetInBytes, 
//           byteData.lengthInBytes
//         )
//       );
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Datei gespeichert in Download-Ordner'),
//           action: SnackBarAction(
//             label: 'Öffnen',
//             onPressed: () => OpenFile.open(downloadsPath),
//           ),
//         ),
//       );
      
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Speichern fehlgeschlagen: $e')),
//       );
//     }
//   }

//   // static Future<void> shareFile(BuildContext context) async {
//   //   try {
//   //     final file = await _getAssetAsFile();
      
//   //     await Share.shareXFiles(
//   //       [XFile(file.path)],
//   //       text: 'Hier ist das PDF Dokument',
//   //       subject: 'PDF Datei',
//   //     );
      
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Teilen fehlgeschlagen: $e')),
//   //     );
//   //   }
//   // }

//   // static Future<void> openFile(BuildContext context) async {
//   //   try {
//   //     final file = await _getAssetAsFile();
//   //     await OpenFile.open(file.path);
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Öffnen fehlgeschlagen: $e')),
//   //     );
//   //   }
//   // }
// }