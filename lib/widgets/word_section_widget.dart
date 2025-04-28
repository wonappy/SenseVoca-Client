//나만의 단어장 구간 위젯
import 'package:flutter/material.dart';
import 'package:sense_voka/widgets/word_section_body.dart';
import 'package:sense_voka/widgets/word_section_header.dart';

import '../models/word_preview_model.dart';

class WordSectionWidget extends StatefulWidget {
  final int sectionIndex;
  final int startIndex;
  final int endIndex;
  final int wordCount;
  final List<WordPreviewModel> wordList;
  final VoidCallback onStudyFinished;

  const WordSectionWidget({
    super.key,
    required this.sectionIndex,
    required this.startIndex,
    required this.endIndex,
    required this.wordCount,
    required this.wordList,
    required this.onStudyFinished,
  });

  @override
  State<WordSectionWidget> createState() => _WordSectionWidgetState();
}

class _WordSectionWidgetState extends State<WordSectionWidget>
    with TickerProviderStateMixin {
  bool isExpended = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WordSectionHeader(
          sectionNumber: widget.sectionIndex + 1,
          wordCount: widget.wordCount,
          isExpended: isExpended,
          onToggle: () {
            setState(() {
              isExpended = !isExpended;
            });
          },
          onStartWordStudy: widget.onStudyFinished,
          //     () async {
          //   //pop될 때 값을 전달받아옴
          //   final studyScreenResult = await Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder:
          //           (context) => WordStudyScreen(
          //             wordList:
          //                 widget.wordList
          //                     .map((e) => e.wordId)
          //                     .toList(), //단어 Id만 넘김
          //             sectionIndex: widget.sectionIndex,
          //             wordCount: widget.wordCount,
          //           ),
          //       fullscreenDialog: true,
          //     ),
          //   );
          //
          //   // //result 조사해서 콜백함수 실행!!
          //   // if (studyScreenResult is Map) {
          //   //   //다음 구간 이동, 한 번 더 복습을 위해 pop된.....
          //   //   if (studyScreenResult['button'] == 'nextSection' ||
          //   //       studyScreenResult['button'] == 'retry') {
          //   //     widget.onStudyFinished?.call(
          //   //       studyScreenResult,
          //   //     ); //콜백함수.call(매개변수);
          //   //   }
          //   // }
          // },
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.topCenter,
          child:
              isExpended
                  ? WordSectionBody(wordList: widget.wordList)
                  : SizedBox.shrink(),
        ),
      ],
    );
  }
}
