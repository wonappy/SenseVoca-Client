import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "http://{}:8080/api/users";

  //회원가입
  static Future<bool> pushSignUp(
    String email,
    String pw,
    String name,
    int interest,
  ) async {
    final url = Uri.parse('$baseUrl/signup');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // 꼭 필요함!
        },
        body: jsonEncode({
          'email': email,
          'password': pw,
          'nickName': name,
          'interestId': interest,
        }),
      );

      final dynamic result = jsonDecode(response.body);
      //회원가입 성공
      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('회원가입 성공 - ${result['message']}');
        }
        return true;
      } else {
        throw Exception('회원가입 실패 - ${result['message']}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('예외 발생: [pushSignUp] $e');
      }
      return false;
    }
  }
}
