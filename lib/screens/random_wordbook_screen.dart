import 'package:flutter/material.dart';

import '../models/word_preview_model.dart';

class RandomWordBookScreen extends StatefulWidget {
  const RandomWordBookScreen({super.key});

  @override
  State<RandomWordBookScreen> createState() => _RandomWordBookScreenState();
}

class _RandomWordBookScreenState extends State<RandomWordBookScreen> {
  @override
  Widget build(BuildContext context) {
    //임시 단어 목록
    final List<WordPreviewModel> wordPreviewList = [
      WordPreviewModel(wordId: 1, word: "apple", meaning: "[명] 사과"),
      WordPreviewModel(wordId: 2, word: "book", meaning: "[명] 책"),
      WordPreviewModel(wordId: 3, word: "car", meaning: "[명] 자동차"),
      WordPreviewModel(wordId: 4, word: "dog", meaning: "[명] 개"),
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

    @override
    void initState() {
      super.initState();

      // 위젯이 다 build되고 난 뒤 실행 ( 단어 개수 설정 )
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //_showWelcomeDialog(); // ← 진입 시 모달 띄우기
      });
    }

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
          "랜덤 단어 생성",
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
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //api 결과를 기다리는 동안 progress bar 띄우고

            //랜덤 단어 출력
            //체크 박스를 통해 원하지 않는 단어를 제거할 수 있도록 함.
            //전체 선택, 전테 해제 제공
            //선택된 단어를 제외하고 다시 랜덤을 돌릴 수 있도록 함(?)
            //다음 버튼을 눌렀을 때 -> create mywordbook_screen으로 이동
          ],
        ),
      ),
    );
  }
}
