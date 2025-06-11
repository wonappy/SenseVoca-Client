import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sense_voka/models/api_response.dart';
import 'package:sense_voka/models/interest_info_model.dart';
import 'package:sense_voka/models/word_preview_model.dart';

import '../core/global_variables.dart';

class InitialDataService {
  // Create storage
  static final storage = FlutterSecureStorage();

  //검색용 단어 리스트 가져오기
  static Future<ApiResponseModel> getWordInfos() async {
    final url = Uri.parse('${baseUrl}wordinfos/list');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getWordInfos 호출');
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
          print('[getWordInfos] : 검색용 단어 리스트 반환 성공 - ${result['message']}');
        }

        //단어장 리스트
        List<WordPreviewModel> wordInfos = [];

        //data -> WordSetInfoModel로 추출
        final dynamic data = result['data'];
        for (var wordInfo in data) {
          //응답list를 각 객체로 생성 후 list에 저장
          wordInfos.add(WordPreviewModel.fromRandomWordJson(wordInfo));
        }
        if (kDebugMode) {
          print(wordInfos);
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "검색용 단어 리스트 반환 성공",
          msg: "${result['message']}",
          data: wordInfos,
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[getWordInfos] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "검색용 단어 리스트 반환 실패",
          msg: "[getWordInfos] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [getWordInfos] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }

  //관심사 목록 가져오기
  static Future<ApiResponseModel> getInterestList() async {
    final url = Uri.parse('${baseUrl}interests/list');
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('getInterestList 호출');
    }

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        //body json 값 가져오기
        final result = jsonDecode(utf8.decode(response.bodyBytes)); //한글 디코딩

        if (kDebugMode) {
          print('[getInterestList] : 관심사 리스트 반환 성공 - ${result['message']}');
        }

        //단어장 리스트
        List<InterestInfoModel> interestList = [];

        //data -> InterestInfoModel 추출
        final dynamic data = result['data'];
        for (var interest in data) {
          //응답list를 각 객체로 생성 후 list에 저장
          interestList.add(InterestInfoModel.fromJson(interest));
        }
        if (kDebugMode) {
          print(interestList);
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "관심사 리스트 반환 성공",
          msg: "${result['message']}",
          data: interestList,
        );
      } else {
        //body json 값 가져오기
        final dynamic result = jsonDecode(response.body);
        if (kDebugMode) {
          print('${result['message']}');
        }

        returnMsg = ApiResponseModel(
          isSuccess: false,
          title: "관심사 리스트 반환 실패",
          msg: "[getInterestList] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [getInterestList] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }
}
