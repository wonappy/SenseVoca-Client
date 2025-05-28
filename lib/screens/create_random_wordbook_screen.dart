import 'package:flutter/material.dart';

import '../models/word_preview_model.dart';
import '../widgets/action_button_widget.dart';
import '../widgets/random_word_card_widget.dart';

//먼저 들어왔을 때 모달 창 켜기
//api 결과를 기다리는 동안 progress bar 띄우고

//랜덤 단어 출력
//체크 박스를 통해 원하지 않는 단어를 제거할 수 있도록 함.
//전체 선택, 전테 해제 제공
//선택된 단어를 제외하고 다시 랜덤을 돌릴 수 있도록 함(?)
//다음 버튼을 눌렀을 때 -> create mywordbook_screen으로 이동

class CreateRandomWordBookScreen extends StatefulWidget {
  const CreateRandomWordBookScreen({super.key});

  @override
  State<CreateRandomWordBookScreen> createState() =>
      _CreateRandomWordBookScreenState();
}

class _CreateRandomWordBookScreenState
    extends State<CreateRandomWordBookScreen> {
  //임시 단어 목록
  final List<WordPreviewModel> wordPreviewList = [
    WordPreviewModel(
      wordId: 1,
      word: "endeavor",
      meaning: "[명] 노력, 시도; [동] 노력하다, 시도하다",
    ),
    WordPreviewModel(
      wordId: 2,
      word: "section",
      meaning: "[명] (여러 개로 나뉜 것의 한) 부분, 부문",
    ),
    WordPreviewModel(wordId: 3, word: "surgeon", meaning: "[명] 외과 의사"),
    WordPreviewModel(wordId: 4, word: "arctic", meaning: "[형] 북극의; [명] 북극"),
    WordPreviewModel(wordId: 5, word: "elephant", meaning: "[명] 코끼리"),
    WordPreviewModel(wordId: 6, word: "flower", meaning: "[명] 꽃"),
    WordPreviewModel(wordId: 7, word: "grape", meaning: "[명] 포도"),
    WordPreviewModel(wordId: 8, word: "house", meaning: "[명] 집"),
    WordPreviewModel(wordId: 9, word: "ice", meaning: "[명] 얼음"),
    WordPreviewModel(wordId: 10, word: "juice", meaning: "[명] 주스"),
    WordPreviewModel(wordId: 11, word: "kite", meaning: "[명] 연"),
    WordPreviewModel(wordId: 12, word: "lion", meaning: "[명] 사자"),
    WordPreviewModel(wordId: 13, word: "moon", meaning: "[명] 달"),
    WordPreviewModel(wordId: 14, word: "notebook", meaning: "[명] 공책"),
    WordPreviewModel(wordId: 15, word: "orange", meaning: "[명] 오렌지"),
    WordPreviewModel(wordId: 16, word: "pencil", meaning: "[명] 연필"),
    WordPreviewModel(wordId: 17, word: "queen", meaning: "[명] 여왕"),
    WordPreviewModel(wordId: 18, word: "rabbit", meaning: "[명] 토끼"),
    WordPreviewModel(wordId: 19, word: "sun", meaning: "[명] 태양"),
    WordPreviewModel(wordId: 20, word: "tree", meaning: "[명] 나무"),
    WordPreviewModel(wordId: 21, word: "umbrella", meaning: "[명] 우산"),
    WordPreviewModel(wordId: 22, word: "violin", meaning: "[명] 바이올린"),
    WordPreviewModel(wordId: 23, word: "whale", meaning: "[명] 고래"),
    WordPreviewModel(wordId: 24, word: "xylophone", meaning: "[명] 실로폰"),
    WordPreviewModel(wordId: 25, word: "yogurt", meaning: "[명] 요구르트"),
    WordPreviewModel(wordId: 26, word: "zebra", meaning: "[명] 얼룩말"),
    WordPreviewModel(wordId: 27, word: "ball", meaning: "[명] 공"),
    WordPreviewModel(wordId: 28, word: "candle", meaning: "[명] 양초"),
    WordPreviewModel(wordId: 29, word: "desk", meaning: "[명] 책상"),
    WordPreviewModel(wordId: 30, word: "ear", meaning: "[명] 귀"),
    WordPreviewModel(wordId: 31, word: "fan", meaning: "[명] 선풍기"),
    WordPreviewModel(wordId: 32, word: "glove", meaning: "[명] 장갑"),
    WordPreviewModel(wordId: 33, word: "hat", meaning: "[명] 모자"),
    WordPreviewModel(wordId: 34, word: "island", meaning: "[명] 섬"),
    WordPreviewModel(wordId: 35, word: "jacket", meaning: "[명] 재킷"),
    WordPreviewModel(wordId: 36, word: "key", meaning: "[명] 열쇠"),
    WordPreviewModel(wordId: 37, word: "lamp", meaning: "[명] 램프"),
    WordPreviewModel(wordId: 38, word: "mirror", meaning: "[명] 거울"),
    WordPreviewModel(wordId: 39, word: "necklace", meaning: "[명] 목걸이"),
    WordPreviewModel(wordId: 40, word: "ocean", meaning: "[명] 바다"),
    WordPreviewModel(wordId: 41, word: "piano", meaning: "[명] 피아노"),
    WordPreviewModel(wordId: 42, word: "quilt", meaning: "[명] 누비이불"),
    WordPreviewModel(wordId: 43, word: "ring", meaning: "[명] 반지"),
    WordPreviewModel(wordId: 44, word: "sock", meaning: "[명] 양말"),
    WordPreviewModel(wordId: 45, word: "telephone", meaning: "[명] 전화기"),
  ];

  //단어장 단어 목록
  List<WordPreviewModel> wordsInWordBook = [
    WordPreviewModel(
      wordId: 1,
      word: "endeavor",
      meaning: "[명] 노력, 시도; [동] 노력하다, 시도하다",
    ),
    WordPreviewModel(
      wordId: 2,
      word: "section",
      meaning: "[명] (여러 개로 나뉜 것의 한) 부분, 부문",
    ),
    WordPreviewModel(wordId: 3, word: "surgeon", meaning: "[명] 외과 의사"),
    WordPreviewModel(wordId: 4, word: "arctic", meaning: "[형] 북극의; [명] 북극"),
    WordPreviewModel(wordId: 5, word: "elephant", meaning: "[명] 코끼리"),
  ];
  //랜덤 카드 목록
  List<WordPreviewModel> randomWords = [
    WordPreviewModel(
      wordId: 1,
      word: "endeavor",
      meaning: "[명] 노력, 시도; [동] 노력하다, 시도하다",
    ),
    WordPreviewModel(
      wordId: 2,
      word: "section",
      meaning: "[명] (여러 개로 나뉜 것의 한) 부분, 부문",
    ),
    WordPreviewModel(wordId: 3, word: "surgeon", meaning: "[명] 외과 의사"),
    WordPreviewModel(wordId: 4, word: "arctic", meaning: "[형] 북극의; [명] 북극"),
    WordPreviewModel(wordId: 5, word: "elephant", meaning: "[명] 코끼리"),
    WordPreviewModel(wordId: 6, word: "flower", meaning: "[명] 꽃"),
    WordPreviewModel(wordId: 7, word: "grape", meaning: "[명] 포도"),
    WordPreviewModel(wordId: 8, word: "house", meaning: "[명] 집"),
    WordPreviewModel(wordId: 9, word: "ice", meaning: "[명] 얼음"),
    WordPreviewModel(wordId: 10, word: "juice", meaning: "[명] 주스"),
  ];
  //초기 상태 확인 변수
  bool isInitial = true;

  //초기 상태 변경
  void exitInitialState() {
    setState(() {
      isInitial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3EB),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 40),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF983D),
        foregroundColor: Colors.white,
        //app bar 그림자 생기게 하기
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        title: Text(
          "단어장 생성",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.white,
                minimumSize: Size(70, 40),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                "다음",
                style: TextStyle(
                  color: Color(0xFFFF983D),
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            //선택된 단어 리스트
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "총 ${wordsInWordBook.length}개",
                style: TextStyle(fontSize: 19),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.013),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.27,
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
              child:
                  (wordsInWordBook.isEmpty)
                      ? Center(
                        child: Text(
                          "단어장에 포함될 단어를 선택해주세요.",
                          style: TextStyle(color: Colors.black26),
                        ),
                      )
                      : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:
                                wordsInWordBook.map((word) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              word.word,
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              word.meaning.replaceAll(
                                                '; ',
                                                '\n',
                                              ),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.remove_circle,
                                                color: Colors.deepOrange,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black12,
                                        thickness: 1.0,
                                        height: 0.0,
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            //랜덤 뽑기 단어
            Text(
              isInitial ? "단어 랜덤 뽑기 버튼을 눌러주세요." : "단어장에 포함될 단어를 선택해주세요.",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.42,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child:
                    isInitial
                        ? Center(
                          child: ActionButtonWidget(
                            onPressed: exitInitialState,
                            paddingHorizontal: 15,
                            paddingVertical: 5,
                            fontSize: 25,
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFFF983D),
                            fontWeight: FontWeight.w800,
                            text: "단어 랜덤 뽑기",
                          ),
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //전체 선택, 선택 해제 버튼
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ActionButtonWidget(
                                  onPressed: () {},
                                  paddingHorizontal: 15,
                                  paddingVertical: 5,
                                  foregroundColor: Color(0xFFFF983D),
                                  fontSize: 15,
                                  borderSide: 2,
                                  borderRadius: 12,
                                  elevation: 2,
                                  text: "전체 선택",
                                ),
                                SizedBox(width: 10),
                                ActionButtonWidget(
                                  onPressed: () {},
                                  paddingHorizontal: 15,
                                  paddingVertical: 5,
                                  foregroundColor: Color(0xFFFF983D),
                                  fontSize: 15,
                                  borderSide: 2,
                                  borderRadius: 12,
                                  elevation: 2,
                                  text: "전체 선택 해제",
                                ),
                              ],
                            ),
                            // 단어 카드 버튼 위젯 생성
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.28, // 원하는 높이로 고정
                              child: GridView.builder(
                                itemCount: randomWords.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, // 3열
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      childAspectRatio: 1.2, // 정사각형
                                    ),
                                itemBuilder: (context, index) {
                                  return RandomWordCardWidget(
                                    word: randomWords[index].word,
                                    meaning: randomWords[index].meaning,
                                  );
                                },
                              ),
                            ),
                            // 단어 다시 뽑기 버튼
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ActionButtonWidget(
                                onPressed: () {},
                                paddingHorizontal: 15,
                                paddingVertical: 5,
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFFFF983D),
                                borderRadius: 12,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                text: "단어 다시 뽑기",
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
