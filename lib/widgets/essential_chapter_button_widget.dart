import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../enums/app_enums.dart';
import '../screens/main_wordbook_screen.dart';

class EssentialChapterButton extends StatefulWidget {
  final int wordBookId;
  final int chapterId;
  final String title;
  final int wordCount;
  final String? lastAccess;
  final VoidCallback? onPressed; //마지막 접근 시각 UI 갱신용 콜백 함수

  const EssentialChapterButton({
    super.key,
    required this.wordBookId,
    required this.chapterId,
    required this.title,
    required this.wordCount,
    this.lastAccess,
    this.onPressed,
  });

  @override
  State<EssentialChapterButton> createState() => _EssentialChapterButtonState();
}

class _EssentialChapterButtonState extends State<EssentialChapterButton> {
  final double _width = 360;
  final double _height = 90;

  //버튼 눌림 상태 확인
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
                  (context) => MainWordBookScreen(
                    type: WordBook.basic,
                    wordbookId: widget.chapterId,
                    setName: widget.title,
                    //wordCount: widget.wordCount,
                  ),
              fullscreenDialog: true,
            ),
          );

          if (widget.onPressed != null) {
            widget.onPressed!(); //콜백 함수 발동
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
                          text: widget.title,
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
                        widget.title,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  Text(
                    "${widget.wordCount} 단어 | 마지막 접근 ${widget.lastAccess}",
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
