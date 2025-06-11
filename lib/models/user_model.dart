class UserModel {
  final int userId;
  final String email;
  final String name;
  final String accessToken;

  const UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.accessToken,
  });

  // JSON
  UserModel.fromJson(Map<String, dynamic> json)
    : userId = json['userId'],
      email = json['email'],
      name = json['nickname'],
      accessToken = json['accessToken'];

  // JSON 일부 + 값 입력
  factory UserModel.fromJsonWithCustom({
    required Map<String, dynamic> json,
    required String name,
    required String email,
  }) {
    return UserModel(
      userId: json['userId'],
      email: email,
      name: name,
      accessToken: json['accessToken'],
    );
  }
}
