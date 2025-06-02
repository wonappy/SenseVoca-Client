import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sense_voka/models/api_response.dart';
import 'package:sense_voka/models/word_preview_model.dart';

import '../core/global_variables.dart';
import '../models/word_info_model.dart';
import '../models/word_book_info_model.dart';

class FavoriteWordsService {
  // Create storage
  static final storage = FlutterSecureStorage();
  static const String _baseUrl = "${baseUrl}favoritewords";

  //나만의 단어 즐겨찾기 등록
  static Future<ApiResponseModel> postMyWordtoFavorite({
    required int myWordMMnemonicId,
  }) async {
    final url = Uri.parse('$_baseUrl/add-myword/$myWordMMnemonicId');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('postMyWordtoFavorite 호출');
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
            '[postMyWordtoFavorite] : 나만의 단어 즐겨찾기 등록 성공 - ${result['message']}',
          );
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "나만의 단어 즐겨찾기 등록 성공",
          msg: "${result['message']}",
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[postMyWordtoFavorite] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "나만의 단어 즐겨찾기 등록 실패",
          msg: "[postMyWordtoFavorite] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [postMyWordtoFavorite] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //나만의 단어 즐겨찾기 해제
  static Future<ApiResponseModel> deleteMyWordfromFavorite({
    required int myWordMMnemonicId,
  }) async {
    final url = Uri.parse('$_baseUrl/remove-myword/$myWordMMnemonicId');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('deleteMyWordfromFavorite 호출');
    }

    try {
      final accessToken = await storage.read(key: "AccessToken");
      final response = await http.delete(
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
            '[deleteMyWordfromFavorite] : 나만의 단어 즐겨찾기 해제 성공 - ${result['message']}',
          );
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "나만의 단어 즐겨찾기 해제 성공",
          msg: "${result['message']}",
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[deleteMyWordfromFavorite] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "나만의 단어 즐겨찾기 해제 실패",
          msg: "[deleteMyWordfromFavorite] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [deleteMyWordfromFavorite] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //랜덤 단어 받아오기
  // static Future<ApiResponseModel> getRandomMyWord({
  //   required int randomCount,
  // }) async {
  //   final url = Uri.parse('$_baseUrl/$randomCount/random-myword');
  //   ApiResponseModel returnMsg;
  //
  //   if (kDebugMode) {
  //     print('getRandomMyWord 호출');
  //   }
  //
  //   try {
  //     final accessToken = await storage.read(key: "AccessToken");
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       //body json 값 가져오기
  //       final result = jsonDecode(utf8.decode(response.bodyBytes)); //한글 디코딩
  //
  //       if (kDebugMode) {
  //         print('[getRandomMyWord] Success : ${result['message']}');
  //       }
  //
  //       //랜덤 단어 저장
  //       List<WordPreviewModel> randomWordPreviewList = [];
  //
  //       //data -> WordPreviewModel 추출
  //       final dynamic data = result['data'];
  //
  //       for (var wordPreview in data) {
  //         //응답list를 각 객체로 생성 후 list에 저장
  //         randomWordPreviewList.add(
  //           WordPreviewModel.fromRandomWordJson(wordPreview),
  //         );
  //       }
  //       if (kDebugMode) {
  //         print(randomWordPreviewList);
  //       }
  //
  //       returnMsg = ApiResponseModel(
  //         isSuccess: true,
  //         title: "랜덤 단어 목록 반환 성공",
  //         msg: "${result['message']}",
  //         data: randomWordPreviewList,
  //       );
  //     } else if (response.statusCode == 403) {
  //       if (kDebugMode) {
  //         print('[getRandomMyWord] - AccessToken 만료. 토큰 재발급 필요.');
  //       }
  //
  //       //403으로 실패했을 경우 -> a토큰 값 만료
  //       // -> 재발급 받은 다음
  //       // -> 해당 api 호출 다시 시도
  //
  //       returnMsg = ApiResponseModel(
  //         isSuccess: false,
  //         title: "Token 재발급",
  //         msg: "AccessToken 만료. 토큰 재발급 필요.",
  //       );
  //     } else {
  //       //body json 값 가져오기
  //       final dynamic result = jsonDecode(response.body);
  //       if (kDebugMode) {
  //         print('${result['message']}');
  //       }
  //
  //       returnMsg = ApiResponseModel(
  //         isSuccess: false,
  //         title: "랜덤 단어 목록 반환 실패",
  //         msg: "[getMyWordList] fail - ${result['message']}",
  //       );
  //     }
  //     return returnMsg;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('[getMyWordList] error : $e');
  //     }
  //     returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
  //     return returnMsg;
  //   }
  // }

  //기본 제공 단어 즐겨찾기 등록
  static Future<ApiResponseModel> postBasicWordtoFavorite({
    required int basicWordId,
  }) async {
    final url = Uri.parse('$_baseUrl/add-basicword/$basicWordId');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('postBasicWordtoFavorite 호출');
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
            '[postBasicWordtoFavorite] : 기본 제공 단어 즐겨찾기 등록 성공 - ${result['message']}',
          );
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "기본 제공 단어 즐겨찾기 등록 성공",
          msg: "${result['message']}",
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[postBasicWordtoFavorite] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "기본 제공 단어 즐겨찾기 등록 실패",
          msg: "[postBasicWordtoFavorite] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [postBasicWordtoFavorite] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //기본 제공 단어 즐겨찾기 해제
  static Future<ApiResponseModel> deleteBasicWordfromFavorite({
    required int basicWordId,
  }) async {
    final url = Uri.parse('$_baseUrl/remove-basicword/$basicWordId');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('deleteBasicWordfromFavorite 호출');
    }

    try {
      final accessToken = await storage.read(key: "AccessToken");
      final response = await http.delete(
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
            '[deleteBasicWordfromFavorite] : 기본 제공 단어 즐겨찾기 해제 성공 - ${result['message']}',
          );
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "기본 제공 단어 즐겨찾기 해제 성공",
          msg: "${result['message']}",
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[deleteBasicWordfromFavorite] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "기본 제공 단어 즐겨찾기 해제 실패",
          msg: "[deleteBasicWordfromFavorite] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [deleteBasicWordfromFavorite] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }
}
