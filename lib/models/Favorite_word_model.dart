import '../enums/app_enums.dart';

class FavoriteWordPreviewModel {
  int wordId; //단어 id
  String word; //영어 단어
  String meaning; //영어 뜻
  WordBook type; //영어 뜻

  FavoriteWordPreviewModel({
    required this.wordId,
    required this.word,
    required this.meaning,
    required this.type,
  });

  //나만의 단어장 api용
  FavoriteWordPreviewModel.fromJson(Map<String, dynamic> json)
    : wordId = json['wordId'],
      word = json['word'],
      meaning = json['meaning'],
      type = WordBook.values.byName(json['type']);

  @override
  String toString() {
    String result =
        'WordPreviewModel(wordId: $wordId, '
        'word: "$word", '
        'meaning: "$meaning", '
        'type: "$type", )';

    return result;
  }

  //contains 비교를 위한 ==, hashCode 재정의
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FavoriteWordPreviewModel && other.wordId == wordId;
  }

  @override
  int get hashCode => wordId.hashCode;
}
