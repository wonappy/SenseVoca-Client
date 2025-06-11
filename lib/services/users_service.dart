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


  // [+] 공통 - 헤더
  static Future<Map<String, String>> _getHeaders() async {
    final accessToken = await storage.read(key: "AccessToken");
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  // [+] 공통 - 에러 처리 함수
  static ApiResponseModel _handleResponse(http.Response response, String successMessage) {
    print('응답 상태코드: ${response.statusCode}');
    print('응답 본문: "${response.body}"');

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.body.isEmpty) {
        return ApiResponseModel(
          isSuccess: true,
          title: "성공",
          msg: successMessage,
          data: null,
        );
      }

      try {
        final data = json.decode(response.body);
        // fromJson 대신 직접 생성
        return ApiResponseModel(
          isSuccess: data['isSuccess'] ?? true,
          title: data['title'] ?? "성공",
          msg: data['msg'] ?? successMessage,
          data: data['data'],
        );
      } catch (e) {
        print('JSON 파싱 에러: $e');
        return ApiResponseModel(
          isSuccess: true,
          title: "성공",
          msg: successMessage,
          data: null,
        );
      }
    }

    return ApiResponseModel(
      isSuccess: false,
      title: "오류 발생",
      msg: "서버 오류: ${response.statusCode}",
      data: null,
    );
  }

  //이메일 중복 확인
  static Future<ApiResponseModel> getCheckEmailDuplicate(String email) async {
    final url = Uri.parse('$_baseUrl/$email/check-email');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getCheckEmailDuplicate 호출');
    }

    try {
      final response = await http.get(url);

      final dynamic result = jsonDecode(response.body);

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

      final result = jsonDecode(utf8.decode(response.bodyBytes));

      //로그인 성공
      if (response.statusCode == 200) {
        final dynamic data = result['data'];
        if (kDebugMode) {
          print('로그인 성공 - ${result['message']}');
        }

        //사용자 객체 생성
        UserModel user = UserModel.fromJsonWithCustom(
          json: data,
          name: data['nickname'],
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

  // >> 메인 화면
// [GET] 학습 통계 조회 (학습한 단어 & 연속 학습 일수)
  static Future<ApiResponseModel> getUserStatus() async {
    final url = Uri.parse('$_baseUrl/status');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getUserStatus 호출 : $url');
    }

    try {
      final headers = await _getHeaders(); // 헤더, 요청
      final response = await http.get(url, headers: headers); // 응답

      return _handleResponse(response, '사용자의 학습 통계 조회 성공');
    } catch (e) {
      if (kDebugMode) {
        print('getUserStatus 에러: $e');
      }
      return returnMsg = ApiResponseModel(
        isSuccess: false,
        title: "오류 발생",
        msg: "네트워크 오류가 발생했습니다.",
        data: null,
      );
    }
  }
}
