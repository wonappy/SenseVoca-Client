class UserModel {
  final String id;
  final String pw;
  final String name;

  const UserModel({required this.id, required this.pw, required this.name});

  //api용
  UserModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      pw = json['pw'],
      name = json['name'];
}
