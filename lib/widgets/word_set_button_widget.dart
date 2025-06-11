//import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:sense_voka/screens/main_wordbook_screen.dart';
import 'package:sense_voka/screens/wordbook_setting_screen.dart';

import '../enums/app_enums.dart';
import '../models/word_preview_model.dart';

class WordSetButton extends StatelessWidget {
  final int wordbookId;
  final String setName;
  final double bWidth;
  final double bHeight;
  final int wordCount;
  final String lastAccess;
  final VoidCallback? onWordbookChanged;

  const WordSetButton({
    super.key,
    required this.wordbookId,
    required this.bWidth,
    required this.bHeight,
    required this.setName,
    required this.wordCount,
    required this.lastAccess,
    this.onWordbookChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MainWordBookScreen(
                  type: WordBook.my,
                  wordbookId: wordbookId,
                  setName: setName,
                  //wordCount: wordCount,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setName,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(fontSize: 33, fontWeight: FontWeight.w800),
                ),
                Text(
                  "$wordCount 단어 | 마지막 접근 $lastAccess",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(0),
             onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordBookSettingScreen(wordbookId: wordbookId, setName: setName),
                  fullscreenDialog: true,
                ),
              );
              // 단어장 환경 설정 -> 수정 or 삭제 발생 시 callback 호출
              if (result != null) {
                onWordbookChanged?.call();
              }
            },
            icon: Icon(Icons.settings, size: 50),
          ),
        ],
      ),
    );
  }
}
