import 'package:flutter/material.dart';

class NavigationButtonWidget extends StatelessWidget {
  final String text;
  final double bWidth;
  final double bHeight;
  final double? fontSize;
  final bool? popBeforePush;
  final VoidCallback? onPopped;
  //버튼을 눌렀을 때 이동할 공간
  final Widget destinationScreen;

  const NavigationButtonWidget({
    super.key,
    required this.text,
    required this.bWidth,
    required this.bHeight,
    this.fontSize,
    this.popBeforePush,
    this.onPopped,
    required this.destinationScreen,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (popBeforePush == true) {
          Navigator.pop(context);
        }

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destinationScreen,
            fullscreenDialog: true,
          ),
        );

        //pop 콜백함수가 있다면, 실행
        if (onPopped != null) {
          onPopped!();
        }
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
          fontSize: (fontSize != null) ? fontSize : 33,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
