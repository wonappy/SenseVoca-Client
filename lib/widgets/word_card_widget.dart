import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sense_voka/models/word_info_model.dart';
import 'package:sense_voka/styles/example_sentence_style.dart';
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

  //api 호출 상태 -> t: 로딩 중, f: 호출 완료
  bool isLoading = true;

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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://drive.google.com/uc?export=view&id=${widget.word.mnemonicImageUrl}',
                      ),
                    ),
                  ),
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
                //발음 교정 버튼
                checkPronunciationButton(
                  text: "발 음 교 정",
                  bWidth: 290,
                  bHeight: 60,
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

  ElevatedButton checkPronunciationButton({
    required String text,
    required double bWidth,
    required double bHeight,
  }) {
    return ElevatedButton(
      onPressed: () {
        String evaluatingText = "평가 중";
        Timer? evaluatingTimer; //평가 중 상태 애니메이션용 타이머
        double glow = 30;
        Timer? glowTimer; //녹음 중 상태 애니메이션용 타이머
        Timer? resultTimer; // 자동 평가 완료용 타이머
        //start : 시작, recording: 녹음 중, evaluating: 평가 중, result: 결과
        String state = "start";

        showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                // glow 애니메이션 반복 시작
                void startGlowLoop() {
                  glowTimer?.cancel(); // 중복 방지
                  glowTimer = Timer.periodic(Duration(milliseconds: 500), (
                    timer,
                  ) {
                    setState(() {
                      glow = (glow == 30) ? 5 : 30;
                    });
                  });
                }

                void stopGlowLoop() {
                  glowTimer?.cancel();
                }

                // 평가 중 애니메이션 반복 시작
                void startEvaluatingTextLoop() {
                  evaluatingTimer?.cancel(); // 중복 방지
                  int dotCount = 0;
                  evaluatingTimer = Timer.periodic(
                    Duration(milliseconds: 200),
                    (timer) {
                      setState(() {
                        dotCount = (dotCount + 1) % 4; // 0 ~ 3
                        evaluatingText = "평가 중${"." * dotCount}";
                      });
                    },
                  );
                }

                void stopEvaluatingTextLoop() {
                  evaluatingTimer?.cancel();
                  evaluatingText = "평가 중";
                }

                //evaluating -> result 상태 변환용 함수
                void startResultTimer() {
                  resultTimer?.cancel(); // 기존 타이머 있으면 취소
                  resultTimer = Timer(Duration(seconds: 5), () {
                    setState(() {
                      state = "result";
                      stopEvaluatingTextLoop();
                    });
                  });
                }

                void stopResultTimer() {
                  resultTimer?.cancel();
                }

                return Container(
                  height: (MediaQuery.of(context).size.height / 3) * 2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (state == "start" || state == "recording")
                                  ? "발음 확인"
                                  : (state == "evaluating")
                                  ? evaluatingText
                                  : "평가 결과",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            (state != "result")
                                ? Text(
                                  (state == "start" || state == "recording")
                                      ? "버튼을 누르고 발음하세요."
                                      : "재녹음은 버튼을 한 번 더 누르세요.",
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 18,
                                  ),
                                )
                                : SizedBox.shrink(),

                            SizedBox(
                              height:
                                  (state != "result")
                                      ? MediaQuery.of(context).size.height *
                                          0.07
                                      : MediaQuery.of(context).size.height *
                                          0.02,
                            ),
                            //마이크 녹음 버튼
                            (state != "result")
                                ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      //상태 변화
                                      if (state == "start") {
                                        state = "recording";
                                      } else if (state == "recording") {
                                        state = "evaluating";
                                      } else if (state == "evaluating") {
                                        state = "start";
                                      }
                                      //애니메이션 상태 변화
                                      if (state == "recording") {
                                        startGlowLoop();
                                        stopEvaluatingTextLoop();
                                      } else if (state == "evaluating") {
                                        stopGlowLoop();
                                        startEvaluatingTextLoop();
                                        startResultTimer();
                                      } else {
                                        stopGlowLoop();
                                        stopEvaluatingTextLoop();
                                        stopResultTimer();
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color:
                                          (state == "start")
                                              ? Colors.white
                                              : (state == "recording")
                                              ? Color(0xFFFF983D)
                                              : Color(0xFFEBEBEB),
                                      shape: BoxShape.circle,
                                      boxShadow:
                                          (state == "recording")
                                              ? [
                                                BoxShadow(
                                                  color: Color(
                                                    0xFFFF983D,
                                                  ).withValues(alpha: 0.5),
                                                  blurRadius: glow,
                                                  spreadRadius: glow / 2,
                                                ),
                                              ]
                                              : [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(0, 6),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                    ),
                                    child: Icon(
                                      (state == "start")
                                          ? Icons.mic
                                          : (state == "recording")
                                          ? Icons.stop
                                          : Icons.restart_alt_rounded,
                                      size: 120,
                                      color:
                                          (state == "start")
                                              ? Colors.black
                                              : (state == "recording")
                                              ? Colors.white
                                              : Colors.grey,
                                    ),
                                  ),
                                )
                                : SizedBox.shrink(),
                            (state != "result")
                                ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                )
                                : SizedBox.shrink(),
                            (state != "result")
                                ? Column(
                                  children: [
                                    Text(
                                      widget.word.word,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 28,
                                      ),
                                    ),
                                    Text(
                                      "[${widget.word.pronunciation}]",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                                : SizedBox.shrink(),
                            // 평가결과 화면 출력
                            (state == "result")
                                ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                      //창 닫기 버튼
                      Positioned(
                        top: 15,
                        right: 15,
                        child: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.black,
                            size: 35,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // 모달 닫기
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ).whenComplete(() {
          glowTimer?.cancel();
          evaluatingTimer?.cancel();
          resultTimer?.cancel();
        });
      },
      style: ButtonStyle(
        animationDuration: Duration.zero, //foregroundColor 글자 색상 변경 애니메이션 제거
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return Colors.white;
          }
          return Colors.black;
        }),
        backgroundColor:
            WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
              WidgetState.focused | WidgetState.hovered: Color(0xFFFF983D),
              WidgetState.any: Colors.white,
            }),
        overlayColor:
            WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
              WidgetState.focused |
                  WidgetState.pressed |
                  WidgetState.hovered: Color(0xFFFF983D),
              WidgetState.any: Colors.white,
            }),
        minimumSize: WidgetStateProperty.all(Size(bWidth, bHeight)),
        side: WidgetStateProperty.all(
          BorderSide(color: Color(0xFFFF983D), width: 2),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        elevation: WidgetStateProperty.all(5),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 33, fontWeight: FontWeight.w800),
      ),
    );
  }
}
