import 'package:flutter/material.dart';

import '../core/global_variables.dart';
import '../models/word_book_info_model.dart';
import '../models/word_preview_model.dart';
import '../services/mywordbooks_service.dart';
import '../styles/error_snack_bar_style.dart';
import '../widgets/show_dialog_widget.dart';

class MyWordbookListProvider with ChangeNotifier {
  List<WordBookInfoModel> _tempWordSets = [];
  BuildContext? _context; // 에러 처리용 context
  VoidCallback? _onApiComplete; // API 완료 시 호출할 콜백

  List<WordBookInfoModel> get wordSets => _tempWordSets;

  // Context와 콜백 설정
  void setContext(BuildContext context, VoidCallback onApiComplete) {
    _context = context;
    _onApiComplete = onApiComplete;
  }

  //단어장 생성 api 호출 중 임시 버튼 생성
  int addWordSet({
    required String title,
    required List<WordPreviewModel> words,
  }) {
    // 임시 ID 생성
    int tempId = DateTime.now().millisecondsSinceEpoch;

    final tempWordbook = WordBookInfoModel(
      wordBookId: tempId,
      title: title,
      wordCount: words.length,
      createDate: DateTime.now(),
      lastAccess: DateTime.now(),
      isLoading: true,
    );

    _tempWordSets.add(tempWordbook);
    notifyListeners(); //상태 변경 알림 -> UI 업데이트

    // 백그라운드에서 API 호출
    _postWordbook(tempId, title, words);

    return tempId;
  }

  //단어장 생성 api 호출
  Future<void> _postWordbook(
    int tempId,
    String title,
    List<WordPreviewModel> words,
  ) async {
    try {
      var result = await MywordbooksService.postNewMyWordBook(
        title: title,
        words: words,
        country: voiceCountry.name,
      );

      if (result.isSuccess) {
        // 메인 리스트 갱신 요청
        removeWordSet(tempId);
        _onApiComplete?.call(); // 메인 화면의 _getWordSet() 호출
      } else {
        // 실패시 임시 단어장 제거
        removeWordSet(tempId);
        _handleApiError(result);
      }
    } catch (e) {
      // 임시 단어장 제거
      removeWordSet(tempId);

      debugPrint('단어장 생성 중 예외 발생: $e');
    }
  }

  //임시 단어장 삭제
  void removeWordSet(int id) {
    _tempWordSets.removeWhere((w) => w.wordBookId == id);
    notifyListeners(); //상태 변경 알림 -> UI 업데이트
  }

  // 모든 임시 단어장 삭제
  void clearTempWordSets() {
    _tempWordSets.clear();
    notifyListeners();
  }

  // API 에러 처리
  void _handleApiError(dynamic result) {
    if (_context == null) return;

    if (result.title == "오류 발생") {
      ScaffoldMessenger.of(
        _context!,
      ).showSnackBar(errorSnackBarStyle(context: _context!, result: result));
    } else if (result.title == "Token 재발급") {
      // 토큰 재발급 및 재실행 과정
      // 토큰 재발급 로직 구현!
    } else {
      showDialogWidget(
        context: _context!,
        title: result.title,
        msg: result.msg,
      );
    }
  }
}
