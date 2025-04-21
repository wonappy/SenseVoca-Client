import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/word_set_info_model.dart';
import '../widgets/word_set_button_widget.dart';

class MyWordBookScreen extends StatefulWidget {
  const MyWordBookScreen({super.key});

  @override
  State<MyWordBookScreen> createState() => _MyWordBookScreenState();
}

class _MyWordBookScreenState extends State<MyWordBookScreen> {
  //단어장 정렬 방법
  final List<String> _sortAlgorithm = ["생성 순", "최근 접근 순"];
  String? _selectedSort = "";

  final List<WordSetInfoModel> wordSet = [
    WordSetInfoModel(
      wordSetId: 1,
      title: "나만의 단어장 1",
      wordCount: 45,
      createDate: DateTime(2025, 3, 4, 11, 20),
      lastAccess: DateTime(2025, 3, 4, 11, 23),
    ),
    WordSetInfoModel(
      wordSetId: 2,
      title: "나만의 단어장 2",
      wordCount: 37,
      createDate: DateTime(2025, 3, 4, 11, 21),
      lastAccess: DateTime(2025, 3, 5, 21, 6),
    ),
    WordSetInfoModel(
      wordSetId: 3,
      title: "나만의 단어장 3",
      wordCount: 21,
      createDate: DateTime(2025, 3, 5, 14, 21),
      lastAccess: DateTime(2025, 3, 7, 21, 33),
    ),
    WordSetInfoModel(
      wordSetId: 4,
      title: "나만의 단어장 4",
      wordCount: 78,
      createDate: DateTime(2025, 3, 5, 15, 11),
      lastAccess: DateTime(2025, 3, 5, 2, 6),
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
            child: Icon(Icons.add, size: 50, color: Colors.white),
            onPressed: () {},
          ),
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
                  Text("총 ${wordSet.length}개", style: TextStyle(fontSize: 19)),
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
                            wordSet.sort(
                              (a, b) => b.lastAccess.compareTo(a.lastAccess),
                            );
                          } else if (_selectedSort == "생성 순") {
                            wordSet.sort(
                              (a, b) => a.createDate.compareTo(b.createDate),
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
                    WordSetButton(
                      setName: wordSet[i].title,
                      wordCount: wordSet[i].wordCount,
                      lastAccess: DateFormat(
                        "yyyy.MM.dd",
                      ).format(wordSet[i].lastAccess),
                      bWidth: 360,
                      bHeight: 90,
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
