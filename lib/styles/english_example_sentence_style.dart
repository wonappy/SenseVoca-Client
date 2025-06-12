import 'package:flutter/material.dart';

List<TextSpan> englishExampleSentenceStyle(String text, String highlightWord) {
  final List<TextSpan> spans = [];
  int start = 0;

  // 복수형, 과거형, 진행형 등 변형 포함 강조 (단어 경계 유지)
  final pattern = RegExp(
    r'\b' + RegExp.escape(highlightWord) + r"(?:'s|s|es|ed|ing)?\b",
    caseSensitive: false,
  );

  for (final match in pattern.allMatches(text)) {
    if (match.start > start) {
      spans.add(
        TextSpan(
          text: text.substring(start, match.start),
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
    }

    spans.add(
      TextSpan(
        text: match.group(0),
        style: TextStyle(fontSize: 16, color: Colors.blueAccent),
      ),
    );

    start = match.end;
  }

  if (start < text.length) {
    spans.add(
      TextSpan(
        text: text.substring(start),
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  return spans;
}
