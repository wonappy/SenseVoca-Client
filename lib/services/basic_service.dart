import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sense_voka/models/api_response.dart';
import 'package:sense_voka/models/essential_set_info_model.dart';
import 'package:sense_voka/models/word_preview_model.dart';

import '../core/global_variables.dart';
import '../models/essential_chapter_info_model.dart';
import '../models/word_info_model.dart';
import '../models/word_book_info_model.dart';

class BasicService {
  // Create storage
  static final storage = FlutterSecureStorage();
  static const String _baseUrl = "${baseUrl}basic";

  //기본 단어장 리스트 가져오기
  static Future<ApiResponseModel> getBasicWordBookList() async {
    final url = Uri.parse('$_baseUrl/list');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getBasicWordBookList 호출');
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
          print('[getBasicWordBookList] : 기본 단어장 반환 성공 - ${result['message']}');
        }

        //단어장 리스트
        List<EssentialSetInfoModel> wordSetInfos = [];

        //data -> WordSetInfoModel로 추출
        final dynamic data = result['data'];
        for (var wordSetInfo in data) {
          //응답list를 각 객체로 생성 후 list에 저장
          wordSetInfos.add(EssentialSetInfoModel.fromJson(wordSetInfo));
        }
        if (kDebugMode) {
          print(wordSetInfos);
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "기본 단어장 반환 성공",
          msg: "${result['message']}",
          data: wordSetInfos,
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[getBasicWordBookList] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "기본 단어장 반환 실패",
          msg: "[getBasicWordBookList] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [getBasicWordBookList] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //기본 단어장 챕터 리스트 가져오기
  static Future<ApiResponseModel> getBasicChapterList({
    required int wordbookId,
  }) async {
    final url = Uri.parse('$_baseUrl/$wordbookId/daylist/');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getBasicChapterList 호출');
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
          print(
            '[getBasicChapterList] : 기본 단어장 챕터 목록 반환 성공 - ${result['message']}',
          );
        }

        //챕터 리스트
        List<EssentialChapterInfoModel> chapterList = [];

        //data -> WordPreviewModel 추출
        final dynamic data = result['data'];
        for (var chapter in data) {
          //응답list를 각 객체로 생성 후 list에 저장
          chapterList.add(EssentialChapterInfoModel.fromJson(chapter));
        }
        if (kDebugMode) {
          print(chapterList);
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "기본 단어장 챕터 목록 반환 성공",
          msg: "${result['message']}",
          data: chapterList,
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[getBasicChapterList] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "기본 단어장 챕터 목록 반환 실패",
          msg: "[getBasicChapterList] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [getBasicChapterList] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //챕터 접근 시간 갱신 수정!

  //챕터 접근시간 갱신
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

  //기본 단어장 챕터 단어 리스트 가져오기

  static Future<ApiResponseModel> getBasicWordList({
    required int chapterId,
  }) async {
    final url = Uri.parse('$_baseUrl/$chapterId/dayword');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getBasicWordList 호출');
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
          print(
            '[getBasicWordList] : 기본 단어장 단어 목록 반환 성공 - ${result['message']}',
          );
        }

        //단어장 리스트
        List<WordPreviewModel> wordPreviewList = [];

        //data -> WordPreviewModel 추출
        final dynamic data = result['data'];
        for (var wordPreview in data) {
          //응답list를 각 객체로 생성 후 list에 저장
          wordPreviewList.add(WordPreviewModel.fromBasicWordJson(wordPreview));
        }
        if (kDebugMode) {
          print(wordPreviewList);
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "기본 단어장 챕터 단어 목록 반환 성공",
          msg: "${result['message']}",
          data: wordPreviewList,
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[getBasicWordList] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "기본 단어장 챕터 단어 목록 반환 실패",
          msg: "[getBasicWordList] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [getBasicWordList] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //단어 리스트 상세정보 가져오기
  static Future<ApiResponseModel> postBasicWordsInfo({
    required List<int> wordIdList,
    required String country,
  }) async {
    final url = Uri.parse('$_baseUrl/basic_word/$country');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('postBasicWordsInfo 호출');
    }

    try {
      final accessToken = await storage.read(key: "AccessToken");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'daywordId': wordIdList}),
      );

      if (response.statusCode == 200) {
        //body json 값 가져오기
        final result = jsonDecode(utf8.decode(response.bodyBytes)); //한글 디코딩

        if (kDebugMode) {
          print('[postBasicWordsInfo] : 단어 상세 정보 반환 성공 - ${result['message']}');
        }

        //단어 상세정보 리스트
        List<WordInfoModel> wordInfoList = [];

        //data -> WordPreviewModel 추출
        final dynamic data = result['data'];
        for (var wordInfo in data) {
          //응답list를 각 객체로 생성 후 list에 저장
          wordInfoList.add(WordInfoModel.fromBasicWordJson(wordInfo));
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
          print('[postBasicWordsInfo] - AccessToken 만료. 토큰 재발급 필요.');
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
          msg: "[postBasicWordsInfo] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [postBasicWordsInfo] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }
}
