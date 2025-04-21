class WordInfoModel {
  final int wordId; //단어 id
  final String word; //영어 단어
  final String meaning; //영어 뜻
  final String pronunciation; //발음 기호
  final String mnemonicExample; //연상 예문
  final String mnemonicImageUrl; //연상 예문 이미지
  final String exampleSentenceEn; //영어 예문
  final String exampleSentenceKo; //영어 예문 한글 번역

  WordInfoModel({
    required this.wordId,
    required this.word,
    required this.meaning,
    required this.pronunciation,
    required this.mnemonicExample,

    required this.mnemonicImageUrl,
    required this.exampleSentenceEn,
    required this.exampleSentenceKo,
  });

  //api용
  WordInfoModel.fromJson(Map<String, dynamic> json)
    : wordId = json['wordId'],
      word = json['word'],
      meaning = json['meaning'],
      pronunciation = json['pronunciation'],
      mnemonicExample = json['mnemonicExample'],
      mnemonicImageUrl = json['mnemonicImageUrl'],
      exampleSentenceEn = json['exampleSentenceEn'],
      exampleSentenceKo = json['exampleSentenceKo'];
}
