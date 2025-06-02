class WordPreviewModel {
  final int wordId; //단어 id
  final String word; //영어 단어
  final String meaning; //영어 뜻

  WordPreviewModel({
    required this.wordId,
    required this.word,
    required this.meaning,
  });

  //나만의 단어장 api용
  WordPreviewModel.fromMyWordJson(Map<String, dynamic> json)
    : wordId = json['myWordId'],
      word = json['word'],
      meaning = json['meaning'];

  //기본 단어장 api용
  WordPreviewModel.fromBasicWordJson(Map<String, dynamic> json)
    : wordId = json['daywordId'],
      word = json['word'],
      meaning = json['meaning'];

  //랜덤 단어장 api용
  WordPreviewModel.fromRandomWordJson(Map<String, dynamic> json)
    : wordId = json['wordId'],
      word = json['word'],
      meaning = json['meaning'];

  @override
  String toString() {
    String result =
        'WordPreviewModel(wordId: $wordId, '
        'word: "$word", '
        'meaning: "$meaning", )';

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
