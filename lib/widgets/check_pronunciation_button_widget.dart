import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sense_voka/widgets/action_button_widget.dart';

import '../models/word_info_model.dart';

ElevatedButton checkPronunciationButton({
  required BuildContext context,
  required WordInfoModel word,
  required String text,
  required double bWidth,
  required double bHeight,
}) {
  final List<Map<String, dynamic>> scoreData = [
    {
      "label": "정확도",
      "score": 87,
      "backgroundcolor": Colors.white,
      "result": false,
    },
    {
      "label": "유창성",
      "score": 92,
      "backgroundcolor": Colors.white,
      "result": false,
    },
    {
      "label": "완성도",
      "score": 78,
      "backgroundcolor": Colors.white,
      "result": false,
    },
    {
      "label": "총점",
      "score": 85,
      "backgroundcolor": Color(0xFFFF983D),
      "result": true,
    },
  ];
  final List<Map<String, dynamic>> phonemeResults = [
    {"phoneme": "/d/", "score": 87.0, "feedback": "Good"},
    {"phoneme": "/ey/", "score": 100.0, "feedback": "Excellent"},
    {"phoneme": "/n/", "score": 100.0, "feedback": "Excellent"},
    {"phoneme": "/jh/", "score": 100.0, "feedback": "Excellent"},
    {"phoneme": "/ax/", "score": 100.0, "feedback": "Excellent"},
    {
      "phoneme": "/r/",
      "score": 77.0,
      "feedback": "혀끝을 말아 입천장 가까이 올리고 진동 없이 부드럽게 발음하세요.",
    },
  ];

  return ElevatedButton(
    onPressed: () {
      String evaluatingText = "평가 중";
      Timer? evaluatingTimer; //평가 중 상태 애니메이션용 타이머
      double glow = 30;
      Timer? glowTimer; //녹음 중 상태 애니메이션용 타이머
      Timer? resultTimer; // 자동 평가 완료용 타이머
      //start : 시작, recording: 녹음 중, evaluating: 평가 중, result: 결과, detailResult : 상세한 결과
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
                evaluatingTimer = Timer.periodic(Duration(milliseconds: 200), (
                  timer,
                ) {
                  setState(() {
                    dotCount = (dotCount + 1) % 4; // 0 ~ 3
                    evaluatingText = "평가 중${"." * dotCount}";
                  });
                });
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //최상단 제목
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
                          //설명문
                          (state != "result" && state != "detailResult")
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
                          //공백
                          SizedBox(
                            height:
                                (state != "result" && state != "detailResult")
                                    ? MediaQuery.of(context).size.height * 0.07
                                    : MediaQuery.of(context).size.height *
                                        0.001,
                          ),
                          //마이크 녹음 버튼
                          (state != "result" && state != "detailResult")
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
                          //공백
                          (state != "result" && state != "detailResult")
                              ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              )
                              : SizedBox.shrink(),
                          //단어, 발음 기호
                          Column(
                            children: [
                              Text(
                                word.word,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28,
                                ),
                              ),
                              Text(
                                word.pronunciation,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          //공백
                          (state == "result" || state == "detailResult")
                              ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              )
                              : SizedBox.shrink(),
                          // 평가결과 화면 출력 (간략 정보 & 상세 정보)
                          (state == "result")
                              ? Column(
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.4,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFDBBC),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          //평가결과 출력
                                          SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.32,
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.78,
                                            child: GridView.builder(
                                              itemCount: scoreData.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2, // 3열
                                                    mainAxisSpacing: 15,
                                                    crossAxisSpacing: 15,
                                                    childAspectRatio:
                                                        1.2, // 정사각형
                                                  ),
                                              itemBuilder: (context, index) {
                                                final data = scoreData[index];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        data["backgroundcolor"],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          data["label"],
                                                          style: TextStyle(
                                                            color:
                                                                data["result"]
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          "${data["score"]}점",
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            color:
                                                                data["result"]
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                      0xFFFF983D,
                                                                    ),
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          //(점수 자세히 보기, 다시 발음하기) 버튼
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ActionButtonWidget(
                                                onPressed: () {
                                                  setState(() {
                                                    if (state == "result") {
                                                      state = "detailResult";
                                                    }
                                                  });
                                                },
                                                paddingHorizontal: 10,
                                                paddingVertical: 5,
                                                text: "점수 자세히 보기",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              SizedBox(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.03,
                                              ),
                                              ActionButtonWidget(
                                                onPressed: () {
                                                  setState(() {
                                                    if (state == "result") {
                                                      state = "start";
                                                    }
                                                  });
                                                },
                                                paddingHorizontal: 10,
                                                paddingVertical: 5,
                                                text: "다시 발음하기",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : (state == "detailResult")
                              ? Column(
                                children: [
                                  //헤더
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF983D),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "발음",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "점수",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "피드백",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //내용
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.4,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Scrollbar(
                                      //스크롤 바 추가
                                      thumbVisibility: true,
                                      thickness: 4,
                                      radius: Radius.circular(5),
                                      child: SingleChildScrollView(
                                        //스크롤 기능
                                        child: Column(
                                          children:
                                              phonemeResults.map((result) {
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 5,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              result["phoneme"],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              "${result["score"]}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              result["feedback"],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    (result["feedback"] ==
                                                                                "Excellent" ||
                                                                            result["feedback"] ==
                                                                                "Good")
                                                                        ? 18
                                                                        : 15,
                                                                fontWeight:
                                                                    (result["feedback"] ==
                                                                                "Excellent" ||
                                                                            result["feedback"] ==
                                                                                "Good")
                                                                        ? FontWeight
                                                                            .w600
                                                                        : FontWeight
                                                                            .w500,
                                                                color:
                                                                    result["feedback"] ==
                                                                            "Excellent"
                                                                        ? Colors
                                                                            .orange
                                                                        : result["feedback"] ==
                                                                            "Good"
                                                                        ? Colors
                                                                            .deepOrange
                                                                        : Colors
                                                                            .black38,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                          ),
                                                      child: Divider(
                                                        color: Colors.black12,
                                                        thickness: 1.5,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                    //뒤로가기 버튼
                    (state == "detailResult")
                        ? Positioned(
                          top: 15,
                          left: 15,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.black,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                state = "result";
                              });
                            },
                          ),
                        )
                        : SizedBox.shrink(),
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
