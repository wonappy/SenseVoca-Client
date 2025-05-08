class EssentiaChapterInfoModel {
  final int chapterId; //챕터 id
  final String title; //챕터 제목
  final int wordCount; //챕터 내 단어 개수
  DateTime? lastAccess; //마지막 접근 시각 -> 한 번도 접근하지 않았다면 접근 시각 null

  EssentiaChapterInfoModel({
    required this.chapterId,
    required this.title,
    required this.wordCount,
    this.lastAccess,
  });

  //api용
  EssentiaChapterInfoModel.fromJson(Map<String, dynamic> json)
    : chapterId = json['id'],
      title = json['title'],
      wordCount = json['count'],
      lastAccess = json['lastAccess'];
}
