import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../enums/app_enums.dart';

class SettingGoalScreen extends StatefulWidget {
  const SettingGoalScreen({super.key});

  @override
  State<SettingGoalScreen> createState() => _SettingGoalScreenState();
}

class _SettingGoalScreenState extends State<SettingGoalScreen> {
  static final storage = FlutterSecureStorage();

  //언어 설정
  int? _selectedCount;

  //언어 종류
  final List<int> _countList = List.generate(100, (index) => (index + 1) * 10);

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initValue();
  }

  //변수 초기화
  void initValue() async {
    try {
      String? storedCount = await storage.read(key: "StudyGoal");
      if (kDebugMode) {
        print("저장소 설정 국가 : $storedCount");
      }
      setState(() {
        _selectedCount = int.tryParse(storedCount!) ?? _countList.first;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _selectedCount = _countList.first;
        isLoading = false;
      });
      if (kDebugMode) {
        print('발음 국가 저장 정보 가져오기 에러: $e');
      }
    }
  }

  // 국가 설정 저장
  void _saveGoalSetting(int count) async {
    try {
      if (kDebugMode) {
        print("설정 변경 학습 목표 : $count");
      }
      await storage.write(key: "StudyGoal", value: count.toString());
    } catch (e) {
      if (kDebugMode) {
        print('학습 목표 변경 에러: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 40,
            color: Color(0xFFFF983D),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        title: SizedBox(
          width: double.infinity,
          child: const Text(
            "단어 학습 관리",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF983D),
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFFFF983D)),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Text(
                          "학습 목표 관리",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.white,
                      highlightColor: Colors.white,
                      onTap: () async {
                        // 필요시 추가 로직
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("1일 학습 단어 개수", style: TextStyle(fontSize: 18)),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  menuMaxHeight:
                                      MediaQuery.of(context).size.height * 0.3,
                                  underline: SizedBox.shrink(),
                                  value: _selectedCount,
                                  items:
                                      _countList
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e.toString()),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedCount = value;
                                      });
                                      _saveGoalSetting(value);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
