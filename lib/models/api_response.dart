//api 결과 dialog용 class
class ApiResponseModel {
  final bool isSuccess;
  final String title;
  final String msg;

  const ApiResponseModel({
    required this.isSuccess,
    required this.title,
    required this.msg,
  });
}
