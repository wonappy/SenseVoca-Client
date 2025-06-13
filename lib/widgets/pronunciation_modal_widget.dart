import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sense_voka/core/global_variables.dart';
import 'package:sense_voka/services/evaluatepronunciation_service.dart';
import 'package:sense_voka/widgets/show_dialog_widget.dart';
import '../enums/app_enums.dart';
import '../models/pronunciation_result_model.dart';
import '../models/word_info_model.dart';
import 'package:sense_voka/widgets/action_button_widget.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import '../styles/error_snack_bar_style.dart';

class PronunciationModalWidget extends StatefulWidget {
  final WordInfoModel word;
  const PronunciationModalWidget({super.key, required this.word});

  @override
  State<PronunciationModalWidget> createState() =>
      _PronunciationModalWidgetState();
}

class _PronunciationModalWidgetState extends State<PronunciationModalWidget> {
  String state = "start";
  String evaluatingText = "평가 중";
  double glow = 30;
  Timer? glowTimer;
  Timer? evaluatingTimer;
  Timer? resultTimer;
  bool _isProcessing = false; //녹음 함수 동작 중

  // 녹음 관련 변수
  final AudioRecorder _recorder = AudioRecorder();
  String? _recordedFilePath;
  int? _recordedFileSize;

  List<Map<String, dynamic>> scoreData = [
    {"field": "accuracy", "label": "정확도", "score": 0},
    {"field": "fluency", "label": "유창성", "score": 0},
    {"field": "completeness", "label": "완성도", "score": 0},
    {"field": "total", "label": "총점", "score": 0},
  ];
  List<PhonemeResultModel> phonemeResults = [];

