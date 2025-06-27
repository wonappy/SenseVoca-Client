import 'package:flutter/material.dart';

List<TextSpan> exampleSentenceStyle(String text, bool isMnemonic) {
  final RegExp pattern =
      isMnemonic
          ? RegExp(r'(\[[^\]]+\]|<[^>]+>|＜[^＞]+＞|\([^)]+\))')
          : RegExp(r'\[[^\]]+\]');

  final List<TextSpan> spans = [];
  int start = 0;

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
    final content = matchedText.substring(1, matchedText.length - 1);

    TextStyle style;

    if (matchedText.startsWith('[')) {
      style = TextStyle(
        fontSize: isMnemonic ? 18 : 16,
        color: Color(0xFFFF983D),
        fontWeight: isMnemonic ? FontWeight.w800 : FontWeight.normal,
      );
    } else if (matchedText.startsWith('<') || matchedText.startsWith('＜')) {
      style = TextStyle(
        fontSize: 18,
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = TextStyle(fontSize: 13, color: Colors.grey);
    }

    spans.add(TextSpan(text: content, style: style));
    start = match.end;
  }

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
