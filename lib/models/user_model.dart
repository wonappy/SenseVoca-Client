class UserModel {
  final String email;
  final String pw;
  final String name;

  const UserModel({required this.email, required this.pw, required this.name});

  //api용
  UserModel.fromJson(Map<String, dynamic> json)
    : email = json['email'],
      pw = json['password'],
      name = json['nickName'];
}
