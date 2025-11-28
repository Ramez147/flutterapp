import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

class FileDownloadService {
  // static Future<bool> _checkPermission() async {
  //   if (Platform.isAndroid) {
  //     final status = await Permission.storage.status;
  //     if (!status.isGranted) {
  //       final result = await Permission.storage.request();
  //       return result.isGranted;
  //     }
  //   }
  //   return true;
  // }

  // Einfache Download-Methode
  static Future<void> downloadFile(BuildContext context) async {
    try {
      // if (!await _checkPermission()) return;

      // PDF aus Assets laden
      final byteData = await rootBundle.load('assets/documents/sample.pdf');

      // Download-Pfad erstellen
      // final directory = await getDownloadsDirectory();
      final directory = await getApplicationDocumentsDirectory();
      final downloadPath = '${directory.path}/sample_downloaded.pdf';

      // Datei speichern
      final file = File(downloadPath);
      // await file.create(recursive: true);
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
      await OpenFile.open(downloadPath);

      // Erfolgsmeldung
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF wurde heruntergeladen'),
          action: SnackBarAction(
            label: 'Öffnen',
            onPressed: () => OpenFile.open(downloadPath),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download fehlgeschlagen: $e')));
    }
  }
}



































// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class AssetFileManager extends StatefulWidget {
//   @override
//   State<AssetFileManager> createState() => AssetFileManagerState();
// }

// class AssetFileManagerState extends State<AssetFileManager> {
  
//   bool isProcessing = false;
//   String currentAction = '';

//   Future<File> _getAssetAsFile() async {
//     final byteData = await rootBundle.load('assets/documents/sample.pdf');
//     final tempDir = await getTemporaryDirectory();
//     final file = File('${tempDir.path}/sample_${DateTime.now().millisecondsSinceEpoch}.pdf');
    
//     await file.writeAsBytes(
//       byteData.buffer.asUint8List(
//         byteData.offsetInBytes, 
//         byteData.lengthInBytes
//       )
//     );
    
//     return file;
//   }

//   Future<bool> _checkPermission() async {
//     if (Platform.isAndroid) {
//       final status = await Permission.storage.status;
//       if (!status.isGranted) {
//         final result = await Permission.storage.request();
//         return result.isGranted;
//       }
//     }
//     return true;
//   }

//   Future<void> saveToDownloads() async {
//     if (!await _checkPermission()) return;
    
//     setState(() {
//       isProcessing = true;
//       currentAction = 'Speichere Datei...';
//     });

//     try {
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
//     } finally {
//       setState(() {
//         isProcessing = false;
//         currentAction = '';
//       });
//     }
//   }
//   Future<void> shareAssetFile() async {
//     setState(() { isProcessing = true; });

//     try {
//       // Asset laden
//       final byteData = await rootBundle.load('assets/documents/sample.pdf');
      
//       // Temporäre Datei erstellen
//       final tempDir = await getTemporaryDirectory();
//       final tempFile = File('${tempDir.path}/sample.pdf');
      
//       await tempFile.writeAsBytes(
//         byteData.buffer.asUint8List(
//           byteData.offsetInBytes, 
//           byteData.lengthInBytes
//         )
//       );
      
//       // Datei teilen - KORREKTE METHODE
//       final box = context.findRenderObject() as RenderBox?;
      
//       // Share.shareXFiles
//       await Share.shareXFiles(
//         [XFile(tempFile.path)],
//         text: 'Hier ist das PDF Dokument',
//         subject: 'PDF Datei',
//         sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
//       );
      
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Fehler: $e')),
//       );
//     } finally {
//       setState(() { isProcessing = false; });
//     }
//   }








//   // Future<void> _shareFile() async {
//   //   setState(() {
//   //     isProcessing = true;
//   //     currentAction = 'Bereite Datei vor...';
//   //   });

//   //   try {
//   //     final file = await _getAssetAsFile();
//   //     await Share.shareFiles(
//   //       [file.path],
//   //       text: 'Mein PDF Dokument',
//   //     );
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Teilen fehlgeschlagen: $e')),
//   //     );
//   //   } finally {
//   //     setState(() {
//   //       isProcessing = false;
//   //       currentAction = '';
//   //     });
//   //   }
//   // }

//   Future<void> _openFile() async {
//     setState(() {
//       isProcessing = true;
//       currentAction = 'Öffne Datei...';
//     });

//     try {
//       final file = await _getAssetAsFile();
//       await OpenFile.open(file.path);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Öffnen fehlgeschlagen: $e')),
//       );
//     } finally {
//       setState(() {
//         isProcessing = false;
//         currentAction = '';
//       });
//     }
//   }
  

// }