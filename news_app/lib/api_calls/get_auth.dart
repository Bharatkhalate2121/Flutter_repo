import 'dart:convert';

import 'package:http/http.dart' as http;

class GetAuth {
  static const String baseUrl = '192.168.90.210:3000';
  static const String loginPath = '/login';
  static const String registerPath = '/register';

  static Future<String?> login(Map<String, String> body) async {
    try {
      var endpoint = Uri.http(baseUrl, loginPath);
      var response = await http.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['token']);
        return jsonDecode(response.body)['token'];
      } else {
        print('${response.statusCode} : ${response.reasonPhrase}');
      }
    } catch (err) {
      print(err);
    }

    return null;
  }

  static Future<String?> register(Map<String, String> body) async {
    try {
      var endpoint = Uri.http(baseUrl, registerPath);
      var response = await http.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['token']);
        return jsonDecode(response.body)['token'];
      } else {
        print('${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (err) {
      print(err);
    }
    return null;
  }
}
