import 'dart:convert';

import '../enums/app_enums.dart';

class WordPreviewModel {
  int? wordId; //단어 id
  String word; //영어 단어
  String meaning; //영어 뜻
  WordBook type; //타입

  WordPreviewModel({
    this.wordId,
    required this.word,
    required this.meaning,
    required this.type,
  });

  //나만의 단어장 api용
  WordPreviewModel.fromMyWordJson(Map<String, dynamic> json)
    : wordId = json['myWordId'],
      word = json['word'],
      meaning = json['meaning'],
      type = WordBook.my;

  //기본 단어장 api용
  WordPreviewModel.fromBasicWordJson(Map<String, dynamic> json)
    : wordId = json['daywordId'],
      word = json['word'],
      meaning = json['meaning'],
      type = WordBook.basic;

  //랜덤 단어장 api용
  WordPreviewModel.fromRandomWordJson(Map<String, dynamic> json)
    : wordId = json['wordId'],
      word = json['word'],
      meaning = json['meaning'],
      type = WordBook.basic;

  //즐겨찾기 단어장 api용
  WordPreviewModel.fromFavoriteWordJson(Map<String, dynamic> json)
    : wordId = json['wordId'],
      word = json['word'],
      meaning = json['meaning'],
      type = WordBook.values.byName(json['type'].toString().toLowerCase());

  Map<String, dynamic> toJson() {
    return {'wordId': wordId, 'word': word, 'meaning': meaning};
  }

  static String encodeToJson(List<WordPreviewModel> words) {
    return jsonEncode(words.map((e) => e.toJson()).toList());
  }

  @override
  String toString() {
    String result =
        'WordPreviewModel(wordId: $wordId, '
        'word: "$word", '
        'meaning: "$meaning", '
        'type: "${type.name}", )';

    return result;
  }

  //contains 비교를 위한 ==, hashCode 재정의
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WordPreviewModel && other.wordId == wordId;
  }

  @override
  int get hashCode => wordId.hashCode;
}
