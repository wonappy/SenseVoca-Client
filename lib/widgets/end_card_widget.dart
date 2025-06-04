import 'package:flutter/material.dart';
import 'package:sense_voka/models/request_models/word_id_type_model.dart';
import 'callback_button_widget.dart';

class EndCardWidget extends StatelessWidget {
  final int section; //구간 번호
  final int wordCount; //총 단어 개수
  final int completedWords; //학습 완료 단어 개수
  final List<WordIdTypeModel> retryWords; //한 번 더 복습 단어 인덱스 리스트

  final VoidCallback? onRetryButtonPressed; //한 번 더 복습이 눌렸을 때 콜백 함수
  final VoidCallback? onNextSectionPressed; //다음 구간 이동이 눌렸을 때 콜백 함수

  const EndCardWidget({
    super.key,
    required this.section,
    required this.wordCount,
    required this.completedWords,
    required this.retryWords,
    this.onRetryButtonPressed,
    this.onNextSectionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height; //화면 높이 비율

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFFF983D),
          borderRadius: BorderRadius.circular(45),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(0, 8),
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ],
        ),

        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.08),
            Text(
              "$section구간 학습 완료!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: screenHeight * 0.07),
            Text(
              "[ 학습 결과 ]",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              width: 220,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    offset: Offset(0, 8),
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  studyResult(explanation: "구간 단어", num: wordCount),
                  studyResult(explanation: "학습 완료 단어", num: completedWords),
                  studyResult(explanation: "한 번 더 복습", num: retryWords.length),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.12),
            //버튼
            Column(
              children: [
                CallbackButtonWidget(
                  text: "한 번 더 복습",
                  bWidth: 290,
                  bHeight: 60,
                  onPressed: onRetryButtonPressed,
                ),
                SizedBox(height: 10),
                CallbackButtonWidget(
                  text: "다음 구간 이동",
                  bWidth: 290,
                  bHeight: 60,
                  onPressed: onNextSectionPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text studyResult({required String explanation, required int num}) {
    return Text.rich(
      TextSpan(
        text: "$explanation : ",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        children: [
          TextSpan(
            text: "$num",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFF983D),
            ),
          ),
          TextSpan(
            text: "개",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
