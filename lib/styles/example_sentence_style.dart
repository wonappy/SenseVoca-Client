import 'package:flutter/material.dart';

List<TextSpan> exampleSentenceStyle(String text, bool isMnemonic) {
  final RegExp pattern =
      isMnemonic
          ? RegExp(r'(\[[^\]]+\]|\{[^}]+\})')
          : RegExp(r'\[[^\]]+\]'); //정규표현식으로 패턴 표현
  final List<TextSpan> spans = [];

  int start = 0;

  //일반 글자
  for (final match in pattern.allMatches(text)) {
    if (match.start > start) {
      spans.add(
        TextSpan(
          text: text.substring(start, match.start),
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
    }

    final matchedText = match.group(0)!;
    final content = matchedText.substring(1, matchedText.length - 1); // 괄호 제거

    //괄호 사이 글자 서식
    TextStyle style =
        matchedText.startsWith('[')
            ? TextStyle(
              fontSize: isMnemonic ? 18 : 16,
              color: Color(0xFFFF983D),
              fontWeight: isMnemonic ? FontWeight.w800 : FontWeight.normal,
            ) // 발음
            : TextStyle(fontSize: 16, color: Colors.blueAccent); // 의미

    spans.add(TextSpan(text: content, style: style));

    start = match.end;
  }

  //일반 글자
  if (start < text.length) {
    spans.add(
      TextSpan(
        text: text.substring(start),
        style: TextStyle(fontSize: 17, color: Colors.black),
      ),
    );
  }

  return spans;
}
