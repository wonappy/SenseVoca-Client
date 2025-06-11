import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sense_voka/models/api_response.dart';
import 'package:sense_voka/models/word_preview_model.dart';

import '../core/global_variables.dart';
import '../models/word_info_model.dart';
import '../models/word_book_info_model.dart';

class MywordbooksService {
  // Create storage
  static final storage = FlutterSecureStorage();
  static const String _baseUrl = "${baseUrl}mywordbooks";

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

  //나만의 단어장 리스트 가져오기
  static Future<ApiResponseModel> getMyWordBookList() async {
    final url = Uri.parse('$_baseUrl/list');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getMyWordBookList 호출');
    }

    try {
      final accessToken = await storage.read(key: "AccessToken");

      final response = await http.get(
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
          print('[getMyWordBookList] : 사용자 단어장 반환 성공 - ${result['message']}');
        }

        //단어장 리스트
        List<WordBookInfoModel> wordSetInfos = [];

        //data -> WordSetInfoModel로 추출
        final dynamic data = result['data'];
        for (var wordSetInfo in data) {
          //응답list를 각 객체로 생성 후 list에 저장
          wordSetInfos.add(WordBookInfoModel.fromJson(wordSetInfo));
        }
        if (kDebugMode) {
          print(wordSetInfos);
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "나만의 단어장 반환 성공",
          msg: "${result['message']}",
          data: wordSetInfos,
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[getMyWordBookList] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "나만의 단어장 반환 실패",
          msg: "[getMyWordBookList] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [getMyWordBookList] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //나만의 단어장 -> 단어 리스트 가져오기
  static Future<ApiResponseModel> getMyWordList({
    required int wordbookId,
  }) async {
    final url = Uri.parse('$_baseUrl/$wordbookId/words');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getMyWordList 호출');
    }

    try {
      final accessToken = await storage.read(key: "AccessToken");
      final response = await http.get(
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
          print('[getMyWordList] : 나만의 단어장 단어 목록 반환 성공 - ${result['message']}');
        }

        //단어장 리스트
        List<WordPreviewModel> wordPreviewList = [];

        //data -> WordPreviewModel 추출
        final dynamic data = result['data'];
        for (var wordPreview in data) {
          //응답list를 각 객체로 생성 후 list에 저장
          wordPreviewList.add(WordPreviewModel.fromMyWordJson(wordPreview));
        }
        if (kDebugMode) {
          print(wordPreviewList);
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "나만의 단어장 단어 목록 반환 성공",
          msg: "${result['message']}",
          data: wordPreviewList,
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[getMyWordList] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "나만의 단어장 단어 목록 반환 실패",
          msg: "[getMyWordList] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [getMyWordList] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //단어 리스트 상세정보 가져오기
  static Future<ApiResponseModel> postMyWordsInfo({
    required List<int> wordIdList,
    required String country,
  }) async {
    final url = Uri.parse('$_baseUrl/myword-info');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('postMyWordsInfo 호출');
    }

    try {
      final accessToken = await storage.read(key: "AccessToken");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'wordIds': wordIdList, 'phoneticType': country}),
      );

      if (response.statusCode == 200) {
        //body json 값 가져오기
        final result = jsonDecode(utf8.decode(response.bodyBytes)); //한글 디코딩

        if (kDebugMode) {
          print('[getMyWordsInfo] : 단어 상세 정보 반환 성공 - ${result['message']}');
        }

        //단어 상세정보 리스트
        List<WordInfoModel> wordInfoList = [];

        //data -> WordPreviewModel 추출
        final dynamic data = result['data'];
        for (var wordInfo in data) {
          //응답list를 각 객체로 생성 후 list에 저장
          wordInfoList.add(WordInfoModel.fromMyWordJson(wordInfo));
        }
        if (kDebugMode) {
          print(wordInfoList);
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "단어 상세 정보 반환 성공",
          msg: "${result['message']}",
          data: wordInfoList,
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[getMyWordsInfo] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "단어 상세 정보 반환 실패",
          msg: "[getMyWordsInfo] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [getMyWordList] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //나만의 단어장 생성
  static Future<ApiResponseModel> postNewMyWordBook({
    required String title,
    required List<WordPreviewModel> words,
    required String country,
  }) async {
    final url = Uri.parse('$_baseUrl/add-book');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('postNewMyWordBook 호출');
    }

    try {
      final accessToken = await storage.read(key: "AccessToken");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'title': title,
          'words': words.map((w) => w.toJson()).toList(),
        }),
      );

      print(WordPreviewModel.encodeToJson(words));

      if (response.statusCode == 201) {
        //body json 값 가져오기
        final result = jsonDecode(utf8.decode(response.bodyBytes)); //한글 디코딩

        if (kDebugMode) {
          print('[postNewMyWordBook] : 새 단어장 생성 성공 - ${result['message']}');
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "새 단어장 생성 성공",
          msg: "${result['message']}",
          data: result['data'],
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[postNewMyWordBook] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "새 단어장 생성 실패",
          msg: "[postNewMyWordBook] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [postNewMyWordBook] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //랜덤 단어 받아오기
  static Future<ApiResponseModel> getRandomMyWord({
    required int randomCount,
  }) async {
    final url = Uri.parse('$_baseUrl/$randomCount/random-myword');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getRandomMyWord 호출');
    }

    try {
      final accessToken = await storage.read(key: "AccessToken");
      final response = await http.get(
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
          print('[getRandomMyWord] Success : ${result['message']}');
        }

        //랜덤 단어 저장
        List<WordPreviewModel> randomWordPreviewList = [];

        //data -> WordPreviewModel 추출
        final dynamic data = result['data'];

        for (var wordPreview in data) {
          //응답list를 각 객체로 생성 후 list에 저장
          randomWordPreviewList.add(
            WordPreviewModel.fromRandomWordJson(wordPreview),
          );
        }
        if (kDebugMode) {
          print(randomWordPreviewList);
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "랜덤 단어 목록 반환 성공",
          msg: "${result['message']}",
          data: randomWordPreviewList,
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[getRandomMyWord] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "랜덤 단어 목록 반환 실패",
          msg: "[getMyWordList] fail - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('[getMyWordList] error : $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  // >> 단어장 환경 설정
  // [PUT] 나만의 단어장 -> 제목 수정
  static Future<ApiResponseModel> putMyWordBookTitle({required int wordbookId, required String newTitle}) async {
    final url = Uri.parse('$_baseUrl/$wordbookId/rename');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('putMyWordBookTitle 호출 : $url');
      print('새 제목 : $newTitle');
    }

    try {
      final headers = await _getHeaders(); // 헤더
      final body = jsonEncode({'title': newTitle}); // 사용자 입력 : 새 제목
      final response = await http.put(url, headers: headers, body: body); // 요청, 응답

      return _handleResponse(response, '단어장 제목이 수정되었습니다.');
    }
    catch (e) {
      if (kDebugMode) {
        print('deleteWordBook 에러: $e');
      }
      returnMsg = ApiResponseModel(
        isSuccess: false,
        title: "오류 발생",
        msg: "네트워크 오류가 발생했습니다.",
        data: null,
      );
    }

    return returnMsg;
  }

  // [DELETE] 나만의 단어장 -> 단어 삭제
  static Future<ApiResponseModel> deleteMyWordBookWord({required int wordbookId, required int wordId}) async {
    final url = Uri.parse('$_baseUrl/$wordbookId/words/$wordId');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('deleteWordBook 호출 : $url');
    }

    try {
      final headers = await _getHeaders();
      final response = await http.delete(url, headers: headers);

      return _handleResponse(response, '단어가 삭제되었습니다.');
    }
    catch (e) {
      if (kDebugMode) {
        print('deleteWordBook 에러: $e');
      }
      returnMsg = ApiResponseModel(
        isSuccess: false,
        title: "오류 발생",
        msg: "네트워크 오류가 발생했습니다.",
        data: null,
      );
    }

    return returnMsg;
  }

  // [DELETE] 나만의 단어장 -> 단어장 삭제
  static Future<ApiResponseModel> deleteMyWordBook({required int wordbookId}) async {
    final url = Uri.parse('$_baseUrl/$wordbookId');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('deleteWordBook 호출 : $url');
    }

    try {
      final headers = await _getHeaders();
      final response = await http.delete(url, headers: headers);

      return _handleResponse(response, '단어장이 삭제되었습니다.');
    }
    catch (e) {
      if (kDebugMode) {
        print('deleteWordBook 에러: $e');
      }
      returnMsg = ApiResponseModel(
        isSuccess: false,
        title: "오류 발생",
        msg: "네트워크 오류가 발생했습니다.",
        data: null,
      );
    }

    return returnMsg;
  }
}
