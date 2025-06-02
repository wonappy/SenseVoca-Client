import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:sense_voka/screens/essential_chapters_screen.dart';

class EssentialWordBookButton extends StatefulWidget {
  final int setId;
  final String setName;
  final int chapterCount;
  final String provider;

  const EssentialWordBookButton({
    super.key,
    required this.setId,
    required this.setName,
    required this.chapterCount,
    required this.provider,
  });

  @override
  State<EssentialWordBookButton> createState() =>
      _EssentialWordBookButtonState();
}

class _EssentialWordBookButtonState extends State<EssentialWordBookButton> {
  final double _width = 360;
  final double _height = 90;

  //
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          isPressed = false;
        });
      },
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => EssentialChaptersScreen(
                    wordBookId: widget.setId,
                    title: widget.setName,
                    chapterCount: widget.chapterCount,
                  ),
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
          backgroundColor: WidgetStateProperty<Color>.fromMap(
            <WidgetStatesConstraint, Color>{
              WidgetState.focused | WidgetState.hovered: Color(0xFFFF983D),
              WidgetState.any: Colors.white,
            },
          ),
          overlayColor: WidgetStateProperty<Color>.fromMap(
            <WidgetStatesConstraint, Color>{
              WidgetState.focused |
                  WidgetState.pressed |
                  WidgetState.hovered: Color(0xFFFF983D),
              WidgetState.any: Colors.white,
            },
          ),
          minimumSize: WidgetStateProperty.all(Size(_width, _height)),
          side: WidgetStateProperty.all(
            BorderSide(color: Color(0xFFFF983D), width: 2),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          elevation: WidgetStateProperty.all(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isPressed
                      ? SizedBox(
                        height: 50,
                        child: Marquee(
                          text: widget.setName,
                          style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.w800,
                          ),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 50.0,
                          startAfter: Duration(milliseconds: 300),
                        ),
                      )
                      : Text(
                        widget.setName,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  Text(
                    "${widget.chapterCount} 챕터 | 제공 ${widget.provider}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Icon(Icons.settings, size: 50),
          ],
        ),
      ),
    );
  }
}
