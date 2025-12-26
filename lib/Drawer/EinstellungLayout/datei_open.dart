// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:dio/dio.dart';
// ignore: deprecated_member_use
import 'dart:html' as html; // Nur für Web
import 'package:flutter/services.dart'; // Für Asset-Zugriff

class FileDownloadService {
  static Future<void> downloadFile(
    BuildContext context, {
    String assetPath = 'assets/documents/sample.pdf',
  }) async {
    try {
      final fileName = assetPath
          .split('/')
          .last; // Dateiname aus Pfad extrahieren

      // Plattform-Check
      if (kIsWeb) {
        // Web-spezifischer Download
        await _downloadForWeb(assetPath, fileName, context);
        
      } else {
        // Mobile/Desktop Download
        await _downloadForMobile(assetPath, fileName, context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download fehlgeschlagen: $e')));
    }
  }

  static Future<void> _downloadForWeb(
    String assetPath,
    String fileName,
    BuildContext context,
  ) async {
    try {
      // Für Web: Lade Asset als ByteData und erstelle Blob-URL
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Erstelle Blob und URL
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Erstelle Anchor-Element für Download
      // final anchor =
      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      // Räume URL auf
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download gestartet')));
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _downloadForMobile(
    String assetPath,
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

      // Lade Asset und schreibe in Datei
      try {
        final ByteData data = await rootBundle.load(assetPath);
        final Uint8List bytes = data.buffer.asUint8List();

        // Schreibe Bytes in Datei
        final File file = File(savePath);
        await file.writeAsBytes(bytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Datei erfolgreich heruntergeladen'),
            action: SnackBarAction(
              label: 'Öffnen',
              onPressed: () => OpenFile.open(savePath),
            ),
          ),
        );
      } catch (e) {
        throw Exception('Fehler beim Schreiben der Datei: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speicherberechtigung verweigert')),
      );
    }
  }
}
