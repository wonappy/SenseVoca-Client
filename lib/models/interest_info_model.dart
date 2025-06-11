import '../enums/app_enums.dart';

class InterestInfoModel {
  int interestId; //관심사 id
  String type; //관심사

  InterestInfoModel({required this.interestId, required this.type});

  //나만의 단어장 api용
  InterestInfoModel.fromJson(Map<String, dynamic> json)
    : interestId = json['interestId'],
      type = json['type'];

  @override
  String toString() {
    String result =
        'InterestInfoModel(interestId: $interestId, '
        'type: "$type", )';

    return result;
  }
}
