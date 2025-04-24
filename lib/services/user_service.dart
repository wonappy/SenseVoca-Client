import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sense_voka/models/api_response.dart';
import 'package:sense_voka/models/user_model.dart';

class UserService {
  // Create storage
  static final storage = FlutterSecureStorage();
  static const String baseUrl = "http://192.168.1.47:8080/api/users";

  //이메일 중복 확인
  static Future<ApiResponseModel> getCheckEmailDuplicate(String email) async {
    final url = Uri.parse('$baseUrl/check-email?email=$email');
    ApiResponseModel returnMsg;

    try {
      final response = await http.get(url);

      final dynamic result = jsonDecode(response.body);

      // print("🔥 [응답 상태] ${response.statusCode}");
      // print("🔥 [응답 본문] '${response.body}'");
      // print("🔥 [본문 길이] ${response.body.length}");

      //중복되지 않은 이메일
      if (response.statusCode == 200 && result['data'] == false) {
        if (kDebugMode) {
          print('사용 가능한 이메일 - ${result['message']}');
        }
        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "사용 가능한 이메일",
          msg: "${result['message']}",
        );
        return returnMsg;
      } else {
        if (kDebugMode) {
          print('${result['message']}');
        }
        returnMsg = ApiResponseModel(
          isSuccess: false,
          title: "이메일 확인 실패",
          msg: "${result['message']}",
        );
        return returnMsg;
      }
    } catch (e) {
      if (kDebugMode) {
        print('예외 발생: [getCheckEmailDuplicate] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //회원가입
  static Future<ApiResponseModel> postSignUp(
    String email,
    String pw,
    String name,
    int interest,
  ) async {
    final url = Uri.parse('$baseUrl/signup');
    ApiResponseModel returnMsg;

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
      if (response.statusCode == 201 && result['data'] == true) {
        if (kDebugMode) {
          print('회원가입 성공 - ${result['message']}');
        }
        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "회원가입 성공",
          msg: "${result['message']}",
        );
        return returnMsg;
      } else {
        if (kDebugMode) {
          print('회원가입 실패 - ${result['message']}');
        }
        returnMsg = ApiResponseModel(
          isSuccess: false,
          title: "회원가입 실패",
          msg: "${result['message']}",
        );
        return returnMsg;
      }
    } catch (e) {
      if (kDebugMode) {
        print('예외 발생: [pushSignUp] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //로그인
  static Future<(ApiResponseModel, UserModel?)> postSignIn({
    required String email,
    required String pw,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    ApiResponseModel returnMsg;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': pw}),
      );

      final dynamic result = jsonDecode(
        response.body,
      ); //로그인 실패 시, 응답이 없어서 error로 분류!!!!

      //회원가입 성공
      if (response.statusCode == 200) {
        final dynamic data = result['data'];
        if (kDebugMode) {
          print('로그인 성공 - ${result['message']}');
        }

        //사용자 객체 생성
        UserModel user = UserModel.fromJsonWithCustom(
          json: data,
          name: "권원경",
          email: email,
          password: pw,
        );

        //토큰 로컬 저장
        await storage.write(key: "AccessToken", value: data['accessToken']);
        await storage.write(key: "RefreshToken", value: data['refreshToken']);

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "로그인 성공",
          msg: "${result['message']}",
        );
        return (returnMsg, user);
      } else {
        if (kDebugMode) {
          print('로그인 실패 - ${result['message']}');
        }
        returnMsg = ApiResponseModel(
          isSuccess: false,
          title: "로그인 실패",
          msg: "${result['message']}",
        );
        return (returnMsg, null);
      }
    } catch (e) {
      if (kDebugMode) {
        print('예외 발생: [postSignIn] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return (returnMsg, null);
    }
  }
}
