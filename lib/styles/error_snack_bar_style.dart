import 'package:flutter/material.dart';

import '../models/api_response.dart';

SnackBar errorSnackBarStyle({
  required BuildContext context,
  required ApiResponseModel result,
}) {
  return SnackBar(
    backgroundColor: Colors.red[400],
    duration: Duration(seconds: 2),
    content: Text("오류가 발생하였습니다."),
    action: SnackBarAction(
      label: "더보기",
      textColor: Colors.white,
      onPressed: () {
        //에러 상세 정보
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "에러 상세 정보",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(result.msg, style: TextStyle(fontSize: 14)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("닫기"),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  );
}
