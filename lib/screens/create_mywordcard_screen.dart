import 'package:flutter/material.dart';
import 'package:sense_voka/models/word_preview_model.dart';

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

  @override
  void initState() {
    super.initState();

    //controller에 리스너 추가
    _wordControllers[0].addListener(() {
      wordCards[0].word = _wordControllers[0].text;
    });
    _meaningControllers[0].addListener(() {
      wordCards[0].meaning = _meaningControllers[0].text;
    });
  }

  //카드 이동(왼쪽 오른쪽)
  void moveCard({required bool isLeft}) {
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
      final wordController = TextEditingController();
      final meaningController = TextEditingController();

      // addListener 추가
      wordController.addListener(() {
        wordCards[_wordControllers.indexOf(wordController)].word =
            wordController.text;
      });
      meaningController.addListener(() {
        wordCards[_meaningControllers.indexOf(meaningController)].meaning =
            meaningController.text;
      });

      _wordControllers.add(wordController);
      _meaningControllers.add(meaningController);
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
                        NewWordCardWidget(
                          wordController: _wordControllers[currentCardIndex],
                          meaningController:
                              _meaningControllers[currentCardIndex],
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
