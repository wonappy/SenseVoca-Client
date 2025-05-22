import 'dart:typed_data';

class WordBookInfoModel {
  final int wordBookId;
  final String title;
  final int wordCount;
  final DateTime createDate;
  final DateTime lastAccess;
  bool isLoading;

  WordBookInfoModel({
    required this.wordBookId,
    required this.title,
    required this.wordCount,
    required this.createDate,
    required this.lastAccess,
    this.isLoading = false,
  });

  //api용
  WordBookInfoModel.fromJson(Map<String, dynamic> json)
    : wordBookId = json['id'],
      title = json['title'],
      wordCount = json['wordCount'],
      createDate = DateTime.parse(json['createdAt']),
      lastAccess = DateTime.parse(json['lastAccessedAt']),
      isLoading = false;

  @override
  String toString() {
    String result =
        'WordBookInfoModel(wordBookId: $wordBookId, '
        'title: "$title", '
        'wordCount: $wordCount, '
        'createDate: ${createDate.toIso8601String()}, '
        'lastAccess: ${lastAccess.toIso8601String()}, )';

    return result;
  }
}
