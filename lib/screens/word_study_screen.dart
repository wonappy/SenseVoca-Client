import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sense_voka/core/global_variables.dart';
import 'package:sense_voka/models/request_models/word_id_type_model.dart';
import 'package:sense_voka/services/basic_service.dart';
import 'package:sense_voka/services/users_service.dart';
import 'package:sense_voka/widgets/end_card_widget.dart';
import '../enums/app_enums.dart';
import '../models/word_info_model.dart';
import '../services/favoritewords_service.dart';
import '../services/mywordbooks_service.dart';
import '../styles/error_snack_bar_style.dart';
import '../styles/white_to_orange_button_style.dart';
import '../widgets/show_dialog_widget.dart';
import '../widgets/word_card_widget.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class WordStudyScreen extends StatefulWidget {
  final WordBook type;
  final List<WordIdTypeModel> wordList;
  final int sectionIndex;

  const WordStudyScreen({
    super.key,
    required this.type,
    required this.wordList,
    required this.sectionIndex,
  });

  @override
  State<WordStudyScreen> createState() => _WordStudyScreenState();
}

class _WordStudyScreenState extends State<WordStudyScreen>
    with TickerProviderStateMixin {
  //발음 국가 설정
  String accent = voiceCountry.name;

  int wordCount = -1; //구간 내 단어 개수

  int currentIndex = 0; //현재 카드 인덱스
  List<WordIdTypeModel> retryWordList = []; //한 번 더 복습 단어 인덱스 저장 리스트

  //애니메이션 동작 변수
  bool isAnimating = false; //애니메이팅 동작 상태
  bool isLeft = true; //화살표 눌림 방향 상태 (t: 왼쪽, f: 오른쪽)

  //구간 학습 완료 애니메이션 조건 변수
  //구간 학습 완료 애니메이션 카드 용 -> true : 애니메이션 카드가 EndCard false : 애니메이션 카드가 WordCard
  bool isSectionCompleteAnimating = false;
  //구간 학습 완료 UI 다음 카드 용 -> true : 다음 카드가 EndCard false : 다음 카드가 WordCard
  bool isSectionCompleteShowNext = false;

  //api 호출 상태 -> t: 로딩 중, f: 호출 완료
  bool isLoading = true;
  bool isDisposed = false;

  late List<WordInfoModel> wordInfoList = [];

  //애니메이션 변수
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // 선택된 단어의 인덱스로 검색해서 구간 내 단어 정보 리스트 생성
    _getWordInfoList(
      type: widget.type,
      wordList: widget.wordList,
      country: accent,
    );

    //구간 내 단어 개수
    wordCount = widget.wordList.length;

    _setupAnimation(); //카드 애니메이션 초기 상태 설정
  }

  //즐겨찾기 버튼이 눌렸을 때 콜백 함수
  void _toggleFavoriteButton({required WordInfoModel word}) {
    if (kDebugMode) {
      print("눌림 단어 : $word");
    }
    if (word.favorite == false) {
      //즐겨찾기 등록
      if (kDebugMode) {
        print("즐겨찾기 등록");
      }
      _postToFavorites(word: word);
    } else if (word.favorite == true) {
      //즐겨찾기 해제
      if (kDebugMode) {
        print("즐겨찾기 해제");
      }
      _removeFromFavorites(word: word);
    }
  }

  //한 번 더 복습 버튼이 눌렸을 때 콜백 함수
  void _toggleRetryWord(WordIdTypeModel word) {
    setState(() {
      if (retryWordList.contains(word)) {
        retryWordList.remove(word); // 리스트에서 아이디 제거
      } else {
        retryWordList.add(word); //리스트에 아이디 추가
      }
    });
  }

  //구간 완료 콜백함수
  //한 번 더 복습 버튼
  void _retrySection() async {
    if (retryWordList.isEmpty) {
      await showDialogWidget(
        context: context,
        title: "학습 완료",
        msg: "복습할 단어가 존재하지 않습니다.\n다음 구간으로 이동해주세요!",
      );
      return;
    }

    //구간 내 학습 완료 단어
    final int learnedCount = wordCount - retryWordList.length;
    //오늘의 학습 단어 업데이트
    _postStatusUpdate(learnedCount: learnedCount);

    Navigator.pop(context, {
      'button': 'retry',
      'currentIndex': widget.sectionIndex,
      'wordList': retryWordList,
    });
  }

  //다음 구간 이동 버튼 => 한 번 더 복습과 헷갈리지 않게 버튼 종류와 현재 섹션인덱스 값 전달
  void _nextSection() {
    //구간 내 학습 완료 단어
    final int learnedCount = wordCount - retryWordList.length;
    //오늘의 학습 단어 업데이트
    _postStatusUpdate(learnedCount: learnedCount);

    Navigator.pop(context, {
      'button': 'nextSection',
      'currentIndex': widget.sectionIndex,
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width; //화면 너비 자동 추출 -> 애니메이션 이동 거리 계산 용도
    final nextIndex = (currentIndex + (isLeft ? -1 : 1)).clamp(
      0,
      widget.wordList.length - 1,
    ); //현재 인덱스 위치
    final showNext =
        isAnimating; //애니메이션이 동작 중일 때 -> 다음 카드 표시 조건을 이해하기 쉽도록 생성한 변수

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
        title:
            isSectionCompleteShowNext
                ? Text(
                  "${widget.sectionIndex + 1}구간 학습 완료",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                )
                : RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.sectionIndex + 1}구간  ',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '${currentIndex + 1}',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: ' / $wordCount',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFA45200),
                        ),
                      ),
                    ],
                  ),
                ),
      ),

      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFFFF983D)),
              )
              : Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 10,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          //현재 카드 (애니메이션 x)
                          if (!isAnimating)
                            isSectionCompleteShowNext
                                ? EndCardWidget(
                                  section: widget.sectionIndex + 1,
                                  wordCount: wordCount,
                                  completedWords:
                                      wordCount - retryWordList.length,
                                  retryWords: retryWordList,
                                  onRetryButtonPressed: () => _retrySection(),
                                  onNextSectionPressed: () => _nextSection(),
                                )
                                : WordCard(
                                  type: widget.type,
                                  word: wordInfoList[currentIndex],
                                  accent: accent,
                                  onFavoriteButtonPressed:
                                      () => _toggleFavoriteButton(
                                        word: wordInfoList[currentIndex],
                                      ),
                                  isRetryButtonPressed: retryWordList.contains(
                                    WordIdTypeModel(
                                      wordId: wordInfoList[currentIndex].wordId,
                                      type: wordInfoList[currentIndex].type,
                                    ),
                                  ),
                                  onRetryButtonPressed:
                                      () => _toggleRetryWord(
                                        WordIdTypeModel(
                                          wordId:
                                              wordInfoList[currentIndex].wordId,
                                          type: wordInfoList[currentIndex].type,
                                        ),
                                      ),
                                ),
                          //다음 카드 출력(애니메이션 중일 때)
                          if (showNext)
                            isSectionCompleteShowNext
                                ? EndCardWidget(
                                  //다음 카드가 구간 완료 카드일 때,
                                  section: widget.sectionIndex + 1,
                                  wordCount: wordCount,
                                  completedWords:
                                      wordCount - retryWordList.length,
                                  retryWords: retryWordList,
                                  onRetryButtonPressed: null,
                                  onNextSectionPressed: null,
                                )
                                : isSectionCompleteAnimating
                                ? WordCard(
                                  //다음 카드가 구간완료 -> 마지막인덱스카드일 때,
                                  type: widget.type,
                                  word: wordInfoList[currentIndex],
                                  accent: accent,
                                  onFavoriteButtonPressed:
                                      () => _toggleFavoriteButton(
                                        word: wordInfoList[currentIndex],
                                      ),
                                  isRetryButtonPressed: retryWordList.contains(
                                    WordIdTypeModel(
                                      wordId: wordInfoList[currentIndex].wordId,
                                      type: wordInfoList[currentIndex].type,
                                    ),
                                  ),
                                  onRetryButtonPressed:
                                      () => _toggleRetryWord(
                                        WordIdTypeModel(
                                          wordId:
                                              wordInfoList[currentIndex].wordId,
                                          type: wordInfoList[currentIndex].type,
                                        ),
                                      ),
                                )
                                : WordCard(
                                  //일반 다음 카드
                                  type: widget.type,
                                  word: wordInfoList[nextIndex],
                                  accent: accent,
                                  onFavoriteButtonPressed:
                                      () => _toggleFavoriteButton(
                                        word: wordInfoList[currentIndex],
                                      ),
                                  isRetryButtonPressed: retryWordList.contains(
                                    WordIdTypeModel(
                                      wordId: wordInfoList[nextIndex].wordId,
                                      type: wordInfoList[nextIndex].type,
                                    ),
                                  ),
                                  onRetryButtonPressed:
                                      () => _toggleRetryWord(
                                        WordIdTypeModel(
                                          wordId:
                                              wordInfoList[nextIndex].wordId,
                                          type: wordInfoList[nextIndex].type,
                                        ),
                                      ),
                                ),
                          //현재 카드 (애니메이션 중일 때)
                          if (isAnimating)
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset:
                                      _slideAnimation.value *
                                      screenWidth, //위치 이동 애니메이션
                                  child: Transform.rotate(
                                    angle:
                                        _rotationAnimation.value, //카드 회전 애니메이션
                                    child:
                                        isSectionCompleteAnimating && isLeft
                                            ? EndCardWidget(
                                              section: widget.sectionIndex + 1,
                                              wordCount: wordCount,
                                              completedWords:
                                                  wordCount -
                                                  retryWordList.length,
                                              retryWords: retryWordList,
                                              onRetryButtonPressed: null,
                                              onNextSectionPressed: null,
                                            )
                                            : WordCard(
                                              type: widget.type,
                                              word: wordInfoList[currentIndex],
                                              accent: accent,
                                              onFavoriteButtonPressed:
                                                  () => _toggleFavoriteButton(
                                                    word:
                                                        wordInfoList[currentIndex],
                                                  ),
                                              isRetryButtonPressed:
                                                  retryWordList.contains(
                                                    WordIdTypeModel(
                                                      wordId:
                                                          wordInfoList[currentIndex]
                                                              .wordId,
                                                      type:
                                                          wordInfoList[currentIndex]
                                                              .type,
                                                    ),
                                                  ),
                                              onRetryButtonPressed:
                                                  () => _toggleRetryWord(
                                                    WordIdTypeModel(
                                                      wordId:
                                                          wordInfoList[currentIndex]
                                                              .wordId,
                                                      type:
                                                          wordInfoList[currentIndex]
                                                              .type,
                                                    ),
                                                  ),
                                            ),
                                  ),
                                );
                              },
                            ),

                          // 왼쪽 화살표
                          if (isSectionCompleteShowNext || currentIndex > 0)
                            Positioned(
                              left: 0,
                              child: ElevatedButton(
                                onPressed: () => _changeCard(true),
                                style: whiteOrangeButtonStyle(),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 30,
                                ),
                              ),
                            ),
                          // 오른쪽 화살표
                          if (!isSectionCompleteShowNext &&
                              currentIndex < wordCount)
                            Positioned(
                              right: 0,
                              child: ElevatedButton(
                                onPressed: () {
                                  _changeCard(false);
                                },
                                style: whiteOrangeButtonStyle(),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 30,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  //카드 애니메이션 초기 상태 설정
  void _setupAnimation() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
  }

  //화살표 버튼 -> 애니메이션 결정
  void _changeCard(bool left) {
    if (_animationController.isAnimating || isAnimating) return;

    // 구간 학습 완료 -> 마지막 인덱스
    if (isSectionCompleteShowNext && left) {
      setState(() {
        isSectionCompleteShowNext = false; //다음 카드 : WordCard
        isSectionCompleteAnimating = true; //애니메이션 카드 : EndCard
        isAnimating = true;
        isLeft = true;
        _startAnimation();
      });

      _animationController.forward(from: 0).whenComplete(() {
        setState(() {
          isSectionCompleteAnimating = false;
          isAnimating = false;
        });
      });

      return;
    }

    final nextIndex = currentIndex + (left ? -1 : 1);

    //마지막 인덱스 -> 구간 학습 완료
    if (nextIndex == wordCount) {
      setState(() {
        isSectionCompleteAnimating = false; //애니메이션 카드 : WordCard
        isSectionCompleteShowNext = true; //다음 카드 : EndCard
        isAnimating = true;
        isLeft = false;
        _startAnimation();
      });

      _animationController.forward(from: 0).whenComplete(() {
        setState(() {
          isAnimating = false;
        });
      });

      return;
    }

    ///////////일반 카드 이동 애니메이션//////////////
    //구간 범위 벗어나지 않도록 함
    if (nextIndex < 0 || nextIndex >= wordCount + 1) return;

    setState(() {
      isAnimating = true;
      isLeft = left;
      _startAnimation();
    });

    _animationController.forward(from: 0).whenComplete(() {
      setState(() {
        currentIndex = nextIndex;
        isAnimating = false;
      });
    });
  }

  //카드 이동 애니메이션
  void _startAnimation() {
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(isLeft ? 1.2 : -1.2, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: isLeft ? -0.1 : 0.1,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  ////////////api/////////////

  //단어 상세 정보 반환 api
  void _getWordInfoList({
    required WordBook type,
    required List<WordIdTypeModel> wordList,
    required String country,
  }) async {
    //로딩 창 출력
    setState(() {
      isLoading = true;
    });

    //api 호출
    dynamic result;

    if (type == WordBook.basic) {
      result = await BasicService.postBasicWordsInfo(
        wordIdList: wordList.map((e) => e.wordId).toList(),
        country: country,
      );
    } else if (type == WordBook.my) {
      result = await MywordbooksService.postMyWordsInfo(
        wordIdList: wordList.map((e) => e.wordId).toList(),
        country: country,
      );
    } else if (type == WordBook.favorite) {
      result = await FavoriteWordsService.postFavoriteWordsInfo(
        wordIdTypes: wordList,
        country: country,
      );
    }

    if (mounted) {
      if (result.isSuccess) {
        try {
          //미리 이미지 가져오기
          await _precacheImages(result.data);
        } catch (e) {
          if (kDebugMode) {
            print("일부 이미지 로딩에 실패하였습니다. - $e");
          }
        }
        //데이터 갱신 & 로딩 종료
        setState(() {
          wordInfoList = result.data;
          isLoading = false;
        });
      } else {
        if (result.title == "오류 발생") {
          //오류 발생
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(errorSnackBarStyle(context: context, result: result));
        } else if (result.title == "Token 재발급") {
          //토큰 재발급 및 재실행 과정
        } else {
          //일반 실패 응답
          await showDialogWidget(
            context: context,
            title: result.title,
            msg: result.msg,
          );
        }
      }
    }
  }

  //즐겨찾기 등록 api
  void _postStatusUpdate({required int learnedCount}) async {
    //api 호출
    dynamic result = await UsersService.postUserStatusUpdate(
      learnedCount: learnedCount,
    );

    if (result != null) {
      if (mounted) {
        if (result.isSuccess) {
        } else {
          if (result.title == "오류 발생") {
            //오류 발생
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBarStyle(context: context, result: result),
            );
          } else if (result.title == "Token 재발급") {
            //토큰 재발급 및 재실행 과정
          } else {
            //일반 실패 응답
            await showDialogWidget(
              context: context,
              title: result.title,
              msg: result.msg,
            );
          }
        }
      }
    }
  }

  //즐겨찾기 등록 api
  void _postToFavorites({required WordInfoModel word}) async {
    //api 결과 변수
    dynamic result;

    //api 호출
    if (word.type == WordBook.my) {
      //나만의 단어장
      result = await FavoriteWordsService.postMyWordtoFavorite(
        myWordMMnemonicId: word.wordId,
      );
    } else if (word.type == WordBook.basic) {
      //기본 단어장
      result = await FavoriteWordsService.postBasicWordtoFavorite(
        basicWordId: word.wordId,
      );
    }

    if (result != null) {
      if (mounted) {
        if (result.isSuccess) {
          setState(() {
            //즐겨찾기 상태 변경
            word.favorite = true;
          });
        } else {
          if (result.title == "오류 발생") {
            //오류 발생
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBarStyle(context: context, result: result),
            );
          } else if (result.title == "Token 재발급") {
            //토큰 재발급 및 재실행 과정
          } else {
            //일반 실패 응답
            await showDialogWidget(
              context: context,
              title: result.title,
              msg: result.msg,
            );
          }
        }
      }
    }
  }

  //즐겨찾기 해제
  void _removeFromFavorites({required WordInfoModel word}) async {
    if (!wordInfoList.contains(word)) return;
    if (word.favorite != true) return;

    //api 결과 변수
    dynamic result;

    //api 호출
    if (word.type == WordBook.my) {
      //나만의 단어장
      result = await FavoriteWordsService.deleteMyWordfromFavorite(
        myWordMMnemonicId: word.wordId,
      );
    } else {
      //기본 단어장
      result = await FavoriteWordsService.deleteBasicWordfromFavorite(
        basicWordId: word.wordId,
      );
    }

    if (result != null) {
      if (mounted) {
        if (result.isSuccess) {
          setState(() {
            //즐겨찾기 상태 변경
            word.favorite = false;
          });
        } else {
          if (result.title == "오류 발생") {
            //오류 발생
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBarStyle(context: context, result: result),
            );
          } else if (result.title == "Token 재발급") {
            //토큰 재발급 및 재실행 과정
          } else {
            //일반 실패 응답
            await showDialogWidget(
              context: context,
              title: result.title,
              msg: result.msg,
            );
          }
        }
      }
    }
  }

  //이미지 미리 가져오기
  Future<void> _precacheImages(List<WordInfoModel> wordList) async {
    final cacheManager = DefaultCacheManager();

    for (var word in wordList) {
      if (isDisposed) break; //화면 나가면 다운로드 중지
      try {
        await cacheManager.getSingleFile(
          "https://drive.google.com/uc?export=view&id=${word.mnemonicImageUrl}",
        ); // 디스크에 저장 -> 한 번 다운받아두면 오랫동안 저장해둘 수 있음
      } catch (e) {
        if (kDebugMode) {
          print(
            '이미지 캐싱 실패: ${word.wordId} - ${word.word} _ ${word.mnemonicImageUrl}',
          );
        }
      }
    }
  }
}
