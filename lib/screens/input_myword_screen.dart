import 'package:flutter/material.dart';
import 'package:sense_voka/screens/create_mywordbook_screen.dart';
import 'package:sense_voka/widgets/show_dialog_widget.dart';

class InputMyWordScreen extends StatefulWidget {
  const InputMyWordScreen({super.key});

  @override
  State<InputMyWordScreen> createState() => _InputMyWordScreenState();
}

class _InputMyWordScreenState extends State<InputMyWordScreen>
    with TickerProviderStateMixin {
  //영어 단어와 뜻 저장 List
  final List<Map<String, String>> _cards = List.generate(
    1,
    (index) => {"word": "", "meaning": ""},
  );

  //현재 카드 index
  int _currentIndex = 0;

  //다음 페이지 이동 : index로 이동
  void _goToPage(int index) {
    //기존 범위를 초과했을 때, 새 카드 추가
    if (index == _cards.length) {
      setState(() {
        _cards.add({"word": "", "meaning": ""});
      });
    }
    //다음 카드로 이동
    if (index >= 0 && index < _cards.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //카드 크기
    const double cardWidth = 300;
    const double cardHeight = 310;
    //뒤 카드가 보이는 정도
    const double overlap = 20;

    //화면에 표시될 카드 리스트 (index, delta)
    final List<Map<String, dynamic>> visibleCards = [];

    //화면에 표시될 카드를 계산 (현재 카드, 앞 카드 2개, 뒤 카드 2개, 총 5개)
    for (int i = 0; i < _cards.length; i++) {
      //현재 카드로부터의 거리
      //delta > 0 : 뒤 카드
      //delta == 0 : 현재 카드
      //delta < 0 : 앞 카드
      int delta = i - _currentIndex;

      //마지막 카드일 때, 뒤 카드 두개는 포함 x
      if (_currentIndex >= _cards.length - 1 && delta > 0) continue;

      //현재 카드로부터 앞, 뒤 2개의 카드 포함
      if (delta >= -2 && delta <= 2) {
        visibleCards.add({"index": i, "delta": delta});
      }
    }

    //카드 출력 순서 (현재 카드가 가장 앞에 -> 가장 마지막에 그려짐)
    final sortOrder = [-2, -1, 2, 1, 0];
    visibleCards.sort(
      (a, b) => sortOrder.indexOf(a["delta"]) - sortOrder.indexOf(b["delta"]),
    );

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
                if (_cards.any((card) => card["word"] == "") ||
                    _cards.any((card) => card["meaning"] == "")) {
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
                        (context) => CreateMywordbookScreen(wordsInfo: _cards),
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
      body: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                //카드 출력
                ...visibleCards.map((cardInfo) {
                  int i = cardInfo["index"];
                  int delta = cardInfo["delta"];

                  double scale = 1.0 - (delta.abs() * 0.05);
                  double dx = delta * overlap * 2; //겹쳐서 보여지는 크기
                  //double baseLeft = screenWidth / 2 - cardWidth / 2 + dx;
                  //double baseTop = screenHeight / 2 - cardHeight / 2;

                  //애니메이션 출력
                  return AnimatedAlign(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      transform:
                          Matrix4.identity()
                            ..translate(dx)
                            ..scale(scale),
                      curve: Curves.easeInOut,
                      width: cardWidth,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            initialValue: _cards[i]["word"],
                            onChanged: (text) => _cards[i]["word"] = text,
                            decoration: InputDecoration(
                              hintText: "단어를 입력하세요.",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFFFF983D),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            onChanged: (text) => _cards[i]["meaning"] = text,
                            decoration: InputDecoration(
                              hintText: "뜻을 입력하세요.",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFFFF983D),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "카드 ${i + 1} / ${_cards.length}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // 왼쪽 화살표
                Positioned(
                  left: 10,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 40,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _goToPage(_currentIndex - 1);
                    },
                  ),
                ),
                // 오른쪽 화살표
                Positioned(
                  right: 10,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 40,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _goToPage(_currentIndex + 1);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            //단어 삭제 버튼
            ElevatedButton(
              onPressed: () {
                for (int i = 0; i < _cards.length; i++) {
                  print("${_cards[i]["word"]} , ${_cards[i]["meaning"]} \n");
                }
              },
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
    );
  }
}
