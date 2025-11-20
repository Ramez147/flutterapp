import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
// ignore: deprecated_member_use
import 'dart:html' as html; // Nur für Web

class FileDownloadService {
  static Future<void> downloadFile(BuildContext context) async {
    try {
      final url =
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
      final fileName = 'dummy.pdf';

      // Plattform-Check
      if (kIsWeb) {
        // Web-spezifischer Download
        await _downloadForWeb(url, fileName, context);
      } else {
        // Mobile/Desktop Download
        await _downloadForMobile(url, fileName, context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download fehlgeschlagen: $e')));
    }
  }

  static Future<void> _downloadForWeb(
    String url,
    String fileName,
    BuildContext context,
  ) async {
    try {
      // Für Web: Verwende die anchor-Methode
      // final anchor =
      html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = fileName
        ..click();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download gestartet')));
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _downloadForMobile(
    String url,
    String fileName,
    BuildContext context,
  ) async {
    // Berechtigungen nur für Mobile anfragen
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      Directory? downloadsDir;

      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir == null) {
        throw Exception('Could not access downloads directory');
      }

      final savePath = '${downloadsDir.path}/$fileName';

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Datei erfolgreich heruntergeladen'),
          action: SnackBarAction(
            label: 'Öffnen',
            onPressed: () => OpenFile.open(savePath),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speicherberechtigung verweigert')),
      );
    }
  }
}

























// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:html' as html; // Nur für Web

// class FileDownloadService {
//   static Future<void> downloadFile(BuildContext context) async {
//     try {
//       final url = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
//       final fileName = 'dummy.pdf';

//       if (kIsWeb) {
//         // Web Download - einfache Methode
//         html.window.open(url, '_blank');
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Download in neuem Tab geöffnet')),
//         );
//       } else {
//         // Mobile/Desktop Code hier...
//         _showNotSupportedMessage(context);
//       }
//     } catch (e) {
//       print("Download error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Download fehlgeschlagen: $e')),
//       );
//     }
//   }

//   static void _showNotSupportedMessage(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Diese Funktion ist nur im Web verfügbar')),
//     );
//   }
// }



















// // import 'package:path_provider/path_provider.dart';
// // import 'package:open_file/open_file.dart';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:dio/dio.dart';

// // class FileDownloadService {
// //   static Future<void> downloadFile(BuildContext context) async {
// //     try {
// //       // Berechtigungen anfragen
// //       Map<Permission, PermissionStatus> statuses = await [
// //         Permission.storage,
// //         // Permission.manageExternalStorage, // Optional, kann Probleme verursachen
// //       ].request();
      
// //       // Prüfe ob Berechtigungen erteilt wurden
// //       if (statuses[Permission.storage]!.isGranted) {
// //         final url = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
// //         final fileName = 'dummy.pdf';

// //         // Verwende Downloads-Verzeichnis statt temp
// //         Directory? downloadsDir;
        
// //         try {
// //           // Versuche das Downloads-Verzeichnis zu bekommen
// //           if (Platform.isAndroid) {
// //             downloadsDir = Directory('/storage/emulated/0/Download');
// //             if (!await downloadsDir.exists()) {
// //               // Fallback: Externes Speicherverzeichnis
// //               downloadsDir = await getExternalStorageDirectory();
// //             }
// //           } else {
// //             // Für iOS
// //             downloadsDir = await getApplicationDocumentsDirectory();
// //           }
          
// //           if (downloadsDir == null) {
// //             throw Exception('Could not access downloads directory');
// //           }
          
// //           final savePath = '${downloadsDir.path}/$fileName';
// //           print("Save path: $savePath");

// //           // Download mit Dio
// //           await Dio().download(
// //             url, 
// //             savePath, 
// //             onReceiveProgress: (received, total) {
// //               if (total != -1) {
// //                 print((received / total * 100).toStringAsFixed(0) + "%");
                
// //                 // Optional: Progress im UI anzeigen
// //                 // _showDownloadProgress(context, received, total);
// //               }
// //             },
// //           );

// //           print("File successfully downloaded to: $savePath");

// //           // Erfolgsmeldung anzeigen
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text('Datei erfolgreich heruntergeladen'),
// //               action: SnackBarAction(
// //                 label: 'Öffnen',
// //                 onPressed: () => OpenFile.open(savePath),
// //               ),
// //             ),
// //           );

// //           // Datei öffnen
// //           await OpenFile.open(savePath);

// //         } catch (e) {
// //           print("Directory access error: $e");
// //           // Fallback: Temporäres Verzeichnis
// //           await _downloadToTempDirectory(context, url, fileName);
// //         }
        
// //       } else {
// //         // Berechtigung verweigert
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Speicherberechtigung verweigert'),
// //             action: SnackBarAction(
// //               label: 'Einstellungen',
// //               onPressed: () => openAppSettings(),
// //             ),
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       print("Download error: $e");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Download fehlgeschlagen: $e')),
// //       );
// //     }
// //   }

// //   // Fallback Methode für temporäres Verzeichnis
// //   static Future<void> _downloadToTempDirectory(BuildContext context, String url, String fileName) async {
// //     try {
// //       final tempDir = await getTemporaryDirectory();
// //       final tempPath = '${tempDir.path}/$fileName';
// //       print("Using temp path: $tempPath");

// //       await Dio().download(
// //         url, 
// //         tempPath, 
// //         onReceiveProgress: (received, total) {
// //           if (total != -1) {
// //             print((received / total * 100).toStringAsFixed(0) + "%");
// //           }
// //         },
// //       );

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Datei im temporären Verzeichnis gespeichert'),
// //           action: SnackBarAction(
// //             label: 'Öffnen',
// //             onPressed: () => OpenFile.open(tempPath),
// //           ),
// //         ),
// //       );

// //       await OpenFile.open(tempPath);
// //     } catch (e) {
// //       print("Temp download error: $e");
// //       rethrow;
// //     }
// //   }
// // }
































// // // import 'package:path_provider/path_provider.dart';
// // // // import 'package:open_file/open_file.dart';
// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // // import 'package:dio/dio.dart';
// // // class FileDownloadService {
// // //     static Future<void> downloadFile(BuildContext context) async {
// // //       Map<Permission, PermissionStatus> statuses = await [
// // //         Permission.storage,
// // //         Permission.manageExternalStorage,
// // //       ].request();
// // //       if (statuses[Permission.storage]!.isGranted) {
// // //         final url = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
// // //         final fileName = 'dummy.pdf';

// // //         final tempDir = await getTemporaryDirectory();
// // //         final tempPath = '${tempDir.path}/$fileName';
// // //         print("tempPath: $tempPath");

// // //         // final file = File(tempPath);
// // //         final response = await HttpClient().getUrl(Uri.parse(url));
// // //         // final downloadedData =
// // //          await response.close();
// // //         try {
// // //           await Dio().download(url, tempPath, onReceiveProgress: (received, total) {
// // //             if (total != -1) {
// // //               print((received / total * 100).toStringAsFixed(0) + "%");
// // //             }
// // //           });
// // //         }
// // //         catch (e) {
// // //           print("Download error: $e");
// // //         }

// // //         //  final appDocDir = await getApplicationDocumentsDirectory();
// // //         // await downloadedData.pipe(file.openWrite());
// // //         // print("File downloaded to $tempPath");

// // //         // final appDocDir = await getApplicationDocumentsDirectory();
// // //         // final savedPath = '${appDocDir.path}/$fileName';
// // //         // await file.copy(savedPath);
// // //         // print(" is saved in $savedPath");

// // //       //   ScaffoldMessenger.of(context).showSnackBar(
// // //       //     SnackBar(content: Text('Datei heruntergeladen: $savedPath')),
// // //       //   );

// // //       //   OpenFile.open(savedPath);
// // //       // } else {
// // //       //   ScaffoldMessenger.of(context).showSnackBar(
// // //       //     SnackBar(content: Text('Speicherberechtigung verweigert')),
// // //       //   );
// // //       }





// // //     }

// // // }