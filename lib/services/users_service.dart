import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sense_voka/models/api_response.dart';
import 'package:sense_voka/models/user_model.dart';

import '../core/global_variables.dart';

class UsersService {
  // Create storage
  static final storage = FlutterSecureStorage();
  static const String _baseUrl = "${baseUrl}users";

  //이메일 중복 확인
  static Future<ApiResponseModel> getCheckEmailDuplicate(String email) async {
    final url = Uri.parse('$_baseUrl/$email/check-email');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getCheckEmailDuplicate 호출');
    }

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final dynamic result = jsonDecode(response.body);

      //중복되지 않은 이메일
      if (response.statusCode == 200 && result['data'] == false) {
        final result = jsonDecode(utf8.decode(response.bodyBytes)); //한글 디코딩
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
    final url = Uri.parse('$_baseUrl/signup');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('postSignUp 호출');
    }

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
        final result = jsonDecode(utf8.decode(response.bodyBytes)); //한글 디코딩
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
    final url = Uri.parse('$_baseUrl/login');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('postSignIn 호출');
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': pw}),
      );

      final dynamic result = jsonDecode(
        response.body,
      ); //로그인 실패 시, 응답이 없어서 error로 분류!!!!

      //로그인 성공
      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.bodyBytes)); //한글 디코딩
        final dynamic data = result['data'];
        if (kDebugMode) {
          print('로그인 성공 - ${result['message']}');
        }

        //사용자 객체 생성
        UserModel user = UserModel.fromJsonWithCustom(
          json: data,
          name: "권원경",
          email: email,
        );

        //토큰 로컬 저장
        await storage.write(key: "AccessToken", value: data['accessToken']);
        await storage.write(key: "RefreshToken", value: data['refreshToken']);

        final userJson = jsonEncode({
          'userId': user.userId,
          'email': user.email,
          'name': user.name,
        });
        await storage.write(key: "UserInfo", value: userJson);

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

  //오늘 학습 단어 갱신
  static Future<ApiResponseModel> postUserStatusUpdate({
    required int learnedCount,
  }) async {
    final url = Uri.parse('$_baseUrl/status/update/$learnedCount');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('postUserStatusUpdate 호출');
    }

    try {
      final accessToken = await storage.read(key: "AccessToken");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        //body json 값 가져오기
        final result = jsonDecode(utf8.decode(response.bodyBytes)); //한글 디코딩

        if (kDebugMode) {
          print(
            '[postUserStatusUpdate] : 학습 단어 개수 갱신 성공 - ${result['message']}',
          );
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "학습 단어 개수 갱신 성공",
          msg: "${result['message']}",
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[postUserStatusUpdate] - AccessToken 만료. 토큰 재발급 필요.');
        }

        //403으로 실패했을 경우 -> a토큰 값 만료
        // -> 재발급 받은 다음
        // -> 해당 api 호출 다시 시도

        returnMsg = ApiResponseModel(
          isSuccess: false,
          title: "Token 재발급",
          msg: "AccessToken 만료. 토큰 재발급 필요.",
        );
      } else {
        //body json 값 가져오기
        final dynamic result = jsonDecode(response.body);
        if (kDebugMode) {
          print('${result['message']}');
        }

        returnMsg = ApiResponseModel(
          isSuccess: false,
          title: "학습 단어 개수 갱신 실패",
          msg: "[postUserStatusUpdate] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [postUserStatusUpdate] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //refreshToken 유효성 확인 -> accessToken 재발급 (자동로그인 외)
  static Future<ApiResponseModel> postJWTToken({
    required String refreshToken,
  }) async {
    final url = Uri.parse('$_baseUrl/token');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('postJWTToken 호출');
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      final dynamic result = jsonDecode(response.body);

      //유효한 token
      if (response.statusCode == 201) {
        final dynamic data = result['accessToken'];
        if (kDebugMode) {
          print('token 재발급 성공');
        }

        //저장소 토큰 로컬 갱신
        await storage.write(key: "AccessToken", value: data);
        if (kDebugMode) {
          print("토큰 값 : $data");
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "token 재발급 성공",
          msg: "accessToken : data",
          data: data,
        );
        return (returnMsg);
      } else {
        if (kDebugMode) {
          print('token 재발급 실패');
        }
        returnMsg = ApiResponseModel(
          isSuccess: false,
          title: "token 재발급 실패",
          msg: "재로그인 필요",
        );
        return (returnMsg);
      }
    } catch (e) {
      if (kDebugMode) {
        print('예외 발생: [postJWTToken] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return (returnMsg);
    }
  }
}
