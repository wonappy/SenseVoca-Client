import 'package:flutter/material.dart';
import 'package:sense_voka/models/word_preview_model.dart';

import '../core/global_variables.dart';
import '../enums/app_enums.dart';
import '../widgets/new_word_card_widget.dart';
import '../widgets/show_dialog_widget.dart';
import 'create_mywordbook_screen.dart';

class CreateMyWordCardScreen extends StatefulWidget {
  const CreateMyWordCardScreen({super.key});

  @override
  State<CreateMyWordCardScreen> createState() => _CreateMyWordCardScreenState();
}

class _CreateMyWordCardScreenState extends State<CreateMyWordCardScreen>
    with TickerProviderStateMixin {
  //단어 카드 리스트
  List<WordPreviewModel> wordCards = [
    WordPreviewModel(wordId: null, word: "", meaning: "", type: WordBook.my),
  ];
  //단어, 뜻 입력 controller 리스트
  final List<TextEditingController> _wordControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> _meaningControllers = [
    TextEditingController(),
  ];

  //현재 단어 카드 인덱스
  int currentCardIndex = 0;

  //검색 관련 변수
  List<WordPreviewModel> searchResults = []; // 결과 리스트
  bool showSearchResults = false; // 검색결과 출력 유무
  late ScrollController _scrollController; //스크롤바를 위한...

  @override
  void initState() {
    super.initState();

    //스크롤 컨트롤러 추가
    _scrollController = ScrollController();

    //controller에 리스너 추가
    _wordControllers[0].addListener(() {
      wordCards[0].word = _wordControllers[0].text;
      searchWords(_wordControllers[0].text, 0);
    });
    _meaningControllers[0].addListener(() {
      wordCards[0].meaning = _meaningControllers[0].text;
    });
  }

  //카드 이동(왼쪽 오른쪽)
  void moveCard({required bool isLeft}) {
    //이동 시, 이전 검색 결과 초기화
    setState(() {
      showSearchResults = false;
      searchResults = [];
    });

    if (isLeft) {
      setState(() {
        //0번째 인덱스라면 이동 안함.
        if (currentCardIndex <= 0) {
          currentCardIndex = 0;
        } else {
          //왼쪽 이동
          currentCardIndex--;
        }
      });
    } else {
      setState(() {
        //가장 마지막 카드라면, 새 카드 추가
        if (currentCardIndex >= wordCards.length - 1) {
          addNewCard();
          currentCardIndex++;
        } else {
          //오른쪽 이동
          currentCardIndex++;
        }
      });
    }
  }

  //새 단어 카드 추가
  void addNewCard() {
    setState(() {
      //새 단어 정보 추가
      wordCards.add(
        WordPreviewModel(
          wordId: null,
          word: "",
          meaning: "",
          type: WordBook.my,
        ),
      );

      // 새 컨트롤러 추가
      _wordControllers.add(TextEditingController());
      _meaningControllers.add(TextEditingController());

      final currentIndex = _wordControllers.length - 1;

      // addListener 추가
      _wordControllers[currentIndex].addListener(() {
        wordCards[currentIndex].word = _wordControllers[currentIndex].text;
        searchWords(_wordControllers[currentIndex].text, currentIndex);
      });

      _meaningControllers[currentIndex].addListener(() {
        wordCards[currentIndex].meaning =
            _meaningControllers[currentIndex].text;
      });
    });
  }

  //카드 삭제
  void deleteCard(int index) {
    if (wordCards.length <= 1) {
      showDialogWidget(
        context: context,
        title: "경고",
        msg: "최소 한 개의 단어 카드가 필요합니다.",
      );
    } else {
      setState(() {
        //해당 카드 controller 메모리 삭제
        _wordControllers[index].dispose();
        _meaningControllers[index].dispose();

        //카드 연결 정보 삭제
        wordCards.removeAt(index);
        _wordControllers.removeAt(index);
        _meaningControllers.removeAt(index);

        //현재 인덱스 줄이기
        if (currentCardIndex > 0) currentCardIndex--;
      });
    }
  }

  // 단어 검색
  void searchWords(String text, int cardIndex) {
    //아무 글자가 없다면,
    if (text.isEmpty) {
      setState(() {
        showSearchResults = false;
        searchResults = [];
      });
      return;
    }

    // 단어 검색 로직 (1글자 이상)
    final results =
        wordSearchList
            .where(
              (word) => word.word.toLowerCase().startsWith(text.toLowerCase()),
            )
            .toList();

    setState(() {
      searchResults = results;
      showSearchResults = results.isNotEmpty && cardIndex == currentCardIndex;
    });
  }

  // 검색 결과 선택
  void selectSearchResult(WordPreviewModel selectedWord) {
    wordCards[currentCardIndex].wordId = selectedWord.wordId;
    _wordControllers[currentCardIndex].text = selectedWord.word;
    _meaningControllers[currentCardIndex].text = selectedWord.meaning;

    setState(() {
      showSearchResults = false;
      searchResults = [];
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF3EB),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 40),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //다음 버튼 -> NavigatedButtonWidget으로 변경?
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {
                //만약 카드에 빈 값을 갖는 카드가 존재한다면,
                if (wordCards.any((card) => card.word == "") ||
                    wordCards.any((card) => card.meaning == "")) {
                  showDialogWidget(
                    context: context,
                    title: "경고",
                    msg:
                        "단어장 내에 빈 값을 갖는 카드가 존재합니다. \n해당 부분을 삭제 및 수정 후 다음 단계로 이동해주세요.",
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CreateMywordbookScreen(wordsInfo: wordCards),
                  ),
                );
              },
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
        centerTitle: true,
        backgroundColor: Color(0xFFFF983D),
        foregroundColor: Colors.white,
        //app bar 그림자 생기게 하기
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        //
        title: const Text(
          "단어장 만들기",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 30),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  //1. 단어 카드
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //현재 인덱스 위치 정보
                        Text.rich(
                          TextSpan(
                            text: "${currentCardIndex + 1}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFF983D),
                            ),
                            children: [
                              TextSpan(
                                text: " / ",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFA45200),
                                ),
                              ),
                              TextSpan(
                                text: "${wordCards.length}",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFFF983D),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: [
                            // 단어 카드
                            NewWordCardWidget(
                              wordController:
                                  _wordControllers[currentCardIndex],
                              meaningController:
                                  _meaningControllers[currentCardIndex],
                            ),

                            // 검색 결과
                            if (showSearchResults && searchResults.isNotEmpty)
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showSearchResults = false;
                                      searchResults = [];
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 110,
                                          left: 20,
                                          right: 20,
                                          child: GestureDetector(
                                            onTap: () {}, // 검색 결과 내부 터치는 무시
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxHeight: 130,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Color(0xFFFF983D),
                                                  width: 2,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(alpha: 0.2),
                                                    blurRadius: 5,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                itemCount: searchResults.length,
                                                itemBuilder: (context, index) {
                                                  final word =
                                                      searchResults[index];
                                                  return InkWell(
                                                    onTap: () {
                                                      selectSearchResult(word);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 8,
                                                          ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            word.word,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Color(
                                                                0xFFFF983D,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            word.meaning,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors
                                                                      .black54,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 5),
                        //카드 삭제 버튼
                        ElevatedButton(
                          onPressed: () => deleteCard(currentCardIndex),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF983D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "삭제",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //2. 화살표
                  //2-1. 왼쪽 화살표
                  Positioned(
                    left: 5,
                    child: IconButton(
                      onPressed: () => moveCard(isLeft: true),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  //2-2. 오른쪽 화살표
                  Positioned(
                    right: 5,
                    child: IconButton(
                      onPressed: () => moveCard(isLeft: false),
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 40,
                        color: Colors.black,
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
}
