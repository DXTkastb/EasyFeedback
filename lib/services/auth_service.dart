import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkback/services/storage_service.dart';

class AuthService {
  AuthService._singleton();

  static final AuthService service = AuthService._singleton();

  Future<http.Response> _restCall(
      {Map<String, String>? headers, Object? body, required Uri uri}) async {
    Map<String, String> postHeaders = {'Content-Type': ' application/json'};
    if (headers != null) postHeaders.addAll(headers);
    return (await http.post(uri, headers: postHeaders, body: jsonEncode(body)));
  }

  Future<http.Response> userLoggedIn() async {
    var prefs = StorageService.service.sharedPreferences;
    String? token = prefs.getString("auth-token");
    if (token == null) return http.Response('{}', 403);
    Uri uri = Uri.parse("http://192.168.29.136:8080/check/user");
    try {
      var res = await _restCall(uri: uri, headers: {'auth-token': token});
      return res;
    } catch (e) {
      return http.Response('{}', 100);
    }
  }

  Future<http.Response> login(
      {required String phoneNumber, required String password}) async {
    Uri uri = Uri.parse("http://192.168.29.136:8080/user/login");
    return _restCall(uri: uri, body: {
      'user_phone_number': phoneNumber,
      'password': password,
    });
  }

  Future<http.Response> signup(
      {required String phoneNumber,
      required String password,
      required String username}) {
    Uri uri = Uri.parse("http://192.168.29.136:8080/user/signup");
    return _restCall(uri: uri, body: {
      'user_phone_number': phoneNumber,
      'password': password,
      'user_name': username
    });
  }

  Future<http.Response> checkUpi(String upi) async {
    Uri uri = Uri.parse("http://192.168.29.136:8080/check/upi");
    return http.post(uri,body: upi);
  }
}
