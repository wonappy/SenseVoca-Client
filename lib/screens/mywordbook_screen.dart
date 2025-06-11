import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sense_voka/screens/create_mywordcard_screen.dart';
import 'package:sense_voka/screens/create_random_wordbook_screen.dart';
import 'package:sense_voka/services/mywordbooks_service.dart';
import 'package:sense_voka/widgets/callback_button_widget.dart';

import '../enums/app_enums.dart';
import '../models/word_book_info_model.dart';
import '../models/word_preview_model.dart';
import '../styles/error_snack_bar_style.dart';
import '../widgets/show_dialog_widget.dart';
import '../widgets/word_set_button_widget.dart';

class MyWordBookScreen extends StatefulWidget {
  const MyWordBookScreen({super.key});

  @override
  State<MyWordBookScreen> createState() => _MyWordBookScreenState();
}

class _MyWordBookScreenState extends State<MyWordBookScreen> {
  //static final storage = FlutterSecureStorage();

  //단어장 정렬 방법
  final List<String> _sortAlgorithm = ["생성 순", "최근 접근 순"];
  String? _selectedSort = "";

  //단어장 api
  late List<WordBookInfoModel> wordSet;

  //api 호출 상태 -> t: 로딩 중, f: 호출 완료
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      //나만의 단어장 리스트 가져오기
      _getWordSet();
      //정렬 알고리즘 초기화
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
        title: const Text(
          "나만의 단어장",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),
      //단어장 추가 버튼 -> CreateMyWordBookScreen 연결
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            shape: CircleBorder(),
            backgroundColor: Color(0xFFFF983D),
            onPressed: _reloadWordBookList,
            child: Icon(Icons.add, size: 50, color: Colors.white),
          ),
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
                            "총 ${wordSet.length}개",
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
                                    wordSet.sort(
                                      (a, b) =>
                                          b.lastAccess.compareTo(a.lastAccess),
                                    );
                                  } else if (_selectedSort == "생성 순") {
                                    wordSet.sort(
                                      (a, b) =>
                                          a.createDate.compareTo(b.createDate),
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
                      for (int i = 0; i < wordSet.length; i++)
                        Column(
                          children: [
                            Stack(
                              children: [
                                WordSetButton(
                                  wordbookId: wordSet[i].wordBookId,
                                  setName: wordSet[i].title,
                                  wordCount: wordSet[i].wordCount,
                                  lastAccess: DateFormat(
                                    "yyyy.MM.dd",
                                  ).format(wordSet[i].lastAccess),
                                  bWidth: 360,
                                  bHeight: 90,
                                  onWordbookChanged: () { _getWordSet(); },
                                ),
                                if (wordSet[i].isLoading)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
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

  //단어 학습 화면 생성
  Future<void> _reloadWordBookList() async {
    //말풍선 모달 창
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder:
          (context) => Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width * 0.73,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    offset: Offset(0, 8),
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "어떤 방식으로 만들까요?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CallbackButtonWidget(
                        text: "직접 입력",
                        bWidth: MediaQuery.of(context).size.width * 0.09,
                        bHeight: MediaQuery.of(context).size.height * 0.05,
                        fontSize: 20,
                        onPressed:
                            () => _createMyWordBookScreen(
                              destinationScreen: CreateMyWordCardScreen(),
                            ),
                        popBeforePush: true,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      CallbackButtonWidget(
                        text: "랜덤 생성",
                        bWidth: MediaQuery.of(context).size.width * 0.09,
                        bHeight: MediaQuery.of(context).size.height * 0.05,
                        fontSize: 20,
                        onPressed:
                            () => _createMyWordBookScreen(
                              destinationScreen: CreateRandomWordBookScreen(),
                            ),
                        popBeforePush: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  //단어장 생성 화면 호출 및 api 호출 로딩...
  void _createMyWordBookScreen({required Widget destinationScreen}) async {
    final popResult = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationScreen),
    );

    int tempWordBookId = wordSet.last.wordBookId + 99;

    if (popResult is Map) {
      //api 호출
      //호출 결과를 기다리는 동안 표시될 버튼 UI
      final String title = popResult["title"];
      final words = popResult["words"];

      if (kDebugMode) {
        print("제목: $title, 단어: $words");
      }

      WordBookInfoModel newWordbook = WordBookInfoModel(
        wordBookId: tempWordBookId, //아이디가 겹치지 않도록...
        title: title,
        wordCount: words.length,
        createDate: DateTime.now(),
        lastAccess: DateTime.now(),
        isLoading: true,
      );

      setState(() {
        wordSet.add(newWordbook);
      });

      //api 호출 및 결과 처리
      bool result = await _postMyWordBook(
        title: popResult["title"],
        words: popResult["words"],
        country: Country.us,
      );

      if (result) {
        //success -> 단어장 목록 다시 호출
        _getWordSet();
      } else {
        //fail -> 버튼 자체 삭제
        setState(() {
          wordSet.removeWhere((w) => w.wordBookId == tempWordBookId);
        });
      }
    }
  }

  //나만의 단어장 리스트 호출 api
  void _getWordSet() async {
    //로딩 창 출력
    setState(() {
      isLoading = true;
    });

    //api 호출
    var result = await MywordbooksService.getMyWordBookList();

    if (mounted) {
      if (result.isSuccess) {
        setState(() {
          wordSet = result.data;
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

  //나만의 단어장 생성 api
  Future<bool> _postMyWordBook({
    required String title,
    required List<WordPreviewModel> words,
    required Country country,
  }) async {
    //api 호출
    var result = await MywordbooksService.postNewMyWordBook(
      title: title,
      words: words,
      country: country.name,
    );

    if (mounted) {
      if (result.isSuccess) {
        return true;
      } else {
        if (result.title == "오류 발생") {
          //오류 발생
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(errorSnackBarStyle(context: context, result: result));
          return false;
        } else if (result.title == "Token 재발급") {
          //토큰 재발급 및 재실행 과정
        } else {
          //일반 실패 응답
          await showDialogWidget(
            context: context,
            title: result.title,
            msg: result.msg,
          );
          return false;
        }
      }
    }
    return false;
  }
}
