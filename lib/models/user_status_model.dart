class UserStatusModel {
  final int todayCount;
  final int streakDays;

  UserStatusModel({
      required this.todayCount,
      required this.streakDays
  });

  // API
  UserStatusModel.fromJson(Map<String, dynamic> json)
    : todayCount = json['todayCount'],
        streakDays = json['streakDays'];
}