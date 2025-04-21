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
    : wordId = json['wordId'],
      word = json['word'],
      meaning = json['meaning'];
}
