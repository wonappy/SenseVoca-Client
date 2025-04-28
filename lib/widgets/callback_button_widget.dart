import 'package:flutter/material.dart';

class CallbackButtonWidget extends StatefulWidget {
  final String text;
  final double bWidth;
  final double bHeight;
  final bool? isPressed;
  final VoidCallback? onPressed;

  const CallbackButtonWidget({
    super.key,
    required this.text,
    required this.bWidth,
    required this.bHeight,
    this.isPressed,
    this.onPressed,
  });

  @override
  State<CallbackButtonWidget> createState() => _CallbackButtonWidgetState();
}

class _CallbackButtonWidgetState extends State<CallbackButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        animationDuration: Duration.zero, //foregroundColor 글자 색상 변경 애니메이션 제거
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return Colors.white;
          }
          if (widget.isPressed == true) {
            return Colors.white;
          }
          return Colors.black;
        }),
        backgroundColor:
            (widget.isPressed == null)
                ? WidgetStateProperty<Color>.fromMap(<
                  WidgetStatesConstraint,
                  Color
                >{
                  WidgetState.focused | WidgetState.hovered: Color(0xFFFF983D),
                  WidgetState.any: Colors.white,
                })
                : WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.pressed) ||
                      states.contains(WidgetState.hovered)) {
                    return Color(0xFFFF983D);
                  }
                  if (widget.isPressed == true) {
                    return Color(0xFFFF983D);
                  }
                  return Colors.white;
                }),
        overlayColor:
            WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
              WidgetState.focused |
                  WidgetState.pressed |
                  WidgetState.hovered: Color(0xFFFF983D),
              WidgetState.any: Colors.white,
            }),
        minimumSize: WidgetStateProperty.all(
          Size(widget.bWidth, widget.bHeight),
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: Color(0xFFFF983D), width: 2),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        elevation: WidgetStateProperty.all(5),
      ),
      child: Text(
        widget.text,
        style: TextStyle(fontSize: 33, fontWeight: FontWeight.w800),
      ),
    );
  }
}
