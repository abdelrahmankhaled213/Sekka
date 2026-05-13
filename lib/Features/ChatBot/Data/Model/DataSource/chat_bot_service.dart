import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotService {
  static const String _baseUrl = 'https://sekkachatbot-production.up.railway.app';

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['reply'] as String;
      }
      throw Exception('API returned success: false');
    } else {
      throw Exception('Request failed: ${response.statusCode}');
    }
  }
}
