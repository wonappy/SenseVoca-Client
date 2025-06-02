class EssentialSetInfoModel {
  final int wordSetId; //단어장 id
  final String title; //단어장 제목
  final int chapterCount; //단어장 내 챕터 개수
  final String provider; //단어장 제공자

  EssentialSetInfoModel({
    required this.wordSetId,
    required this.title,
    required this.chapterCount,
    required this.provider,
  });

  //api용
  EssentialSetInfoModel.fromJson(Map<String, dynamic> json)
    : wordSetId = json['basicId'],
      title = json['basicTitle'],
      chapterCount = json['daylistCount'],
      provider = json['basicOfferedBy'];
}
