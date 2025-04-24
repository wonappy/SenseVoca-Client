import 'package:flutter/material.dart';
import 'package:sense_voka/models/word_info_model.dart';
import 'package:sense_voka/screens/mywordbook_screen.dart';
import 'package:sense_voka/styles/example_sentence_style.dart';
import 'package:sense_voka/widgets/navigation_button_widget.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'callback_button_widget.dart';

class WordCard extends StatefulWidget {
  final WordInfoModel word; //단어 기본 정보
  final String accent; // "us", "uk", "aus" 3가지 발음 옵션
  final bool isRetryButtonPressed; //버튼 눌림 여부
  final VoidCallback onRetryButtonPressed; //한 번 더 복습 버튼 눌림 콜백 함수

  const WordCard({
    super.key,
    required this.word,
    required this.accent,
    required this.onRetryButtonPressed,
    required this.isRetryButtonPressed,
  });

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  final FlutterTts tts = FlutterTts(); //tts 호출

  //디바이스 tts 종류 출력
  void printAvailableVoices() async {
    //FlutterTts tts = FlutterTts();

    //List<dynamic> voices = await tts.getVoices;

    // for (var voice in voices) {
    //   print("목록 : $voice");
    // }
  }

  //tts 설정
  Future _speak(String text) async {
    switch (widget.accent) {
      case 'uk':
        await tts.setLanguage("en-GB");
        break;
      case 'aus':
        await tts.setLanguage("en-AU");
        break;
      default:
        await tts.setLanguage("en-US");
    }

    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
    await tts.stop();

    //목소리 설정
    await tts.setVoice({
      "name": "en-GB-SMTl02",
      "locale": "eng-x-lvariant-l02",
    });

    await tts.speak(", $text"); //, 를 통해 첫 음절 무시 현상 제거
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
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
            //영단어 + 발음기호
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => printAvailableVoices(),
                  icon: Icon(
                    Icons.star_border_rounded,
                    size: 45,
                    color: Colors.black,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      widget.word.word,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      widget.word.pronunciation,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                //tts 적용!!!
                IconButton(
                  onPressed: () => _speak(widget.word.word),
                  icon: Icon(
                    Icons.volume_up_rounded,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            //뜻
            Text(widget.word.meaning, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            //연상 예문 이미지 + 연상 예문
            Column(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(color: Colors.black38),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: exampleSentenceStyle(
                      widget.word.mnemonicExample,
                      true,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 10),
            //예문 재생성 요청 + 구분 선
            Column(
              children: [
                Text(
                  "이 예문이 마음에 들지 않으신가요?",
                  style: TextStyle(color: Colors.black26, fontSize: 12),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.black12, thickness: 1.0, height: 8.0),
              ],
            ),
            SizedBox(height: 10),
            //영어 예문
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.black),
                    SizedBox(width: 7),
                    RichText(
                      text: TextSpan(
                        children: exampleSentenceStyle(
                          widget.word.exampleSentenceEn,
                          false,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            //버튼
            Column(
              children: [
                NavigationButtonWidget(
                  text: "발 음 교 정",
                  bWidth: 290,
                  bHeight: 60,
                  destinationScreen: MyWordBookScreen(),
                ),
                SizedBox(height: 10),
                CallbackButtonWidget(
                  text: "한 번 더 복습",
                  bWidth: 290,
                  bHeight: 60,
                  isPressed: widget.isRetryButtonPressed,
                  onPressed: widget.onRetryButtonPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
