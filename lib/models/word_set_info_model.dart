class WordSetInfoModel {
  final int wordSetId;
  final String title;
  final int wordCount;
  final DateTime createDate;
  final DateTime lastAccess;

  WordSetInfoModel({
    required this.wordSetId,
    required this.title,
    required this.wordCount,
    required this.createDate,
    required this.lastAccess,
  });

  //api용
  WordSetInfoModel.fromJson(Map<String, dynamic> json)
    : wordSetId = json['id'],
      title = json['title'],
      wordCount = json['count'],
      createDate = json['createDate'],
      lastAccess = json['lastAccess'];
}
