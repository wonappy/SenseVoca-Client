import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sense_voka/screens/create_mywordcard_screen.dart';
import 'package:sense_voka/screens/create_random_wordbook_screen.dart';
import 'package:sense_voka/services/mywordbooks_service.dart';
import 'package:sense_voka/widgets/callback_button_widget.dart';
import 'package:sense_voka/widgets/delete_wordbook_widget.dart';
import 'package:sense_voka/widgets/textfield_line_widget.dart';
import 'package:sense_voka/screens/main_wordbook_screen.dart';
import '../enums/app_enums.dart';
import '../models/api_response.dart';
import '../models/word_book_info_model.dart';
import '../models/word_preview_model.dart';
import '../styles/error_snack_bar_style.dart';
import '../widgets/show_dialog_widget.dart';
import '../widgets/word_set_button_widget.dart';

class WordBookSettingScreen extends StatefulWidget {
  // 받아올 데이터
  final int wordbookId; // 현재 단어장 ID
  final String setName; // 현재 단어장 제목
  const WordBookSettingScreen({
    super.key,
    required this.wordbookId,
    required this.setName,
  });

  @override
  State<WordBookSettingScreen> createState() => _WordBookSettingScreenState();
}

class _WordBookSettingScreenState extends State<WordBookSettingScreen> {
  // 수정할 제목
  final _newNameController = TextEditingController();
  String newName = "";

  // 받아올 단어 정보 List
  late Future<List<WordPreviewModel>?> wordPreviewListFuture;

  @override
  void initState() {
    super.initState();

    // 새 제목 입력 감지
    _newNameController.addListener(() {
      newName = _newNameController.text;
    });

    // 단어장 ID에 해당하는 단어 정보 List
    wordPreviewListFuture = _getMyWordList(wordbookId: widget.wordbookId);
  }

  // >> API 호출 함수
  // [+] 공통 - 응답 처리
  Future<T?> _handleApiResponse<T>(
    BuildContext context,
    ApiResponseModel result, {
    bool mounted = true,
    String? customErrorContext,
  }) async {
    if (!mounted) {
      throw Exception("[mounted == false] 현재 화면이 위젯 트리에 존재하지 않습니다.");
    }

    if (result.isSuccess) {
      return result.data as T?;
    } else {
      if (result.title == "오류 발생") {
        // 네트워크 오류 등
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(errorSnackBarStyle(context: context, result: result));
        throw Exception(result.title ?? '오류 발생');
      } else if (result.title == "Token 재발급") {
        // 토큰 재발급 필요
        throw Exception(result.title ?? '토큰 재발급');
      } else {
        // 일반 실패 응답
        await showDialogWidget(
          context: context,
          title: result.title,
          msg: result.msg,
        );
        throw Exception(
          result.title ??
              '- context : ${customErrorContext ?? context}\n- title : ${result.title}\n- msg : ${result.msg}',
        );
      }
    }
  }

  // [GET] 나만의 단어장 -> 단어 목록 반환 API
  Future<List<WordPreviewModel>?> _getMyWordList({
    required int wordbookId,
  }) async {
    try {
      // 1) API 호출 (단어장 ID 전달)
      final result = await MywordbooksService.getMyWordList(
        wordbookId: wordbookId,
      );

      // 2) 응답 처리
      return await _handleApiResponse<List<WordPreviewModel>>(
        context,
        result,
        mounted: mounted,
        customErrorContext: '단어 목록 조회',
      );
    } catch (e) {
      rethrow;
    }
  }

