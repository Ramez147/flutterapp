import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  static const String apiKey = 'AIzaSyDmZtYmtHP54wAQWSs9AL2SgaP76nvG5kA';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        // ✅ KORREKT: API Key als Query Parameter
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
          // ❌ ENTFERNEN: 'Authorization' Header nicht bei Gemini!
        },
        body: jsonEncode({
          // ✅ KORREKT: Gemini JSON Struktur
          'contents': [
            {
              'parts': [
                {'text': message}, // ✅ Einfach "text" nicht "content"
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // ✅ KORREKT: Gemini Response Parsing
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Fehler: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Verbindungsfehler: $e';
    }
  }
}


































// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ChatService {
//   static const String apiUrl = 'https://api.openai.com/v1/chat/completions';
//   // DEIN persönlicher Key - hier einsetzen!
//   static const String apiKey = 'sk-proj-gI1mhyDRPM1rv-7Konglc03g4Fuk9ncBeEtR40woFLmqVo2nxA2lw9ILHT6o-';
  
//   Future<String> sendMessage(String message) async {

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $apiKey',
//       },
//       body: jsonEncode({
//         'model': 'gpt-3.5-turbo',
//         'messages': [
//           {'role': 'user', 'content': message}
//         ],
//       }),
//     );
    
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['choices'][0]['message']['content'];
//     } else {
//       throw Exception('Failed to load response');
//     }
//   }
// }