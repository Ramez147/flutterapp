import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  static const String apiKey = 'AIzaSyDNEBD-G0V9MbBWLT2ix39cAomsGZv8_Bs';

  Future<String> sendMessage(String message) async {
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