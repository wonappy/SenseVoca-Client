import 'package:flutter/material.dart';

import '../models/word_preview_model.dart';
import '../services/mywordbooks_service.dart';
import '../styles/error_snack_bar_style.dart';
import '../styles/orange_button_style.dart';
import '../widgets/action_button_widget.dart';
import '../widgets/random_word_card_widget.dart';
import '../widgets/show_dialog_widget.dart';
import 'create_mywordbook_screen.dart';

//먼저 들어왔을 때 모달 창 켜기
//api 결과를 기다리는 동안 progress bar 띄우고

//랜덤 단어 출력
//체크 박스를 통해 원하지 않는 단어를 제거할 수 있도록 함.
//전체 선택, 전테 해제 제공
//선택된 단어를 제외하고 다시 랜덤을 돌릴 수 있도록 함(?)
//다음 버튼을 눌렀을 때 -> create mywordbook_screen으로 이동

class CreateRandomWordBookScreen extends StatefulWidget {
  const CreateRandomWordBookScreen({super.key});

  @override
  State<CreateRandomWordBookScreen> createState() =>
      _CreateRandomWordBookScreenState();
}

class _CreateRandomWordBookScreenState
    extends State<CreateRandomWordBookScreen> {
  //상단 container 스크롤 컨트롤러
  final ScrollController _selectedWordScrollController = ScrollController();

  //초기 상태 확인 변수
  bool isInitial = true;

  List<WordPreviewModel> wordsInWordBook = [];
  //랜덤 카드 목록
  List<WordPreviewModel> randomWords = [];
  //랜덤 카드 눌림 상태 저장 (카드 wordId 저장)
  List<int> pressedCardsWordId = [];

  OverlayEntry? _pickerOverlay; //모달 창 여러개 출력 방지
  late int _pickCount;

  //초기 상태 변경
  void exitInitialState() {
    setState(() {
      isInitial = false;
      pickRandomWords(count: 10);
    });
  }

  @override
  void dispose() {
    _selectedWordScrollController.dispose();
    super.dispose();
  }

  //단어 랜덤 뽑기
  void pickRandomWords({required int count}) async {
    //api 호출
    var result = await MywordbooksService.getRandomMyWord(randomCount: count);

    if (mounted) {
      if (result.isSuccess) {
        setState(() {
          randomWords = result.data;
          pressedCardsWordId.clear(); //눌렸던 랜덤 카드 저장 리스트 초기화
          //랜덤 카드 리스트 중 이미 단어장에 포함된 단어는 눌림 상태 처리
          for (var word in randomWords) {
            if (wordsInWordBook.contains(word)) {
              pressedCardsWordId.add(word.wordId!);
            }
          }
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
    // final shuffledList = List<WordPreviewModel>.from(wordPreviewList)
    //   ..shuffle(Random()); //중복 x
    // setState(() {
    //   randomWords = shuffledList.take(count).toList(); //랜덤 카드 리스트 제공
    //   pressedCardsWordId.clear(); //눌렸던 랜덤 카드 저장 리스트 초기화
    //   //랜덤 카드 리스트 중 이미 단어장에 포함된 단어는 눌림 상태 처리
    //   for (var word in randomWords) {
    //     if (wordsInWordBook.contains(word)) {
    //       pressedCardsWordId.add(word.wordId);
    //     }
    //   }
    // });
  }

  //단어장 전체 선택
  void selectAllWordCards() {
    setState(() {
      for (var word in randomWords) {
        if (!pressedCardsWordId.contains(word.wordId)) {
          pressedCardsWordId.add(word.wordId!);
        }
        if (!wordsInWordBook.contains(word)) {
          wordsInWordBook.add(word);
        }
      }

      // 단어 추가 후 추가된 위치로 스크롤 이동
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //프레임이 종료된 직후 실행
        if (_selectedWordScrollController.hasClients) {
          _selectedWordScrollController.animateTo(
            _selectedWordScrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  //단어장 전체 선택 해체
  void deselectAllWordCards() {
    setState(() {
      for (var word in randomWords) {
        if (pressedCardsWordId.contains(word.wordId)) {
          pressedCardsWordId.remove(word.wordId);
        }
        if (wordsInWordBook.contains(word)) {
          wordsInWordBook.remove(word);
        }
      }
    });
  }

  //랜덤 카드 선택 해제
  void removeWord({required int wordId}) {
    setState(() {
      wordsInWordBook.removeWhere((word) => word.wordId == wordId);
      //랜덤 버튼 중에 해당하는 버튼이 있다면 눌림 상태 해제
      if (pressedCardsWordId.contains(wordId)) {
        pressedCardsWordId.remove(wordId);
      }
    });
  }

  //랜덤 카드 선택
  void _toggleRandomWordCard({required WordPreviewModel word}) {
    setState(() {
      //랜덤 버튼 눌림 상태 갱신
      if (pressedCardsWordId.contains(word.wordId)) {
        pressedCardsWordId.remove(word.wordId);
        //단어장 목록에서 제거
        if (wordsInWordBook.contains(word)) {
          wordsInWordBook.remove(word);
        }
      } else {
        pressedCardsWordId.add(word.wordId!);
        //단어장 목록에 추가
        if (!wordsInWordBook.contains(word)) {
          wordsInWordBook.add(word);

          // 단어 추가 후 추가된 위치로 스크롤 이동
          WidgetsBinding.instance.addPostFrameCallback((_) {
            //프레임이 종료된 직후 실행
            if (_selectedWordScrollController.hasClients) {
              _selectedWordScrollController.animateTo(
                _selectedWordScrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          "단어장 생성",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {
                //값을 갖는 카드가 존재한다면,
                if (wordsInWordBook.isEmpty) {
                  showDialogWidget(
                    context: context,
                    title: "경고",
                    msg: "단어장에 포함된 단어가 없습니다. \n 최소 1개의 단어가 필요합니다.",
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CreateMywordbookScreen(wordsInfo: wordsInWordBook),
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
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            //선택된 단어 개수
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "총 ${wordsInWordBook.length}개",
                style: TextStyle(fontSize: 19),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.013),
            //선택된 단어 목록
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.27,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    offset: Offset(0, 8),
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ],
              ),
              child:
                  (wordsInWordBook.isEmpty)
                      ? Center(
                        child: Text(
                          "단어장에 포함될 단어를 선택해주세요.",
                          style: TextStyle(color: Colors.black26),
                        ),
                      )
                      : Container(
                        //선택된 단어장 단어 목록 출력
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 4,
                          radius: Radius.circular(5),
                          child: SingleChildScrollView(
                            controller:
                                _selectedWordScrollController, //스크롤 컨트롤러 추가
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:
                                  wordsInWordBook.map((word) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                word.word,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                word.meaning.replaceAll(
                                                  '; ',
                                                  '\n',
                                                ),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed:
                                                    () => removeWord(
                                                      wordId: word.wordId!,
                                                    ),
                                                icon: Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.deepOrange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.black12,
                                          thickness: 1.0,
                                          height: 0.0,
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              isInitial ? "단어 랜덤 뽑기 버튼을 눌러주세요." : "단어장에 포함될 단어를 선택해주세요.",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //랜덤 뽑기 단어
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.43,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    offset: Offset(0, 8),
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child:
                    isInitial
                        ? Center(
                          child: ActionButtonWidget(
                            onPressed: exitInitialState,
                            bWidth: MediaQuery.of(context).size.width * 0.47,
                            bHeight: MediaQuery.of(context).size.height * 0.05,
                            fontSize: 25,
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFFF983D),
                            fontWeight: FontWeight.w800,
                            text: "단어 랜덤 뽑기",
                          ),
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //전체 선택, 선택 해제 버튼
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ActionButtonWidget(
                                  onPressed: selectAllWordCards,
                                  bWidth:
                                      MediaQuery.of(context).size.width * 0.23,
                                  bHeight:
                                      MediaQuery.of(context).size.height * 0.04,
                                  foregroundColor: Color(0xFFFF983D),
                                  fontSize: 15,
                                  borderSide: 2,
                                  borderRadius: 12,
                                  elevation: 2,
                                  text: "전체 선택",
                                ),
                                SizedBox(width: 10),
                                ActionButtonWidget(
                                  onPressed: deselectAllWordCards,
                                  bWidth:
                                      MediaQuery.of(context).size.width * 0.3,
                                  bHeight:
                                      MediaQuery.of(context).size.height * 0.04,
                                  foregroundColor: Color(0xFFFF983D),
                                  fontSize: 15,
                                  borderSide: 2,
                                  borderRadius: 12,
                                  elevation: 2,
                                  text: "전체 선택 해제",
                                ),
                              ],
                            ),
                            // 단어 카드 버튼 위젯 생성
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.27, // 원하는 높이로 고정
                              child: GridView.builder(
                                itemCount: randomWords.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, // 3열
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      childAspectRatio: 1.2, // 정사각형
                                    ),
                                itemBuilder: (context, index) {
                                  return RandomWordCardWidget(
                                    word: randomWords[index].word,
                                    meaning: randomWords[index].meaning,
                                    isPressed: pressedCardsWordId.contains(
                                      randomWords[index].wordId,
                                    ),
                                    onPressed:
                                        () => _toggleRandomWordCard(
                                          word: randomWords[index],
                                        ),
                                  );
                                },
                              ),
                            ),
                            // 단어 다시 뽑기 버튼
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ActionButtonWidget(
                                onPressed: () => _showPickCountOverlay(context),
                                bWidth: MediaQuery.of(context).size.width * 0.4,
                                bHeight:
                                    MediaQuery.of(context).size.height * 0.04,
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFFFF983D),
                                borderRadius: 12,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                text: "단어 다시 뽑기",
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPickCountOverlay(BuildContext context) {
    if (_pickerOverlay != null) return;
    _pickCount = 5; //초기의 뽑을 단어 개수

    final overlay = Overlay.of(context);
    // final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;
    // final offset = renderBox.localToGlobal(Offset.zero);

    _pickerOverlay = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: MediaQuery.of(context).size.height * 0.12, // 버튼 위로 약간 위
            left: MediaQuery.of(context).size.width * 0.12,
            right: MediaQuery.of(context).size.width * 0.08,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 7,
              child: StatefulBuilder(
                builder:
                    (context, setStateOverlay) => Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                Text(
                                  "뽑을 단어의 개수를 설정해주세요.",
                                  style: TextStyle(fontSize: 13.5),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _pickerOverlay?.remove();
                                    _pickerOverlay = null;
                                  },
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.013,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: orangeButtonStyle(width: 50, heigth: 40),
                                onPressed: () {
                                  setStateOverlay(() {
                                    if (_pickCount > 1) _pickCount--;
                                  });
                                },
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: "$_pickCount", // 기본 텍스트
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  children: [
                                    TextSpan(text: ' '),
                                    TextSpan(
                                      text: '개',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              ElevatedButton(
                                style: orangeButtonStyle(width: 50, heigth: 40),
                                onPressed: () {
                                  setStateOverlay(() {
                                    if (_pickCount < 20) _pickCount++;
                                  });
                                },
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          ElevatedButton(
                            style: orangeButtonStyle(width: 120, heigth: 45),
                            onPressed: () {
                              _pickerOverlay?.remove();
                              _pickerOverlay = null;
                              pickRandomWords(count: _pickCount);
                            },
                            child: Text(
                              "뽑기",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
    );

    overlay.insert(_pickerOverlay!);
  }
}
