class EssentialChapterInfoModel {
  final int chapterId; //챕터 id
  final String title; //챕터 제목
  final int wordCount; //챕터 내 단어 개수
  DateTime? lastAccess; //마지막 접근 시각 -> 한 번도 접근하지 않았다면 접근 시각 null

  EssentialChapterInfoModel({
    required this.chapterId,
    required this.title,
    required this.wordCount,
    this.lastAccess,
  });

  //api용
  EssentialChapterInfoModel.fromJson(Map<String, dynamic> json)
    : chapterId = json['daylistId'],
      title = json['daylistTitle'],
      wordCount = json['daywordCount'],
      lastAccess =
          json['latestAccessedAt'] != null
              ? DateTime.parse(json['latestAccessedAt'])
              : null;

  @override
  String toString() {
    String result =
        'WordInfoModel(chapterId: $chapterId, '
        'title: "$title", '
        'wordCount: "$wordCount", '
        'lastAccess: "$lastAccess",)';

    return result;
  }
}
