import 'package:flutter/material.dart';
import 'package:sense_voka/screens/mywordbook_screen.dart';
import 'package:sense_voka/widgets/word_section_widget.dart';

import '../models/word_preview_model.dart';

class MainWordBookScreen extends StatefulWidget {
  final String setName;
  final int wordCount;

  const MainWordBookScreen({
    super.key,
    required this.setName,
    required this.wordCount,
  });

  @override
  State<MainWordBookScreen> createState() => _MainWordBookScreenState();
}

class _MainWordBookScreenState extends State<MainWordBookScreen> {
  //단어장 정렬 방법
  final List<String> _sortAlgorithm = ["입력 순", "알파벳 순", "랜덤 정렬"];
  String? _selectedSort = "";

  final List<WordPreviewModel> wordPreviewList = [
    WordPreviewModel(wordId: 1, word: "apple", meaning: "[명] 사과"),
    WordPreviewModel(wordId: 2, word: "book", meaning: "[명] 책"),
    WordPreviewModel(wordId: 3, word: "car", meaning: "[명] 자동차"),
    WordPreviewModel(wordId: 4, word: "dog", meaning: "[명] 개"),
    WordPreviewModel(wordId: 5, word: "elephant", meaning: "[명] 코끼리"),
    WordPreviewModel(wordId: 6, word: "flower", meaning: "[명] 꽃"),
    WordPreviewModel(wordId: 7, word: "grape", meaning: "[명] 포도"),
    WordPreviewModel(wordId: 8, word: "house", meaning: "[명] 집"),
    WordPreviewModel(wordId: 9, word: "ice", meaning: "[명] 얼음"),
    WordPreviewModel(wordId: 10, word: "juice", meaning: "[명] 주스"),
    WordPreviewModel(wordId: 11, word: "kite", meaning: "[명] 연"),
    WordPreviewModel(wordId: 12, word: "lion", meaning: "[명] 사자"),
    WordPreviewModel(wordId: 13, word: "moon", meaning: "[명] 달"),
    WordPreviewModel(wordId: 14, word: "notebook", meaning: "[명] 공책"),
    WordPreviewModel(wordId: 15, word: "orange", meaning: "[명] 오렌지"),
    WordPreviewModel(wordId: 16, word: "pencil", meaning: "[명] 연필"),
    WordPreviewModel(wordId: 17, word: "queen", meaning: "[명] 여왕"),
    WordPreviewModel(wordId: 18, word: "rabbit", meaning: "[명] 토끼"),
    WordPreviewModel(wordId: 19, word: "sun", meaning: "[명] 태양"),
    WordPreviewModel(wordId: 20, word: "tree", meaning: "[명] 나무"),
    WordPreviewModel(wordId: 21, word: "umbrella", meaning: "[명] 우산"),
    WordPreviewModel(wordId: 22, word: "violin", meaning: "[명] 바이올린"),
    WordPreviewModel(wordId: 23, word: "whale", meaning: "[명] 고래"),
    WordPreviewModel(wordId: 24, word: "xylophone", meaning: "[명] 실로폰"),
    WordPreviewModel(wordId: 25, word: "yogurt", meaning: "[명] 요구르트"),
    WordPreviewModel(wordId: 26, word: "zebra", meaning: "[명] 얼룩말"),
    WordPreviewModel(wordId: 27, word: "ball", meaning: "[명] 공"),
    WordPreviewModel(wordId: 28, word: "candle", meaning: "[명] 양초"),
    WordPreviewModel(wordId: 29, word: "desk", meaning: "[명] 책상"),
    WordPreviewModel(wordId: 30, word: "ear", meaning: "[명] 귀"),
    WordPreviewModel(wordId: 31, word: "fan", meaning: "[명] 선풍기"),
    WordPreviewModel(wordId: 32, word: "glove", meaning: "[명] 장갑"),
    WordPreviewModel(wordId: 33, word: "hat", meaning: "[명] 모자"),
    WordPreviewModel(wordId: 34, word: "island", meaning: "[명] 섬"),
    WordPreviewModel(wordId: 35, word: "jacket", meaning: "[명] 재킷"),
    WordPreviewModel(wordId: 36, word: "key", meaning: "[명] 열쇠"),
    WordPreviewModel(wordId: 37, word: "lamp", meaning: "[명] 램프"),
    WordPreviewModel(wordId: 38, word: "mirror", meaning: "[명] 거울"),
    WordPreviewModel(wordId: 39, word: "necklace", meaning: "[명] 목걸이"),
    WordPreviewModel(wordId: 40, word: "ocean", meaning: "[명] 바다"),
    WordPreviewModel(wordId: 41, word: "piano", meaning: "[명] 피아노"),
    WordPreviewModel(wordId: 42, word: "quilt", meaning: "[명] 누비이불"),
    WordPreviewModel(wordId: 43, word: "ring", meaning: "[명] 반지"),
    WordPreviewModel(wordId: 44, word: "sock", meaning: "[명] 양말"),
    WordPreviewModel(wordId: 45, word: "telephone", meaning: "[명] 전화기"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedSort = _sortAlgorithm[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 40),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => MyWordBookScreen(),
                fullscreenDialog: true,
              ),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF983D),
        foregroundColor: Colors.white,
        //app bar 그림자 생기게 하기
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        //
        title: Text(
          widget.setName,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "총 ${widget.wordCount}개",
                    style: TextStyle(fontSize: 19),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 35,
                    decoration: BoxDecoration(color: Color(0xFFE8E8E8)),
                    child: DropdownButton(
                      dropdownColor: Color(0xFFE8E8E8),
                      underline: SizedBox.shrink(),
                      value: _selectedSort,
                      items:
                          _sortAlgorithm
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSort = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // 구간 목록
              //generate : 길이가 n인 리스트 자동 생성 -> 구간 개수만큼 리스트에 위젯 저장
              //ceil : 반올림 함수 => 단어를 10개씩 나누어 구간 생성
              ...List.generate((widget.wordCount / 10).ceil(), (i) {
                int startIndex = i * 10; //구간 시작 단어 인덱스
                int endIndex = (i + 1) * 10; //구간 끝 단어 인덱스
                if (endIndex > widget.wordCount) {
                  endIndex = widget.wordCount; //전체 단어 길이를 초과했을 때, 길이만큼으로 다시 제한
                }

                //구간 내 단어 리스트 생성
                List<WordPreviewModel> sectionWords = wordPreviewList.sublist(
                  startIndex,
                  endIndex,
                );

                //단어 리스트를 포함하는 위젯 생성
                return Column(
                  children: [
                    SizedBox(height: 20),
                    WordSectionWidget(
                      sectionIndex: i,
                      startIndex: startIndex,
                      endIndex: endIndex,
                      wordCount: sectionWords.length,
                      wordList: sectionWords,
                    ),
                  ],
                );
              }),

              //구간 내용
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: AnimatedSize(
              //     duration: Duration(milliseconds: 300),
              //     curve: Curves.easeInOut,
              //     clipBehavior: Clip.hardEdge,
              //     alignment: Alignment.topCenter,
              //     child:
              //         _isExpanded
              //             ? Container(
              //               width: double.infinity, //너비 고정
              //               padding: EdgeInsets.symmetric(
              //                 vertical: 10,
              //                 horizontal: 17,
              //               ),
              //               child: Column(
              //                 children:
              //                     wordList.map((entry) {
              //                       final index = wordList.indexOf(entry);
              //                       return Padding(
              //                         padding: const EdgeInsets.symmetric(
              //                           vertical: 0,
              //                         ),
              //                         child: Column(
              //                           children: [
              //                             Row(
              //                               children: [
              //                                 Expanded(
              //                                   flex: 1,
              //                                   child: Text(
              //                                     '${index + 1}',
              //                                     style: TextStyle(
              //                                       fontSize: 13,
              //                                       fontWeight: FontWeight.bold,
              //                                       color: Colors.black38,
              //                                     ),
              //                                   ),
              //                                 ),
              //                                 Expanded(
              //                                   flex: 6,
              //                                   child: Text(
              //                                     '${entry['word']}',
              //                                     style: TextStyle(
              //                                       fontWeight: FontWeight.w800,
              //                                       fontSize: 20,
              //                                     ),
              //                                   ),
              //                                 ),
              //                                 Expanded(
              //                                   flex: 4,
              //                                   child: Text(entry['meaning']!),
              //                                 ),
              //                               ],
              //                             ),
              //                             Divider(
              //                               color: Colors.black12,
              //                               thickness: 1.0,
              //                               height: 8.0,
              //                             ),
              //                           ],
              //                         ),
              //                       );
              //                     }).toList(),
              //               ),
              //             )
              //             : SizedBox.shrink(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
