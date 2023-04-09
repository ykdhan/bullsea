import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BSRequest {
  static String apiUrl = 'http://localhost:3000';

  static httpHeaders(String? token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers': 'Content-Type',
      'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE',
    };
  }

  static get(String url, Function? success) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final String token = prefs.getString('bsToken') ?? '';

    final response =
        await http.get(Uri.parse('$apiUrl/$url'), headers: httpHeaders(token));
    var decode = utf8.decode(response.bodyBytes);
    var decodeJson = jsonDecode(decode)['result'];

    if (response.statusCode == 200) {
      success!(decodeJson);
    } else {
      throw Exception('Request GET failed. $url');
    }
  }

  static post(String url, body, Function? success) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final String token = prefs.getString('bsToken') ?? '';

    final response = await http.post(Uri.parse('$apiUrl/$url'),
        headers: httpHeaders(token), body: jsonEncode(body));
    var decode = utf8.decode(response.bodyBytes);
    var decodeJson = jsonDecode(decode)['result'];

    if (response.statusCode == 200 || response.statusCode == 201) {
      return success!(decodeJson);
    } else {
      print('ERROR: $decodeJson');
      throw Exception('Request POST failed. ($url)');
    }
  }

  static delete(String url, Function? success) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final String token = prefs.getString('bsToken') ?? '';

    final response = await http.delete(Uri.parse('$apiUrl/$url'),
        headers: httpHeaders(token));

    var decode = utf8.decode(response.bodyBytes);
    var decodeJson = jsonDecode(decode)['result'];

    if (response.statusCode == 200 || response.statusCode == 201) {
      success!(decodeJson);
    } else {
      print('ERROR: $decodeJson');
      throw Exception('Request DELETE failed. ($url)');
    }
  }
}
