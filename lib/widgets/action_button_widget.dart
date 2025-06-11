import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  final double bHeight;
  final double bWidth;
  final Color? foregroundColor; //버튼 글자 색상
  final Color? backgroundColor; //버튼 배경 색상
  final double? borderSide; //테두리 굵기
  final double? borderRadius; //모서리 둥글기
  final double? elevation; //그림자
  final String text; //글자
  final double? fontSize; //글자 크기
  final FontWeight? fontWeight; //글자 굵기
  final dynamic onPressed; //버튼 Action 함수

  const ActionButtonWidget({
    super.key,
    required this.onPressed,
    required this.bHeight,
    required this.bWidth,
    required this.text,
    this.fontSize,
    this.foregroundColor,
    this.backgroundColor,
    this.fontWeight,
    this.borderSide,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        animationDuration: Duration.zero,
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return Colors.white;
          }
          return (foregroundColor != null) ? foregroundColor! : Colors.black;
        }),
        backgroundColor:
            WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
              WidgetState.focused | WidgetState.hovered: Color(0xFFFF983D),
              WidgetState.any:
                  (backgroundColor != null) ? backgroundColor! : Colors.white,
            }),
        overlayColor:
            WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
              WidgetState.focused |
                  WidgetState.pressed |
                  WidgetState.hovered: Color(0xFFFF983D),
              WidgetState.any: Colors.transparent,
            }),
        minimumSize: WidgetStateProperty.all(Size(bWidth, bHeight)),
        side: WidgetStateProperty.all(
          BorderSide(
            color: Color(0xFFFF983D),
            width: (borderSide != null) ? borderSide! : 3,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              (borderRadius != null) ? borderRadius! : 15,
            ),
          ),
        ),
        elevation: WidgetStateProperty.all((elevation != null) ? elevation : 5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: (fontSize != null) ? fontSize : 10,
          fontWeight: (fontWeight != null) ? fontWeight : FontWeight.w600,
        ),
      ),
    );
  }
}
