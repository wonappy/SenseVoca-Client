import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sense_voka/models/word_info_model.dart';
import 'package:sense_voka/styles/example_sentence_style.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sense_voka/widgets/action_button_widget.dart';
import 'package:sense_voka/widgets/pronunciation_modal_widget.dart';

import '../enums/app_enums.dart';
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

  //tts 설정
  Future _speak(String text) async {
    switch (widget.accent) {
      case 'uk':
        await tts.setLanguage("en-GB");
        await tts.setVoice({
          "name": "en-GB-SMTl02",
          "locale": "eng-x-lvariant-l02",
        });
        break;
      case 'aus':
        await tts.setLanguage("en-AU");
        await tts.setVoice({"name": "en-AU-language", "locale": "en-AU"});
        break;
      default:
        await tts.setLanguage("en-US");
        await tts.setVoice({"name": "en-us-x-tpf-local", "locale": "en-US"});
        await tts.setSpeechRate(0.5);
    }

    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
    await tts.stop();

    await tts.speak(", $text"); //, 를 통해 첫 음절 무시 현상 제거
  }

  //api 호출 상태 -> t: 로딩 중, f: 호출 완료
  bool isLoading = true;

  //즐겨찾기 상태 저장
  late bool favorite;

  @override
  void initState() {
    super.initState();
    //즐겨찾기 상태 초기화
    favorite = widget.word.favorite;
  }

  // //즐겨찾기 등록
  // void _postToFavorites() async {
  //   if (favorite != false) return;
  //
  //   //api 결과 변수
  //   dynamic result;
  //
  //   //api 호출
  //   if (widget.type == WordBook.my) {
  //     //나만의 단어장
  //     result = await FavoriteWordsService.postMyWordtoFavorite(
  //       myWordMMnemonicId: widget.word.wordId,
  //     );
  //   } else {
  //     //기본 단어장
  //     // result = await FavoriteWordsService.postMyWordtoFavorite(
  //     //   myWordMMnemonicId: widget.word.wordId,
  //     // );
  //   }
  //
  //   if (result != null) {
  //     if (mounted) {
  //       if (result.isSuccess) {
  //         setState(() {
  //           //즐겨찾기 상태 변경
  //           favorite = true;
  //         });
  //       } else {
  //         if (result.title == "오류 발생") {
  //           //오류 발생
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             errorSnackBarStyle(context: context, result: result),
  //           );
  //         } else if (result.title == "Token 재발급") {
  //           //토큰 재발급 및 재실행 과정
  //         } else {
  //           //일반 실패 응답
  //           await showDialogWidget(
  //             context: context,
  //             title: result.title,
  //             msg: result.msg,
  //           );
  //         }
  //       }
  //     }
  //   }
  // }
  //
  // //즐겨찾기 해제
  // void removeFromFavorites() async {
  //   if (favorite != true) return;
  //
  //   //api 결과 변수
  //   dynamic result;
  //
  //   //api 호출
  //   if (widget.type == WordBook.my) {
  //     //나만의 단어장
  //     result = await FavoriteWordsService.deleteMyWordfromFavorite(
  //       myWordMMnemonicId: widget.word.wordId,
  //     );
  //   } else {
  //     //기본 단어장
  //     // result = await FavoriteWordsService.postMyWordtoFavorite(
  //     //   myWordMMnemonicId: widget.word.wordId,
  //     // );
  //   }
  //
  //   if (result != null) {
  //     if (mounted) {
  //       if (result.isSuccess) {
  //         setState(() {
  //           //즐겨찾기 상태 변경
  //           favorite = false;
  //         });
  //       } else {
  //         if (result.title == "오류 발생") {
  //           //오류 발생
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             errorSnackBarStyle(context: context, result: result),
  //           );
  //         } else if (result.title == "Token 재발급") {
  //           //토큰 재발급 및 재실행 과정
  //         } else {
  //           //일반 실패 응답
  //           await showDialogWidget(
  //             context: context,
  //             title: result.title,
  //             msg: result.msg,
  //           );
  //         }
  //       }
  //     }
  //   }
  // }

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
                      widget.word.pronunciation,
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
                Text(
                  "이 예문이 마음에 들지 않으신가요?",
                  style: TextStyle(color: Colors.black26, fontSize: 12),
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
                          children: exampleSentenceStyle(
                            widget.word.exampleSentenceEn,
                            false,
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
