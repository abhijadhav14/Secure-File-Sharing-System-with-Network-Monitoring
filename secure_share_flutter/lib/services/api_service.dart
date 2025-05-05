import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000';

  static Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    return response.statusCode == 200 ? "success" : null;
  }

  static Future<String?> signup(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    return response.statusCode == 200 ? "success" : null;
  }

  static Future<bool> uploadFile(File file) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var res = await request.send();
    return res.statusCode == 200;
  }

  static Future<List<String>> getFiles() async {
  final response = await http.get(Uri.parse('$baseUrl/files'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<String>.from(data['files']);
  }
  return [];
}

static Future<void> downloadFile(String filename) async {
  // This is a placeholder – Flutter can’t download directly to filesystem without a plugin
  final url = Uri.parse('$baseUrl/download/$filename');
  print('Download URL: $url'); // You can open it in a browser or WebView
}

}
