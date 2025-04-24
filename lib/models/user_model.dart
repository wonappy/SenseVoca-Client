class UserModel {
  final int userId;
  final String email;
  final String pw;
  final String name;
  final String accessToken;

  const UserModel({
    required this.userId,
    required this.email,
    required this.pw,
    required this.name,
    required this.accessToken,
  });

  // JSON
  UserModel.fromJson(Map<String, dynamic> json)
    : userId = json['userId'],
      email = json['email'],
      pw = json['password'],
      name = json['nickName'],
      accessToken = json['accessToken'];

  // JSON 일부 + 값 입력
  factory UserModel.fromJsonWithCustom({
    required Map<String, dynamic> json,
    required String name,
    required String email,
    required String password,
  }) {
    return UserModel(
      userId: json['userId'],
      email: email,
      pw: password,
      name: name,
      accessToken: json['accessToken'],
    );
  }
}