  // 애니메이션 및 상태 관리 함수들
  void startGlowLoop() {
    glowTimer?.cancel();
    glowTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        glow = (glow == 30) ? 5 : 30;
      });
    });
  }

  void stopGlowLoop() {
    glowTimer?.cancel();
  }

  void startEvaluatingTextLoop() {
    evaluatingTimer?.cancel();
    int dotCount = 0;
    evaluatingTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        dotCount = (dotCount + 1) % 4;
        evaluatingText = "평가 중${"." * dotCount}";
      });
    });
  }

  void stopEvaluatingTextLoop() {
    evaluatingTimer?.cancel();
    evaluatingText = "평가 중";
  }

  void startResultTimer() {
    resultTimer?.cancel();
    resultTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        state = "result";
        stopEvaluatingTextLoop();
      });
    });
  }

  void stopResultTimer() {
    resultTimer?.cancel();
  }

  //녹음 상태 관리 함수들
  //녹음 시작
  Future<void> _startRecording() async {
    try {
      //녹음 권한 확인
      bool hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('마이크 권한이 필요합니다.')));
        }
        return;
      }
      //임시 저장경로 확인
      Directory tempDir = await getTemporaryDirectory();
      String filePath =
          '${tempDir.path}/pronunciation_${DateTime.now().millisecondsSinceEpoch}.wav';
      const RecordConfig config = RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        bitRate: 128000,
      );
      await _recorder.start(config, path: filePath);
      if (mounted) {
        setState(() {
          _recordedFilePath = filePath;
          _recordedFileSize = null;
          state = "recording";
        });
        startGlowLoop();
        stopEvaluatingTextLoop();
      }
      if (kDebugMode) {
        print('녹음 시작: $filePath');
      }
    } catch (e) {
      if (kDebugMode) {
        print('녹음 시작 오류: $e');
      }
      await _deleteRecordedFile();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('녹음을 시작할 수 없습니다: $e')));
      }
    }
  }

  //녹음 멈춤 -> api 호출
  Future<void> _stopRecording() async {
    try {
      String? path = await _recorder.stop();
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          int size = await file.length();
          if (mounted) {
            setState(() {
              _recordedFilePath = path;
              _recordedFileSize = size;
              state = "evaluating";
            });
            stopGlowLoop();
            startEvaluatingTextLoop();
            startResultTimer();

            //평가 api 호출
            _evaluatePronunciation(file);
          }
          if (kDebugMode) {
            print('녹음 파일 경로: $path');
            print('녹음 파일 크기: $size bytes');
          }
        } else {
          throw Exception('녹음 파일이 생성되지 않았습니다.');
        }
      } else {
        throw Exception('녹음 경로를 가져올 수 없습니다.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('녹음 중지 오류: $e');
      }
      await _deleteRecordedFile();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('녹음을 중지할 수 없습니다: $e')));
        // 시작 상태로 되돌리기
        setState(() {
          state = "start";
        });
        stopGlowLoop();
        stopEvaluatingTextLoop();
        //api 함수 호출
      }
    }
  }

  //녹음 초기화
  Future<void> _resetRecording() async {
    try {
      await _recorder.stop();

      if (_recordedFilePath != null) {
        final file = File(_recordedFilePath!);
        if (await file.exists()) {
          await file.delete(); //파일 삭제
          if (kDebugMode) {
            print('녹음 파일 삭제됨: $_recordedFilePath');
          }
        }
      }
      if (mounted) {
        setState(() {
          _recordedFilePath = null;
          _recordedFileSize = null;
          state = "start";
        });
        stopGlowLoop();
        stopEvaluatingTextLoop();
        stopResultTimer();
      }

      if (kDebugMode) {
        print('녹음 초기화 완료');
      }
    } catch (e) {
      if (kDebugMode) {
        print('녹음 초기화 오류: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('녹음을 초기화할 수 없습니다: $e')));
      }
    }
  }

  //녹음 파일 삭제
  Future<void> _deleteRecordedFile() async {
    if (_recordedFilePath != null) {
      try {
        final file = File(_recordedFilePath!);
        if (await file.exists()) {
          await file.delete();
          if (kDebugMode) {
            print('녹음 파일 삭제됨: $_recordedFilePath');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('녹음 파일 삭제 실패: $e');
        }
      }
    }
  }

  // 마이크 onTap 동작
  Future<void> _onMicButtonTaped() async {
    if (_isProcessing) return;

    _isProcessing = true;

    try {
      if (state == "start") {
        await _startRecording();
      } else if (state == "recording") {
        await _stopRecording();
      } else if (state == "evaluating") {
        await _resetRecording();
      }
    } catch (e) {
      if (kDebugMode) {
        print('마이크 버튼 처리 오류: $e');
      }
    } finally {
      _isProcessing = false;
    }
  }

  // 발음 평가 API 호출 함수 (수정된 버전)
  Future<void> _evaluatePronunciation(File audioFile) async {
    try {
      // API 호출
      bool success = await _postEvaluatePronunciation(
        word: widget.word.word,
        country: voiceCountry.name,
        audioFile: audioFile,
      );

      if (mounted) {
        if (success) {
          // 성공 시 결과 화면으로 이동
          setState(() {
            state = "result";
          });
          stopEvaluatingTextLoop();
          stopResultTimer();

          await _deleteRecordedFile();
          setState(() {
            _recordedFilePath = null;
            _recordedFileSize = null;
          });
        } else {
          // 실패 시 시작 화면으로 돌아가기
          stopEvaluatingTextLoop();
          await _resetRecording();
          stopResultTimer();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('발음 평가 API 호출 오류: $e');
      }
      if (mounted) {
        stopEvaluatingTextLoop();
        await _resetRecording();
      }
    }
  }

  //발음 평가 API 호출
  Future<bool> _postEvaluatePronunciation({
    required String word,
    required String country,
    required File audioFile,
  }) async {
    try {
      //api 호출
      var result = await EvaluatePronunciationService.postEvaluatePronunciation(
        word: word,
        country: voiceCountry.name,
        audioFile: audioFile,
      );

      if (mounted) {
        if (result.isSuccess) {
          for (var item in scoreData) {
            switch (item["field"]) {
              case "accuracy":
                item["score"] = result.data.overallScore.accuracy;
                break;
              case "fluency":
                item["score"] = result.data.overallScore.fluency;
                break;
              case "completeness":
                item["score"] = result.data.overallScore.completeness;
                break;
              case "total":
                item["score"] = result.data.overallScore.total;
                break;
            }
          }
          phonemeResults = result.data.phonemeResults;
          return true;
        } else {
          if (result.title == "오류 발생") {
            //오류 발생
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBarStyle(context: context, result: result),
            );
            return false;
          } else if (result.title == "Token 재발급") {
            //토큰 재발급 및 재실행 과정
            return false;
          } else {
            //일반 실패 응답
            await showDialogWidget(
              context: context,
              title: result.title,
              msg: result.msg,
            );
            return false;
          }
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('API 호출 중 예외 발생: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('네트워크 오류가 발생했습니다: $e')));
      }
      return false;
    }
  }

  @override
  void dispose() {
    glowTimer?.cancel();
    evaluatingTimer?.cancel();
    resultTimer?.cancel();

    //비동기 -> 에러 무시
    _deleteRecordedFile().catchError((error) {
      if (kDebugMode) {
        print('dispose에서 파일 삭제 오류: $error');
      }
    });

    //비동기 -> 에러 무시
    _recorder.dispose().catchError((error) {
      if (kDebugMode) {
        print('녹음기 dispose 오류: $error');
      }
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                // 제목
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
                // 설명문
                (state != "result" && state != "detailResult")
                    ? Text(
                      (state == "start" || state == "recording")
                          ? "버튼을 누르고 발음하세요."
                          : "재녹음은 버튼을 한 번 더 누르세요.",
                      style: TextStyle(color: Colors.black38, fontSize: 18),
                    )
                    : SizedBox.shrink(),
                SizedBox(
                  height:
                      (state != "result" && state != "detailResult")
                          ? MediaQuery.of(context).size.height * 0.07
                          : MediaQuery.of(context).size.height * 0.001,
                ),
                // 마이크 녹음 버튼
                (state != "result" && state != "detailResult")
                    ? GestureDetector(
                      onTap: _onMicButtonTaped,
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
                (state != "result" && state != "detailResult")
                    ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    )
                    : SizedBox.shrink(),
                // 단어, 발음 기호
                Column(
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
                      widget.word.pronunciation.replaceAllMapped(
                        RegExp(r'/([^/]+)/'),
                        (match) {
                          return '[${match.group(1)}]';
                        },
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                // 녹음 파일 경로 및 크기 표시
                if (_recordedFilePath != null && state == "evaluating")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '녹음 파일: $_recordedFilePath\n파일 크기: ${_recordedFileSize ?? "측정 중..."} bytes',
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ),
                (state == "result" || state == "detailResult")
                    ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    )
                    : SizedBox.shrink(),
                // 평가 결과 및 상세 결과 화면
                (state == "result")
                    ? Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.41,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFDBBC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 10.0,
                              right: 10.0,
                              bottom: 2,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.32,
                                  width:
                                      MediaQuery.of(context).size.width * 0.78,
                                  child: GridView.builder(
                                    itemCount: scoreData.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 15,
                                          crossAxisSpacing: 15,
                                          childAspectRatio: 1.2,
                                        ),
                                    itemBuilder: (context, index) {
                                      final data = scoreData[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color:
                                              (data["field"] == "total")
                                                  ? Color(0xFFFF983D)
                                                  : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                data["label"],
                                                style: TextStyle(
                                                  color:
                                                      (data["field"] == "total")
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "${data["score"]}점",
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  color:
                                                      (data["field"] == "total")
                                                          ? Colors.white
                                                          : Color(0xFFFF983D),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ActionButtonWidget(
                                      onPressed: () {
                                        setState(() {
                                          if (state == "result") {
                                            state = "detailResult";
                                          }
                                        });
                                      },
                                      bWidth:
                                          MediaQuery.of(context).size.width *
                                          0.34,
                                      bHeight:
                                          MediaQuery.of(context).size.height *
                                          0.05,
                                      text: "점수 자세히 보기",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
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
                                      bWidth:
                                          MediaQuery.of(context).size.width *
                                          0.34,
                                      bHeight:
                                          MediaQuery.of(context).size.height *
                                          0.05,
                                      text: "다시 발음하기",
                                      fontSize: 15,
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
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.9,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 4,
                            radius: Radius.circular(5),
                            child: SingleChildScrollView(
                              child: Column(
                                children:
                                    phonemeResults.map((result) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 5,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    result.symbol,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    "${result.score}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    result.feedback,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          (result.feedback ==
                                                                      "Excellent" ||
                                                                  result.feedback ==
                                                                      "Good")
                                                              ? 18
                                                              : 15,
                                                      fontWeight:
                                                          (result.feedback ==
                                                                      "Excellent" ||
                                                                  result.feedback ==
                                                                      "Good")
                                                              ? FontWeight.w600
                                                              : FontWeight.w500,
                                                      color:
                                                          result.feedback ==
                                                                  "Excellent"
                                                              ? Colors.orange
                                                              : result.feedback ==
                                                                  "Good"
                                                              ? Colors
                                                                  .deepOrange
                                                              : Colors.black38,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
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
          // 창 닫기 버튼
          Positioned(
            top: 15,
            right: 15,
            child: IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.black, size: 35),
              onPressed: () async {
                await _deleteRecordedFile();
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          // 뒤로가기 버튼
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
  }
}
