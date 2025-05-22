class WordPreviewModel {
  final int wordId; //단어 id
  final String word; //영어 단어
  final String meaning; //영어 뜻

  WordPreviewModel({
    required this.wordId,
    required this.word,
    required this.meaning,
  });

  //api용
  WordPreviewModel.fromJson(Map<String, dynamic> json)
    : wordId = json['myWordId'],
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
}
