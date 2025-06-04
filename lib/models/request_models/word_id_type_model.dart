import '../../enums/app_enums.dart';

class WordIdTypeModel {
  final int wordId;
  final WordBook type;

  const WordIdTypeModel({required this.wordId, required this.type});

  Map<String, dynamic> toJson() => {"wordId": wordId, "type": type.name};

  @override
  String toString() {
    String result =
        'WordIdTypeModel('
        'type: "${type.name}", '
        'wordId: $wordId,)';

    return result;
  }
}
