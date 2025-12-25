import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<String> sendMessage(String message) async {
    if (apiKey.isEmpty) {
      return 'Fehler: API-Schlüssel nicht konfiguriert. Bitte .env-Datei überprüfen.';
    }
    
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
          
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': message}, 
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Fehler: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Verbindungsfehler: $e';
    }
  }
}