  // [DELETE] 나만의 단어장 -> 단어 삭제 API
  Future<bool> _deleteMyWordBookWord({
    required int wordbookId,
    required int wordId,
  }) async {
    try {
      // 1) API 호출 (단어장 ID, 단어 ID 전달)
      final result = await MywordbooksService.deleteMyWordBookWord(
        wordbookId: wordbookId,
        wordId: wordId,
      );

      // 2) 응답 처리
      await _handleApiResponse<dynamic>(
        context,
        result,
        mounted: mounted,
        customErrorContext: '단어 삭제',
      );

      // 3) 단어 삭제 후 리스트 업데이트
      final updatedList = await _getMyWordList(
        wordbookId: wordbookId,
      ); // await 키워드를 사용하면 List 타입, 사용하지 않으면 Future 타입

      if (updatedList != null && updatedList.isNotEmpty && mounted) {
        setState(() {
          wordPreviewListFuture = _getMyWordList(wordbookId: wordbookId);
        });
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }

  // [DELETE] 나만의 단어장 -> 단어장 삭제 API
  Future<bool> _deleteMyWordBook({required int wordbookId}) async {
    try {
      // 1) API 호출 (단어장 ID 전달)
      final result = await MywordbooksService.deleteMyWordBook(
        wordbookId: wordbookId,
      );

      // 2) 응답 처리
      await _handleApiResponse<dynamic>(
        context,
        result,
        mounted: mounted,
        customErrorContext: '단어장 삭제',
      );

      return true;
    } catch (e) {
      rethrow;
    }
  }

  // [PUT] 나만의 단어장 -> 단어장 제목 수정 API
  Future<bool> _putMyWordBookTitle({
    required int wordbookId,
    required String newTitle,
  }) async {
    try {
      // 1) API 호출 (단어장 ID 전달)
      final result = await MywordbooksService.putMyWordBookTitle(
        wordbookId: wordbookId,
        newTitle: newTitle,
      );

      // 2) 응답 처리
      await _handleApiResponse<dynamic>(
        context,
        result,
        mounted: mounted,
        customErrorContext: '단어장 수정',
      );

      return true;
    } catch (e) {
      rethrow;
    }
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () async {
                if (newName.isNotEmpty && newName != widget.setName) {
                  try {
                    // 1) API 호출
                    await _putMyWordBookTitle(
                      wordbookId: widget.wordbookId,
                      newTitle: newName,
                    );

                    // 2) 성공 시 처리 이전 화면으로 돌아감
                    Navigator.pop(context, {
                      "action": "updated",
                      "newName": newName,
                    });
                  } catch (e) {
                    print("단어장 제목 수정 실패 : $e");
                  }
                } else if (newName == widget.setName) {
                  // 동일한 제목일 경우 경고
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("현재 제목과 동일합니다.")));
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.white,
                minimumSize: Size(70, 40),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                "수정",
                style: TextStyle(
                  color: Color(0xFFFF983D),
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Color(0xFFFF983D),
        foregroundColor: Colors.white,
        //app bar 그림자 생기게 하기
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        title: const Text(
          "단어장 설정",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "현재 제목",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 45),
                    Text(
                      "${widget.setName}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "수정할 제목",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 30),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: TextFieldLineWidget(
                        hint: "수정할 제목을 입력해주세요.",
                        fieldHeight: 35,
                        fieldWidth: MediaQuery.of(context).size.width * 0.57,
                        lineThickness: 6,
                        obscureText: false,
                        controller: _newNameController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Divider(color: Colors.black12, thickness: 1.0, height: 8.0),
                SizedBox(height: 30),
                FutureBuilder(
                  future: wordPreviewListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.hasError) {
                      return buildAsyncStatusWidget(context, snapshot);
                    }
                    final wordList = snapshot.data ?? [];
                    return Row(
                      children: [
                        Text(
                          '총 ${wordList.length} 단어',
                          style: TextStyle(color: Colors.black26),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "단어",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "뜻",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: FutureBuilder(
                    future: wordPreviewListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.hasError) {
                        return buildAsyncStatusWidget(context, snapshot);
                      }
                      final wordList = snapshot.data ?? [];
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: wordList.length,
                        itemBuilder: (context, index) {
                          final word = wordList[index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(flex: 3, child: Text(word.word)),
                                  Expanded(flex: 3, child: Text(word.meaning)),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 15,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        print(
                                          '삭제 버튼 클릭 - wordbookId: ${widget.wordbookId}, wordId: ${word.wordId}',
                                        );

                                        try {
                                          await _deleteMyWordBookWord(
                                            wordbookId: widget.wordbookId,
                                            wordId: word.wordId!,
                                          );
                                          // 단어장에 단어가 없을 때 (다 삭제됐을 때) 단어장도 같이 삭제
                                          final updatedMyWordBookWordList =
                                              await _getMyWordList(
                                                wordbookId: widget.wordbookId,
                                              );
                                          if (updatedMyWordBookWordList ==
                                                  null ||
                                              updatedMyWordBookWordList
                                                  .isEmpty) {
                                            await _deleteMyWordBook(
                                              wordbookId: widget.wordbookId,
                                            );
                                            Navigator.pop(context, {
                                              "action": "deleted",
                                            });
                                          }
                                        } catch (e) {
                                          print('삭제 실패 : $e');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(40, 25),
                                        padding: EdgeInsets.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        "삭제",
                                        style: TextStyle(
                                          color: Color(0xFFFF983D),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Divider(
                                color: Colors.black12,
                                thickness: 1.0,
                                height: 8.0,
                              ),
                              SizedBox(height: 5),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: DeleteWordbookWidget(
                    text: "단어장 삭제",
                    bWidth: MediaQuery.of(context).size.width * 0.9,
                    bHeight: 45,
                    fontSize: 20,
                    onPressed: () async {
                      try {
                        await _deleteMyWordBook(wordbookId: widget.wordbookId);
                        Navigator.pop(context, {"action": "deleted"});
                      } catch (e) {
                        print('삭제 실패 $e');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// FutureBuilder 공통 부분
Widget buildAsyncStatusWidget(BuildContext context, AsyncSnapshot snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return Row(
      children: [Text('로딩 중...', style: TextStyle(color: Colors.black26))],
    );
  }
  if (snapshot.hasError) {
    return Row(children: [Text('에러 발생', style: TextStyle(color: Colors.red))]);
  }
  return SizedBox.shrink();
}
