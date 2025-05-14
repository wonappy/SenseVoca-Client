import 'package:flutter/material.dart';

Future<bool?> showConfirmDialogWidget({
  required BuildContext context,
  required String title,
  required String msg,
}) async {
  return showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Color(0xFFFDF3EB)),
              ),
              child: Text(
                '취소',
                style: TextStyle(
                  color: Color(0xFFFF983D),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Color(0xFFFDF3EB)),
              ),
              child: Text(
                '확인',
                style: TextStyle(
                  color: Color(0xFFFF983D),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
          content: Text(msg, style: TextStyle(fontSize: 20)),
        ),
  );
}
