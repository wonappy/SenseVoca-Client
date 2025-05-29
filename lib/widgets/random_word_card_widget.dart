import 'package:flutter/material.dart';

class RandomWordCardWidget extends StatefulWidget {
  final String word; //단어
  final String meaning; //단어 뜻
  final bool isPressed; //버튼 눌림 여부
  final VoidCallback? onPressed; //버튼 눌림 상태 여부

  const RandomWordCardWidget({
    super.key,
    required this.word,
    required this.meaning,
    required this.isPressed,
    this.onPressed,
  });

  @override
  State<RandomWordCardWidget> createState() => _RandomWordCardWidgetState();
}

class _RandomWordCardWidgetState extends State<RandomWordCardWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        animationDuration: Duration.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
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
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
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
              WidgetState.any: Colors.transparent,
            }),
        minimumSize: WidgetStateProperty.all(Size(0, 0)),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(color: Color(0xFFFF983D), width: 3);
          }
          if (widget.isPressed == true) {
            return BorderSide(color: Color(0xFFFF983D), width: 3);
          }
          return BorderSide(color: Colors.black12, width: 2);
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        elevation: WidgetStateProperty.all(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.word,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            widget.meaning.replaceAll('; ', '\n'),
            textAlign: TextAlign.center,
            softWrap: true, //자동 줄바꿈 허용
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 8,
              fontWeight: widget.isPressed ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
