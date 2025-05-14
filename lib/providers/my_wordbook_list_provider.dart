import 'package:flutter/material.dart';

import '../models/word_set_info_model.dart';

class MyWordbookListProvider with ChangeNotifier {
  List<WordSetInfoModel> wordSets = [
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

  List<WordSetInfoModel> get _wordSets => wordSets;

  //단어장 생성 api 호출 중 임시 버튼 생성
  void addWordSet(WordSetInfoModel wordSet) {
    wordSets.add(wordSet);
    notifyListeners(); //상태 변경 알림 -> UI 업데이트
  }

  //단어장 목록 api 재호출
  void updateWordSet() {
    //단어장 목록 api 호출
    //wordSets 갱신
  }

  //로딩 상태 갱신
  void updateLoading(int id, bool isLoading) {
    final index = wordSets.indexWhere((w) => w.wordSetId == id);
    if (index != -1) {
      wordSets[index].isLoading = isLoading;
      notifyListeners(); //상태 변경 알림 -> UI 업데이트
    }
  }

  //단어장 삭제
  void removeWordSet(int id) {
    wordSets.removeWhere((w) => w.wordSetId == id);
    notifyListeners(); //상태 변경 알림 -> UI 업데이트
  }
}
