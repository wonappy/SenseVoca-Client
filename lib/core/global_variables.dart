//api 호출 공통 url
import 'package:sense_voka/models/word_preview_model.dart';

import '../enums/app_enums.dart';

const String baseUrl = "http://10.101.25.119:8080/api/";

//검색용 단어 정보 리스트 -> 앱 시작 시 초기화
late final List<WordPreviewModel> wordSearchList;
//List<WordPreviewModel> wordSearchList = []; // ← 구체적인 타입으로 변경

//발음 설정 국가
late Country voiceCountry;
