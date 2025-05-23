import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sense_voka/models/api_response.dart';
import 'package:sense_voka/models/user_model.dart';
import 'package:sense_voka/models/word_preview_model.dart';

import '../models/word_info_model.dart';
import '../models/word_set_info_model.dart';

class MywordbooksService {
  // Create storage
  static final storage = FlutterSecureStorage();
  static const String baseUrl = "http://10.101.18.156:8080/api/mywordbooks";

  //나만의 단어장 리스트 가져오기
  static Future<ApiResponseModel> getMyWordBookList() async {
    final url = Uri.parse('$baseUrl/list');
    ApiResponseModel returnMsg;

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
    final url = Uri.parse('$baseUrl/$wordbookId/words');
    ApiResponseModel returnMsg;

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
          wordPreviewList.add(WordPreviewModel.fromJson(wordPreview));
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
  static Future<ApiResponseModel> getMyWordsInfo({
    required List<int> wordIdList,
    required String country,
  }) async {
    final url = Uri.parse('$baseUrl/myword-info');
    ApiResponseModel returnMsg;

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
          wordInfoList.add(WordInfoModel.fromJson(wordInfo));
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
}
