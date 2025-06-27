import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sense_voka/models/word_info_model.dart';
import 'package:sense_voka/styles/example_sentence_style.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sense_voka/widgets/action_button_widget.dart';
import 'package:sense_voka/widgets/pronunciation_modal_widget.dart';

import '../enums/app_enums.dart';
import '../styles/english_example_sentence_style.dart';
import 'callback_button_widget.dart';

class WordCard extends StatefulWidget {
  final WordBook type; //단어장 타입
  final WordInfoModel word; //단어 기본 정보
  final String accent; // "us", "uk", "aus" 3가지 발음 옵션
  final VoidCallback onFavoriteButtonPressed; //즐겨찾기 버튼 눌림 콜백 함수
  final bool isRetryButtonPressed; //버튼 눌림 여부
  final VoidCallback onRetryButtonPressed; //한 번 더 복습 버튼 눌림 콜백 함수

  const WordCard({
    super.key,
    required this.type,
    required this.word,
    required this.accent,
    required this.onFavoriteButtonPressed,
    required this.onRetryButtonPressed,
    required this.isRetryButtonPressed,
  });

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  final FlutterTts tts = FlutterTts(); //tts 호출

  Future<void> checkAvailableVoices() async {
    final voices = await tts.getVoices;
    for (var voice in voices) {
      print('Voice: ${voice['name']}, Locale: ${voice['locale']}');
    }
  }

  //tts 설정
  Future _speak(String text) async {
    print("현재 tts 국가 : ${widget.accent}");

    try {
      // 먼저 TTS 완전히 중지하고 초기화
      await tts.stop();
      await Future.delayed(Duration(milliseconds: 100));

      // 현재 음성 확인 (디버깅용)
      final currentVoice = await tts.getDefaultVoice;
      print("설정 전 현재 음성: $currentVoice");

      switch (widget.accent) {
        case 'uk':
          print("영국 음성으로 설정 중...");
          await tts.setLanguage("en-GB");
          await Future.delayed(Duration(milliseconds: 50));

          await tts.setVoice({
            "name": "en-GB-SMTl02",
            "locale": "eng-x-lvariant-l02",
          });
          break;

        case 'aus':
          print("호주(영국 대체) 음성으로 설정 중...");
          await tts.setLanguage("en-GB");
          await Future.delayed(Duration(milliseconds: 50));

          await tts.setVoice({
            "name": "en-GB-SMTg02",
            "locale": "eng-x-lvariant-g02",
          });
          break;

        default: // US
          print("미국 음성으로 설정 중...");
          await tts.setLanguage("en-US");
          await Future.delayed(Duration(milliseconds: 50));

          await tts.setVoice({
            "name": "en-US-SMTl03",
            "locale": "eng-x-lvariant-l03",
          });
      }

      // 설정 후 음성 확인 (디버깅용)
      await Future.delayed(Duration(milliseconds: 100));
      final newVoice = await tts.getDefaultVoice;
      print("설정 후 현재 음성: $newVoice");

      // TTS 기본 설정
      await tts.setVolume(1.0);
      await tts.setPitch(1.0);
      await tts.setSpeechRate(0.5);

      // 충분한 대기 시간 후 음성 출력
      await Future.delayed(Duration(milliseconds: 200));
      await tts.speak(text);
    } catch (e) {
      print("TTS 에러: $e");
    }
  }

  //api 호출 상태 -> t: 로딩 중, f: 호출 완료
  bool isLoading = true;

  //즐겨찾기 상태 저장
  late bool favorite;

  @override
  void initState() {
    super.initState();
    // 디버깅 로그 추가
    print("[WordCard] initState 호출");
    print("word: ${widget.word}");
    print("word.wordId: ${widget.word?.wordId}");
    print("word.word: ${widget.word?.word}");
    print("word.meaning: ${widget.word?.meaning}");
    print("word.favorite: ${widget.word?.favorite}");

    //즐겨찾기 상태 초기화
    favorite = widget.word.favorite;
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
        padding: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
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
                //즐겨찾기
                IconButton(
                  onPressed: widget.onFavoriteButtonPressed,
                  icon:
                      widget.word.favorite
                          ? Icon(
                            Icons.star_rounded,
                            size: 40,
                            color: Colors.orangeAccent,
                          )
                          : Icon(
                            Icons.star_border_rounded,
                            size: 40,
                            color: Colors.black,
                          ),
                ),
                Column(
                  children: [
                    Text(
                      widget.word.word,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      widget.word.pronunciation.replaceAllMapped(
                        RegExp(r'/([^/]+)/'),
                        (match) {
                          return '[${match.group(1)}]';
                        },
                      ), // /aa/ -> [aa]로 변환
                      style: TextStyle(
                        fontSize: 15,
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
                    size: 38,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            //뜻
            Text(widget.word.meaning, style: TextStyle(fontSize: 15)),
            SizedBox(height: 8),
            //연상 예문 이미지 + 연상 예문
            Column(
              children: [
                //캐싱 이미지 디스크에 저장 -> 조금 더 오래 가지고 있을 수 있음.
                CachedNetworkImage(
                  imageUrl:
                      "https://drive.google.com/uc?export=view&id=${widget.word.mnemonicImageUrl}",
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                  errorWidget:
                      (context, url, error) => Icon(Icons.image_not_supported),
                ),
                SizedBox(height: 5),
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
                RichText(
                  text: TextSpan(
                    text: "이 예문이 마음에 들지 않으신가요?",
                    style: const TextStyle(
                      color: Colors.black26,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            // onTap Event
                          },
                  ),
                ),
                SizedBox(height: 5),
                Divider(color: Colors.black12, thickness: 1.0, height: 8.0),
              ],
            ),
            SizedBox(height: 5),
            //영어 예문
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.black),
                    SizedBox(width: 7),
                    Expanded(
                      child: RichText(
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                          children: englishExampleSentenceStyle(
                            widget.word.exampleSentenceEn,
                            widget.word.word,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            //버튼
            Column(
              children: [
                ActionButtonWidget(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder:
                          (context) =>
                              PronunciationModalWidget(word: widget.word),
                    );
                  },
                  bWidth: 290,
                  bHeight: 60,
                  borderSide: 2,
                  borderRadius: 15,
                  text: "발 음 교 정",
                  fontSize: 33,
                  fontWeight: FontWeight.w800,
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
