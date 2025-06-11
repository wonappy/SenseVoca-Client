class ApiResponseModel {
  final bool isSuccess;
  final String? title;
  final String? msg;
  final dynamic data;

  ApiResponseModel({
    required this.isSuccess,
    this.title,
    this.msg,
    this.data,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      isSuccess: json['isSuccess'] ?? false,
      title: json['title'],
      msg: json['msg'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'title': title,
      'msg': msg,
      'data': data,
    };
  }
}