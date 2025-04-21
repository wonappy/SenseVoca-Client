import 'package:flutter/material.dart';
import 'package:sense_voka/screens/main_wordbook_screen.dart';
import 'package:sense_voka/screens/mywordbook_screen.dart';

class OrangeButton extends StatelessWidget {
  final String text;
  final double bWidth;
  final double bHeight;

  const OrangeButton({
    super.key,
    required this.text,
    required this.bWidth,
    required this.bHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyWordBookScreen(),
            fullscreenDialog: true,
          ),
        );
      },
      style: ButtonStyle(
        animationDuration: Duration.zero, //foregroundColor 글자 색상 변경 애니메이션 제거
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return Colors.white;
          }
          return Colors.black;
        }),
        backgroundColor:
            WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
              WidgetState.focused | WidgetState.hovered: Color(0xFFFF983D),
              WidgetState.any: Colors.white,
            }),
        overlayColor:
            WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
              WidgetState.focused |
                  WidgetState.pressed |
                  WidgetState.hovered: Color(0xFFFF983D),
              WidgetState.any: Colors.white,
            }),
        minimumSize: WidgetStateProperty.all(Size(bWidth, bHeight)),
        side: WidgetStateProperty.all(
          BorderSide(color: Color(0xFFFF983D), width: 2),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        elevation: WidgetStateProperty.all(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 33,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
    );
  }
}
