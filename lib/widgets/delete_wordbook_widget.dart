import 'package:flutter/material.dart';

class DeleteWordbookWidget extends StatelessWidget {
  final String text;
  final double bWidth;
  final double bHeight;
  final double? fontSize;
  final VoidCallback onPressed;

  // 색상 상수
  static const Color _deleteColor = Color(0xFFE16037);
  static const Color _backgroundColor = Colors.white;
  static const Color _textColor = Colors.white;
  static const Color _defaultTextColor = Color(0xFFE16037);
  static const Color _borderColor = Color(0xFFE16037);

  const DeleteWordbookWidget({
    super.key,
    required this.text,
    required this.bWidth,
    required this.bHeight,
    this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // 버튼이 눌렸을 때 이벤트
      onPressed: onPressed,
      // 버튼 Style
      style: ButtonStyle(
        animationDuration: Duration.zero, // 글자 색상 변경 애니메이션 X
        // 글자색
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          // 버튼이 눌렸을 때
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return _textColor;
          }
          // 기본 상태
          return _defaultTextColor;
        }),
        backgroundColor:
        WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
          WidgetState.focused | WidgetState.hovered: _deleteColor, // 버튼이 눌렸을 때
          WidgetState.any: _backgroundColor, // 기본 상태
        }),
        overlayColor: WidgetStateProperty<Color>.fromMap({
          WidgetState.focused | WidgetState.pressed | WidgetState.hovered: _deleteColor,
          WidgetState.any: _backgroundColor,
        }),
        minimumSize: WidgetStateProperty.all(Size(bWidth, bHeight)),
        side: WidgetStateProperty.all(
          const BorderSide(color: _borderColor, width: 3),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        ),
        elevation: WidgetStateProperty.all(5),
      ),
      // 버튼 Text
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 33,
          fontWeight: FontWeight.w800,
        ),
        semanticsLabel: '$text 버튼', // 접근성을 위한 라벨
      ),
    );
  }
}