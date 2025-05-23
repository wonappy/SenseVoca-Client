import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sense_voka/widgets/essential_wordbook_button_widget.dart';

import '../models/essential_set_info_model.dart';

class EssentialWordBookScreen extends StatefulWidget {
  const EssentialWordBookScreen({super.key});

  @override
  State<EssentialWordBookScreen> createState() =>
      _EssentialWordBookScreenState();
}

class _EssentialWordBookScreenState extends State<EssentialWordBookScreen> {
  //단어장 정렬 방법
  final List<String> _sortAlgorithm = ["기본 제공 순", "최근 접근 순"];
  String? _selectedSort = "";

  //샘플 데이터
  List<EssentialSetInfoModel> wordBooks = [
    EssentialSetInfoModel(
      wordSetId: 1,
      title: "경선식 영단어 (토익)",
      chapterCount: 30,
      provider: "경선식",
      lastAccess: DateTime(2025, 5, 6, 11, 23),
    ),
    EssentialSetInfoModel(
      wordSetId: 2,
      title: "경선식 영단어 (수능)",
      chapterCount: 49,
      provider: "경선식",
      lastAccess: DateTime(2025, 5, 4, 11, 23),
    ),
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

      body: SingleChildScrollView(
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
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSort = value!;
                          if (_selectedSort == "최근 접근 순") {
                            wordBooks.sort(
                              (a, b) => b.lastAccess.compareTo(a.lastAccess),
                            );
                          } else if (_selectedSort == "기본 제공 순") {
                            wordBooks.sort(
                              (a, b) => b.wordSetId.compareTo(a.wordSetId),
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
                      setName: wordBooks[i].title,
                      chapterCount: wordBooks[i].chapterCount,
                      provider: wordBooks[i].provider,
                      lastAccess: DateFormat(
                        "yyyy.MM.dd",
                      ).format(wordBooks[i].lastAccess),
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
}
