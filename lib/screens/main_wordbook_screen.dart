import 'package:flutter/material.dart';
import 'package:sense_voka/screens/mywordbook_screen.dart';
import 'package:sense_voka/screens/word_study_screen.dart';
import 'package:sense_voka/services/basic_service.dart';
import 'package:sense_voka/services/favoritewords_service.dart';
import 'package:sense_voka/widgets/word_section_widget.dart';

import '../enums/app_enums.dart';
import '../models/request_models/word_id_type_model.dart';
import '../models/word_preview_model.dart';
import '../services/mywordbooks_service.dart';
import '../styles/error_snack_bar_style.dart';
import '../widgets/show_dialog_widget.dart';

class MainWordBookScreen extends StatefulWidget {
  final WordBook type;
  final int wordbookId;
  final String setName;

  const MainWordBookScreen({
    super.key,
    required this.type,
    required this.wordbookId,
    required this.setName,
  });

  @override
  State<MainWordBookScreen> createState() => _MainWordBookScreenState();
}

class _MainWordBookScreenState extends State<MainWordBookScreen> {
  //단어장 정렬 방법
  final List<String> _sortAlgorithm = ["입력 순", "알파벳 순", "랜덤 정렬"];
  String? _selectedSort = "";

  //단어 간단 정보 리스트
  late List<WordPreviewModel> wordPreviewList;

  //api 호출 상태 -> t: 로딩 중, f: 호출 완료
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      //단어 미리보기 정보 가져오기
      _getMyWordList(type: widget.type, wordbookId: widget.wordbookId);
      //정렬 초기화
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

      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFFFF983D)),
              )
              : SingleChildScrollView(
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
                            "총 ${wordPreviewList.length}개",
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
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      // 구간 목록
                      //generate : 길이가 n인 리스트 자동 생성 -> 구간 개수만큼 리스트에 위젯 저장
                      //ceil : 반올림 함수 => 단어를 10개씩 나누어 구간 생성
                      ...List.generate((wordPreviewList.length / 10).ceil(), (
                        i,
                      ) {
                        int startIndex = i * 10; //구간 시작 단어 인덱스
                        int endIndex = (i + 1) * 10; //구간 끝 단어 인덱스
                        if (endIndex > wordPreviewList.length) {
                          endIndex =
                              wordPreviewList
                                  .length; //전체 단어 길이를 초과했을 때, 길이만큼으로 다시 제한
                        }

                        //구간 내 단어 리스트 생성
                        List<WordPreviewModel> sectionWords = wordPreviewList
                            .sublist(startIndex, endIndex);

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
                              onStudyFinished:
                                  () => _startStudyScreen(
                                    wordList: sectionWords,
                                    sectionIndex: i,
                                    wordCount: sectionWords.length,
                                  ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
    );
  }

  //위젯 버튼으로 화면 생성 (수동)
  void _startStudyScreen({
    required List<WordPreviewModel> wordList,
    required int sectionIndex,
    required int wordCount,
  }) async {
    await _createNewStudyScreen(
      type: widget.type,
      wordList:
          wordList
              .map((e) => WordIdTypeModel(wordId: e.wordId!, type: e.type))
              .toList(),
      sectionIndex: sectionIndex,
    );
  }

  //다음 구간 이동, 한 번 더 학습으로 인한 변경된 학습 화면 생성 (자동)
  void _navigateStudyScreen(sectionInfo) async {
    String button = sectionInfo['button'];

    //다음 구간 이동
    if (button == 'nextSection') {
      final nextIndex = sectionInfo['currentIndex'] + 1;

      final start = nextIndex * 10;
      final end = (start + 10).clamp(0, wordPreviewList.length);

      if (start < wordPreviewList.length) {
        final nextWords = wordPreviewList.sublist(start, end);

        await _createNewStudyScreen(
          type: widget.type,
          wordList:
              nextWords
                  .map((e) => WordIdTypeModel(wordId: e.wordId!, type: e.type))
                  .toList(),
          sectionIndex: nextIndex,
        );
      } else {
        //다음 구간이 존재하지 않을 경우 경고창 출력
        showDialogWidget(
          context: context,
          title: "단어장 학습 완료!",
          msg: "단어장의 모든 구간을 학습했어요.",
        );
      }
    }
    //한 번 더 학습
    else if (button == 'retry') {
      //인덱스 리스트 캐스팅!!
      final List<dynamic> rawList = sectionInfo['wordList'];
      final retryWordList = rawList.cast<WordIdTypeModel>(); //int로 형 변환
      debugPrint("$retryWordList");

      await _createNewStudyScreen(
        type: widget.type,
        wordList: retryWordList,
        sectionIndex: sectionInfo['currentIndex'],
      );
    }
  }

  //단어 학습 화면 생성
  Future<void> _createNewStudyScreen({
    required WordBook type,
    required List<WordIdTypeModel> wordList,
    required int sectionIndex,
  }) async {
    final studyScreenResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => WordStudyScreen(
              type: type,
              wordList: wordList, //단어 Id리스트
              sectionIndex: sectionIndex, //구간 인덱스
            ),
        fullscreenDialog: true,
      ),
    );

    //result 조사해서 다음 화면 실행!!
    if (studyScreenResult is Map) {
      _navigateStudyScreen(studyScreenResult);
    } else {
      //단어장 재호출
      _getMyWordList(type: widget.type, wordbookId: widget.wordbookId);
    }
  }

  //나만의 단어장 단어 목록 반환 api
  void _getMyWordList({required WordBook type, required int wordbookId}) async {
    //로딩 창 출력
    setState(() {
      isLoading = true;
    });

    //api 호출
    dynamic result;

    if (type == WordBook.basic) {
      result = await BasicService.getBasicWordList(chapterId: wordbookId);
    } else if (type == WordBook.my) {
      result = await MywordbooksService.getMyWordList(wordbookId: wordbookId);
    } else if (type == WordBook.favorite) {
      result = await FavoriteWordsService.getFavoriteWordList();
    }

    if (mounted) {
      if (result.isSuccess) {
        setState(() {
          wordPreviewList = result.data;
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
