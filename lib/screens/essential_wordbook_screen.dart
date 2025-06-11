import 'package:flutter/material.dart';
import 'package:sense_voka/services/basic_service.dart';
import 'package:sense_voka/widgets/essential_wordbook_button_widget.dart';

import '../models/essential_set_info_model.dart';
import '../styles/error_snack_bar_style.dart';
import '../widgets/show_dialog_widget.dart';

class EssentialWordBookScreen extends StatefulWidget {
  const EssentialWordBookScreen({super.key});

  @override
  State<EssentialWordBookScreen> createState() =>
      _EssentialWordBookScreenState();
}

class _EssentialWordBookScreenState extends State<EssentialWordBookScreen> {
  //단어장 정렬 방법
  final List<String> _sortAlgorithm = ["기본 제공 순"];
  String? _selectedSort = "";

  //api 호출 상태 -> t: 로딩 중, f: 호출 완료
  bool isLoading = true;

  //샘플 데이터
  late List<EssentialSetInfoModel> wordBooks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedSort = _sortAlgorithm[0];
      //기본 단어장 목록 호출 api
      _getBasicWordSet();
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
          "기본 제공 단어장",
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
                            "총 ${wordBooks.length}개",
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
                                  if (_selectedSort == "기본 제공 순") {
                                    wordBooks.sort(
                                      (a, b) =>
                                          b.wordSetId.compareTo(a.wordSetId),
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
                      for (int i = 0; i < wordBooks.length; i++)
                        Column(
                          children: [
                            EssentialWordBookButton(
                              setId: wordBooks[i].wordSetId,
                              setName: wordBooks[i].title,
                              chapterCount: wordBooks[i].chapterCount,
                              provider: wordBooks[i].provider,
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
  void _getBasicWordSet() async {
    //로딩 창 출력
    setState(() {
      isLoading = true;
    });

    //api 호출
    var result = await BasicService.getBasicWordBookList();

    if (mounted) {
      if (result.isSuccess) {
        setState(() {
          wordBooks = result.data;
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
