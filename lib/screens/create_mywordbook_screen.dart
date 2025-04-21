import 'package:flutter/material.dart';

class CreateMyWordBookScreen extends StatefulWidget {
  const CreateMyWordBookScreen({super.key});

  @override
  State<CreateMyWordBookScreen> createState() => _CreateMyWordBookScreenState();
}

class _CreateMyWordBookScreenState extends State<CreateMyWordBookScreen>
    with
        TickerProviderStateMixin //Ticker 애니메이션 효과 부여
        {
  //영어 단어와 뜻 저장 List
  final List<Map<String, String>> _cards = List.generate(
    3,
    (index) => {"word": "", "meaning": ""},
  );

  int _currentIndex = 0;

  void _goToPage(int index) {
    if (index == _cards.length) {
      setState(() {
        _cards.add({"word": "", "meaning": ""});
      });
    }
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
    //겹친 카드가 보이는 정도
    const double overlap = 20;

    //휴대폰 화면 크기 (MediaQuery)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    //화면에 출력될 카드를 담는 리스트
    final List<Map<String, dynamic>> visibleCards = [];

    //화면에 출력될 카드를 계산 -> 리스트에 add
    for (int i = 0; i < _cards.length; i++) {
      int delta = i - _currentIndex;

      //마지막 카드이거나, 앞, 뒤 2개의 카드가 아니라면 continue.
      if (_currentIndex >= _cards.length - 1 && delta > 0) continue;

      //현재 카드로부터 앞, 뒤 2개의 카드까지는 list에 추가
      if (delta >= -2 && delta <= 2) {
        visibleCards.add({"index": i, "delta": delta});
      }
    }

    //final sortOrder = [-2, 2, -1, 1, 0];
    final sortOrder = [-2, 2, -1, 1, 0];
    visibleCards.sort(
      (a, b) => sortOrder.indexOf(a["delta"]) - sortOrder.indexOf(b["delta"]),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFDF3EB),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: screenHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...visibleCards.map((cardInfo) {
                int i = cardInfo["index"];
                int delta = cardInfo["delta"];

                double scale = 1.0 - (delta.abs() * 0.05);
                double dx = delta * overlap * 2;
                double baseLeft = screenWidth / 2 - cardWidth / 2 + dx;
                double baseTop = screenHeight / 2 - cardHeight / 2;

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
                        TextField(
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
                  icon: const Icon(Icons.arrow_left, size: 40),
                  onPressed: () {
                    _goToPage(_currentIndex - 1);
                  },
                ),
              ),

              // 오른쪽 화살표
              Positioned(
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_right, size: 40),
                  onPressed: () {
                    _goToPage(_currentIndex + 1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
