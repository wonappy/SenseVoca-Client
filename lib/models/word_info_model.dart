import '../enums/app_enums.dart';

class WordInfoModel {
  final WordBook type; //단어 타입
  final int wordId; //단어 id
  final String word; //영어 단어
  final String meaning; //영어 뜻
  final String pronunciation; //발음 기호
  final String mnemonicExample; //연상 예문
  final String mnemonicImageUrl; //연상 예문 이미지
  final String exampleSentenceEn; //영어 예문
  final String exampleSentenceKo; //영어 예문 한글 번역
  bool favorite; //즐겨찾기 여부

  WordInfoModel({
    required this.type,
    required this.wordId,
    required this.word,
    required this.meaning,
    required this.pronunciation,
    required this.mnemonicExample,
    required this.mnemonicImageUrl,
    required this.exampleSentenceEn,
    required this.exampleSentenceKo,
    required this.favorite,
  });

  //api용
  WordInfoModel.fromMyWordJson(Map<String, dynamic> json)
    : type = WordBook.my,
      wordId = json['mnemonicId'],
      word = json['word'],
      meaning = json['meaning'],
      pronunciation = json['phoneticSymbol'],
      mnemonicExample = json['association'],
      mnemonicImageUrl = json['imageUrl'],
      exampleSentenceEn = json['exampleEng'],
      exampleSentenceKo = json['exampleKor'],
      favorite = json['favorite'];

  //BasicWord api용
  WordInfoModel.fromBasicWordJson(Map<String, dynamic> json)
    : type = WordBook.basic,
      wordId = json['daywordId'],
      word = json['word'],
      meaning = json['meaning'],
      pronunciation = json['phonetic'],
      mnemonicExample = json['association'],
      mnemonicImageUrl = json['imageUrl'],
      exampleSentenceEn = json['exampleEng'],
      exampleSentenceKo = json['exampleKor'],
      favorite = json['favorite'];

  @override
  String toString() {
    String result =
        'WordInfoModel('
        'type: "${type.name}", '
        'wordId: $wordId, '
        'word: "$word", '
        'meaning: "$meaning", '
        'pronunciation: "$pronunciation", '
        'mnemonicExample: "$mnemonicExample", '
        'mnemonicImageUrl: "$mnemonicImageUrl", '
        'exampleSentenceEn: "$exampleSentenceEn", '
        'exampleSentenceKo: "$exampleSentenceKo", '
        'favorite: "$favorite",)';

    return result;
  }
}
