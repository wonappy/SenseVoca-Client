//발음 평가 class
class PronunciationResultModel {
  final String word;
  final OverallScoreModel overallScore;
  final List<PhonemeResultModel> phonemeResults;

  PronunciationResultModel({
    required this.word,
    required this.overallScore,
    required this.phonemeResults,
  });

  PronunciationResultModel.fromJson(Map<String, dynamic> json)
    : word = json['word'],
      overallScore = OverallScoreModel.fromJson(json['overallScore']),
      phonemeResults =
          (json['phonemeResults'] as List)
              .map((e) => PhonemeResultModel.fromJson(e))
              .toList();
}

//포괄 점수
class OverallScoreModel {
  final int accuracy; //정확도
  final int fluency; //유창성
  final int completeness; //완성도
  final int total; //총점

  OverallScoreModel({
    required this.accuracy,
    required this.fluency,
    required this.completeness,
    required this.total,
  });

  OverallScoreModel.fromJson(Map<String, dynamic> json)
    : accuracy = json['accuracy'],
      fluency = json['fluency'],
      completeness = json['completeness'],
      total = json['total'];
}

//세부 발음 점수
class PhonemeResultModel {
  final String symbol; //발음기호
  final int score; //점수
  final String feedback; //피드백

  PhonemeResultModel({
    required this.symbol,
    required this.score,
    required this.feedback,
  });

  PhonemeResultModel.fromJson(Map<String, dynamic> json)
    : symbol = json['symbol'],
      score = json['score'],
      feedback = json['feedback'];
}
