import 'package:flutter/material.dart';
import 'package:sense_voka/models/api_response.dart';

Future<void> showDialogWidget({
  required BuildContext context,
  required String title,
  required String msg,
}) async {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
          title: Text(title),
          content: Text(msg),
        ),
  );
}
