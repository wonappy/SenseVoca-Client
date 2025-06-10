import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:sense_voka/models/api_response.dart';
import 'package:sense_voka/models/essential_set_info_model.dart';
import 'package:sense_voka/models/pronunciation_result_model.dart';
import 'package:sense_voka/models/word_preview_model.dart';

import '../core/global_variables.dart';
import '../models/essential_chapter_info_model.dart';
import '../models/word_info_model.dart';
import '../models/word_book_info_model.dart';

class EvaluatePronunciationService {
  // Create storage
  static final storage = FlutterSecureStorage();
  static const String _baseUrl = "${baseUrl}evaluate-pronunciation";

  //단어 리스트 상세정보 가져오기
  static Future<ApiResponseModel> postEvaluatePronunciation({
    required String word,
    required String country,
    required File audioFile,
  }) async {
    final url = Uri.parse(_baseUrl);
    ApiResponseModel returnMsg;

    if (kDebugMode) {
      print('postEvaluatePronunciation 호출');
    }

    print("파일 존재 여부: ${File(audioFile.path).existsSync()}");
    print("파일 경로: ${audioFile.path}");

    try {
      final accessToken = await storage.read(key: "AccessToken");
      final request =
          http.MultipartRequest('POST', url)
            ..fields['word'] = word
            ..fields['country'] = country
            ..headers['Authorization'] = 'Bearer $accessToken'
            ..files.add(
              await http.MultipartFile.fromPath(
                'audio',
                audioFile.path,
                contentType: MediaType('audio', 'wav'), // 확장자에 따라 조정
              ),
            );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        //body json 값 가져오기
        final result = jsonDecode(utf8.decode(response.bodyBytes)); //한글 디코딩

        if (kDebugMode) {
          print(
            '[postEvaluatePronunciation] : 발음 평가 결과 반환 성공 - ${result['message']}',
          );
        }

        if (kDebugMode) {
          print(result);
        }

        //단어 상세정보 리스트
        PronunciationResultModel pronunciationResult;

        //data -> WordPreviewModel 추출
        final dynamic data = result['data'];
        pronunciationResult = PronunciationResultModel.fromJson(data);

        if (kDebugMode) {
          print(pronunciationResult);
        }

        returnMsg = ApiResponseModel(
          isSuccess: true,
          title: "발음 평가 결과 반환 성공",
          msg: "${result['message']}",
          data: pronunciationResult,
        );
      } else if (response.statusCode == 403) {
        if (kDebugMode) {
          print('[postEvaluatePronunciation] - AccessToken 만료. 토큰 재발급 필요.');
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
          title: "발음 평가 결과 반환 실패",
          msg: "[postEvaluatePronunciation] - ${result['message']}",
        );
      }
      return returnMsg;
    } catch (e) {
      if (kDebugMode) {
        print('오류 발생: [postEvaluatePronunciation] $e');
      }
      returnMsg = ApiResponseModel(isSuccess: false, title: "오류 발생", msg: "$e");
      return returnMsg;
    }
  }
}
