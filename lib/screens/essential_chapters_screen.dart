import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/essential_chapter_info_model.dart';
import '../services/basic_service.dart';
import '../styles/error_snack_bar_style.dart';
import '../widgets/essential_chapter_button_widget.dart';
import '../widgets/show_dialog_widget.dart';

class EssentialChaptersScreen extends StatefulWidget {
  final int wordBookId;
  final String title;
  final int chapterCount;

  const EssentialChaptersScreen({
    super.key,
    required this.wordBookId,
    required this.title,
    required this.chapterCount,
  });

  @override
  State<EssentialChaptersScreen> createState() =>
      _EssentialChaptersScreenState();
}

class _EssentialChaptersScreenState extends State<EssentialChaptersScreen> {
  //단어장 정렬 방법
  final List<String> _sortAlgorithm = ["기본 제공 순", "최근 접근 순"];
  String? _selectedSort = "";

  //api 호출 상태 -> t: 로딩 중, f: 호출 완료
  bool isLoading = true;

  //샘플 데이터
  List<EssentialChapterInfoModel> chapters = [
    // EssentiaChapterInfoModel(
    //   chapterId: 1,
    //   title: "DAY 1",
    //   wordCount: 30,
    //   lastAccess: DateTime(2025, 5, 6, 11, 23),
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 2,
    //   title: "DAY 2",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 3,
    //   title: "DAY 3",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 4,
    //   title: "DAY 4",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 5,
    //   title: "DAY 5",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 6,
    //   title: "DAY 6",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 7,
    //   title: "DAY 7",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 8,
    //   title: "DAY 8",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 9,
    //   title: "DAY 9",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 10,
    //   title: "DAY 10",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 11,
    //   title: "DAY 11",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 12,
    //   title: "DAY 12",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 13,
    //   title: "DAY 13",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 14,
    //   title: "DAY 14",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 15,
    //   title: "DAY 15",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 16,
    //   title: "DAY 16",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 17,
    //   title: "DAY 17",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 18,
    //   title: "DAY 18",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 19,
    //   title: "DAY 19",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 20,
    //   title: "DAY 20",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 21,
    //   title: "DAY 21",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 22,
    //   title: "DAY 22",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 23,
    //   title: "DAY 23",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 24,
    //   title: "DAY 24",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 25,
    //   title: "DAY 25",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 26,
    //   title: "DAY 26",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 27,
    //   title: "DAY 27",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 28,
    //   title: "DAY 28",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 29,
    //   title: "DAY 29",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 30,
    //   title: "DAY 30",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 31,
    //   title: "DAY 31",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 32,
    //   title: "DAY 32",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 33,
    //   title: "DAY 33",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 34,
    //   title: "DAY 34",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 35,
    //   title: "DAY 35",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 36,
    //   title: "DAY 36",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 37,
    //   title: "DAY 37",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 38,
    //   title: "DAY 38",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 39,
    //   title: "DAY 39",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 40,
    //   title: "DAY 40",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 41,
    //   title: "DAY 41",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 42,
    //   title: "DAY 42",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 45,
    //   title: "DAY 45",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 46,
    //   title: "DAY 46",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 47,
    //   title: "DAY 47",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 48,
    //   title: "DAY 48",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
    // EssentiaChapterInfoModel(
    //   chapterId: 49,
    //   title: "DAY 49",
    //   wordCount: 30,
    //   lastAccess: null,
    // ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedSort = _sortAlgorithm[0];
      //챕터 목록 반환 api
      _getBasicChapter(wordBookId: widget.wordBookId);
    });
  }

  //마지막 접근 시간 갱신 -> 버튼이 눌렸을 때를 기준으로
  void updateLastAccess({required int index}) {
    setState(() {
      chapters[index].lastAccess = DateTime.now();
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
            Navigator.pop(context);
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
          widget.title,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),

      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFFFF983D)),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //상단 기본 정보 제공
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "총 ${widget.chapterCount}개",
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
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSort = value!;
                                  if (_selectedSort == "최근 접근 순") {
                                    chapters.sort((a, b) {
                                      //null이 아닌 값들만 위에서부터 정렬하기
                                      if (a.lastAccess == null &&
                                          b.lastAccess != null) {
                                        return 1;
                                      }
                                      if (a.lastAccess != null &&
                                          b.lastAccess == null) {
                                        return -1;
                                      }
                                      if (a.lastAccess == null &&
                                          b.lastAccess == null) {
                                        return a.chapterId.compareTo(
                                          b.chapterId,
                                        );
                                      }
                                      if (a.lastAccess != null &&
                                          b.lastAccess != null) {
                                        return b.lastAccess!.compareTo(
                                          a.lastAccess!,
                                        );
                                      }
                                      return 0;
                                    });
                                  } else if (_selectedSort == "기본 제공 순") {
                                    chapters.sort(
                                      (a, b) =>
                                          a.chapterId.compareTo(b.chapterId),
                                    );
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      //단어장 목록
                      for (int i = 0; i < widget.chapterCount; i++)
                        Column(
                          children: [
                            EssentialChapterButton(
                              wordBookId: widget.wordBookId,
                              chapterId: chapters[i].chapterId,
                              title: chapters[i].title,
                              wordCount: chapters[i].wordCount,
                              lastAccess:
                                  (chapters[i].lastAccess != null)
                                      ? DateFormat(
                                        "yyyy.MM.dd",
                                      ).format(chapters[i].lastAccess!)
                                      : " - ",
                              onPressed: () => updateLastAccess(index: i),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
    );
  }

  //기본 단어장 리스트 호출 api
  void _getBasicChapter({required int wordBookId}) async {
    //로딩 창 출력
    setState(() {
      isLoading = true;
    });

    //api 호출
    var result = await BasicService.getBasicChapterList(wordbookId: wordBookId);

    if (mounted) {
      if (result.isSuccess) {
        setState(() {
          chapters = result.data;
          isLoading = false;
        });
      } else {
        if (result.title == "오류 발생") {
          //오류 발생
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(errorSnackBarStyle(context: context, result: result));
        } else if (result.title == "Token 재발급") {
          //토큰 재발급 및 재실행 과정
        } else {
          //일반 실패 응답
          await showDialogWidget(
            context: context,
            title: result.title,
            msg: result.msg,
          );
        }
      }
    }
  }
}
