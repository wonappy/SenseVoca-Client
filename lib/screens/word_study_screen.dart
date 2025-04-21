import 'package:flutter/material.dart';

import '../models/word_info_model.dart';
import '../styles/white_to_orange_button_style.dart';
import '../widgets/word_card_widget.dart';

class WordStudyScreen extends StatefulWidget {
  final List<int> wordList;
  final int sectionIndex;
  final int wordCount;

  const WordStudyScreen({
    super.key,
    required this.wordList,
    required this.sectionIndex,
    required this.wordCount,
  });

  @override
  State<WordStudyScreen> createState() => _WordStudyScreenState();
}

class _WordStudyScreenState extends State<WordStudyScreen>
    with TickerProviderStateMixin {
  int currentIndex = 0; //현재 카드 인덱스
  bool isAnimating = false; //애니메이팅 동작 상태
  bool isLeft = true; //화살표 눌림 방향 상태 (t: 왼쪽, f: 오른쪽)

  //임시 데이터 [DB 역할]
  final List<WordInfoModel> dbWord = [
    WordInfoModel(
      wordId: 1,
      word: "apple",
      meaning: "[명] 사과",
      pronunciation: "ˈæp.əl",
      mnemonicExample: "[애플] {사과}처럼 생겼네!",
      mnemonicImageUrl: "https://example.com/images/apple.png",
      exampleSentenceEn: "I saw an [apple] yesterday.",
      exampleSentenceKo: "나는 어제 [apple]를 봤다.",
    ),
    WordInfoModel(
      wordId: 2,
      word: "book",
      meaning: "[명] 책",
      pronunciation: "bʊk",
      mnemonicExample: "[북]~소리 나듯 {책} 넘기는 소리",
      mnemonicImageUrl: "https://example.com/images/book.png",
      exampleSentenceEn: "I saw a [book] yesterday.",
      exampleSentenceKo: "나는 어제 [book]를 봤다.",
    ),
    WordInfoModel(
      wordId: 3,
      word: "car",
      meaning: "[명] 자동차",
      pronunciation: "kɑːr",
      mnemonicExample: "[카]! {자동차}가 달려간다",
      mnemonicImageUrl: "https://example.com/images/car.png",
      exampleSentenceEn: "I saw a [car] yesterday.",
      exampleSentenceKo: "나는 어제 [car]를 봤다.",
    ),
    WordInfoModel(
      wordId: 4,
      word: "dog",
      meaning: "[명] 개",
      pronunciation: "dɔːɡ",
      mnemonicExample: "[독]하게 짖는 {개}",
      mnemonicImageUrl: "https://example.com/images/dog.png",
      exampleSentenceEn: "I saw a [dog] yesterday.",
      exampleSentenceKo: "나는 어제 [dog]를 봤다.",
    ),
    WordInfoModel(
      wordId: 5,
      word: "elephant",
      meaning: "[명] 코끼리",
      pronunciation: "ˈel.ɪ.fənt",
      mnemonicExample: "[엘리펀트]는 코가 길다~",
      mnemonicImageUrl: "https://example.com/images/elephant.png",
      exampleSentenceEn: "I saw an [elephant] yesterday.",
      exampleSentenceKo: "나는 어제 [elephant]를 봤다.",
    ),
    WordInfoModel(
      wordId: 6,
      word: "flower",
      meaning: "[명] 꽃",
      pronunciation: "ˈflaʊ.ər",
      mnemonicExample: "[플라워]~ {꽃}이 활짝",
      mnemonicImageUrl: "https://example.com/images/flower.png",
      exampleSentenceEn: "I saw a [flower] yesterday.",
      exampleSentenceKo: "나는 어제 [flower]를 봤다.",
    ),
    WordInfoModel(
      wordId: 7,
      word: "grape",
      meaning: "[명] 포도",
      pronunciation: "ɡreɪp",
      mnemonicExample: "[그레이프], 보라색 {포도}즙!",
      mnemonicImageUrl: "https://example.com/images/grape.png",
      exampleSentenceEn: "I saw a [grape] yesterday.",
      exampleSentenceKo: "나는 어제 [grape]를 봤다.",
    ),
    WordInfoModel(
      wordId: 8,
      word: "house",
      meaning: "[명] 집",
      pronunciation: "haʊs",
      mnemonicExample: "[하우스], 따뜻한 {집}",
      mnemonicImageUrl: "https://example.com/images/house.png",
      exampleSentenceEn: "I saw a [house] yesterday.",
      exampleSentenceKo: "나는 어제 [house]를 봤다.",
    ),
    WordInfoModel(
      wordId: 9,
      word: "ice",
      meaning: "[명] 얼음",
      pronunciation: "aɪs",
      mnemonicExample: "[아이스]~ 차가운 {얼음}",
      mnemonicImageUrl: "https://example.com/images/ice.png",
      exampleSentenceEn: "I saw a [ice] yesterday.",
      exampleSentenceKo: "나는 어제 [ice]를 봤다.",
    ),
    WordInfoModel(
      wordId: 10,
      word: "juice",
      meaning: "[명] 주스",
      pronunciation: "dʒuːs",
      mnemonicExample: "[쥬스]~ 달콤한 {주스} 한 잔",
      mnemonicImageUrl: "https://example.com/images/juice.png",
      exampleSentenceEn: "I saw a [juice] yesterday.",
      exampleSentenceKo: "나는 어제 [juice]를 봤다.",
    ),
    WordInfoModel(
      wordId: 11,
      word: "kite",
      meaning: "[명] 연",
      pronunciation: "kaɪt",
      mnemonicExample: "[카이트]~ 하늘을 나는 {연}",
      mnemonicImageUrl: "https://example.com/images/kite.png",
      exampleSentenceEn: "I saw a [kite] yesterday.",
      exampleSentenceKo: "나는 어제 [kite]를 봤다.",
    ),
    WordInfoModel(
      wordId: 12,
      word: "lion",
      meaning: "[명] 사자",
      pronunciation: "ˈlaɪ.ən",
      mnemonicExample: "[라이언], {사자}의 포효",
      mnemonicImageUrl: "https://example.com/images/lion.png",
      exampleSentenceEn: "I saw a [lion] yesterday.",
      exampleSentenceKo: "나는 어제 [lion]를 봤다.",
    ),
    WordInfoModel(
      wordId: 13,
      word: "moon",
      meaning: "[명] 달",
      pronunciation: "muːn",
      mnemonicExample: "[문]~ 밤하늘 {달}빛",
      mnemonicImageUrl: "https://example.com/images/moon.png",
      exampleSentenceEn: "I saw a [moon] yesterday.",
      exampleSentenceKo: "나는 어제 [moon]를 봤다.",
    ),
    WordInfoModel(
      wordId: 14,
      word: "notebook",
      meaning: "[명] 공책",
      pronunciation: "ˈnəʊt.bʊk",
      mnemonicExample: "[노트북]에 노트를 적자",
      mnemonicImageUrl: "https://example.com/images/notebook.png",
      exampleSentenceEn: "I saw a [notebook] yesterday.",
      exampleSentenceKo: "나는 어제 [notebook]를 봤다.",
    ),
    WordInfoModel(
      wordId: 15,
      word: "orange",
      meaning: "[명] 오렌지",
      pronunciation: "ˈɒr.ɪndʒ",
      mnemonicExample: "[오렌지]~ 상큼해",
      mnemonicImageUrl: "https://example.com/images/orange.png",
      exampleSentenceEn: "I saw a [orange] yesterday.",
      exampleSentenceKo: "나는 어제 [orange]를 봤다.",
    ),
    WordInfoModel(
      wordId: 16,
      word: "pencil",
      meaning: "[명] 연필",
      pronunciation: "ˈpen.səl",
      mnemonicExample: "[펜슬]로 그림 그려요",
      mnemonicImageUrl: "https://example.com/images/pencil.png",
      exampleSentenceEn: "I saw a [pencil] yesterday.",
      exampleSentenceKo: "나는 어제 [pencil]를 봤다.",
    ),
    WordInfoModel(
      wordId: 17,
      word: "queen",
      meaning: "[명] 여왕",
      pronunciation: "kwiːn",
      mnemonicExample: "[퀸]처럼 우아한 {여왕}",
      mnemonicImageUrl: "https://example.com/images/queen.png",
      exampleSentenceEn: "I saw a [queen] yesterday.",
      exampleSentenceKo: "나는 어제 [queen]를 봤다.",
    ),
    WordInfoModel(
      wordId: 18,
      word: "rabbit",
      meaning: "[명] 토끼",
      pronunciation: "ˈræb.ɪt",
      mnemonicExample: "[래빗]~ 깡총깡총",
      mnemonicImageUrl: "https://example.com/images/rabbit.png",
      exampleSentenceEn: "I saw a [rabbit] yesterday.",
      exampleSentenceKo: "나는 어제 [rabbit]를 봤다.",
    ),
    WordInfoModel(
      wordId: 19,
      word: "sun",
      meaning: "[명] 태양",
      pronunciation: "sʌn",
      mnemonicExample: "[선]~ 따뜻한 햇살",
      mnemonicImageUrl: "https://example.com/images/sun.png",
      exampleSentenceEn: "I saw a [sun] yesterday.",
      exampleSentenceKo: "나는 어제 [sun]를 봤다.",
    ),
    WordInfoModel(
      wordId: 20,
      word: "tree",
      meaning: "[명] 나무",
      pronunciation: "triː",
      mnemonicExample: "[트리]~ 크리스마스[트리]!",
      mnemonicImageUrl: "https://example.com/images/tree.png",
      exampleSentenceEn: "I saw a [tree] yesterday.",
      exampleSentenceKo: "나는 어제 [tree]를 봤다.",
    ),
    WordInfoModel(
      wordId: 21,
      word: "umbrella",
      meaning: "[명] 우산",
      pronunciation: "ʌmˈbrel.ə",
      mnemonicExample: "[umbrella]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/umbrella.png",
      exampleSentenceEn: "I saw a [umbrella] yesterday.",
      exampleSentenceKo: "나는 어제 [umbrella]를 봤다.",
    ),
    WordInfoModel(
      wordId: 22,
      word: "violin",
      meaning: "[명] 바이올린",
      pronunciation: "ˌvaɪ.əˈlɪn",
      mnemonicExample: "[violin]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/violin.png",
      exampleSentenceEn: "I saw a [violin] yesterday.",
      exampleSentenceKo: "나는 어제 [violin]를 봤다.",
    ),
    WordInfoModel(
      wordId: 23,
      word: "whale",
      meaning: "[명] 고래",
      pronunciation: "weɪl",
      mnemonicExample: "[whale]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/whale.png",
      exampleSentenceEn: "I saw a [whale] yesterday.",
      exampleSentenceKo: "나는 어제 [whale]를 봤다.",
    ),
    WordInfoModel(
      wordId: 24,
      word: "xylophone",
      meaning: "[명] 실로폰",
      pronunciation: "ˈzaɪ.lə.fəʊn",
      mnemonicExample: "[xylophone]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/xylophone.png",
      exampleSentenceEn: "I saw a [xylophone] yesterday.",
      exampleSentenceKo: "나는 어제 [xylophone]를 봤다.",
    ),
    WordInfoModel(
      wordId: 25,
      word: "yogurt",
      meaning: "[명] 요구르트",
      pronunciation: "ˈjɒɡ.ət",
      mnemonicExample: "[yogurt]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/yogurt.png",
      exampleSentenceEn: "I saw a [yogurt] yesterday.",
      exampleSentenceKo: "나는 어제 [yogurt]를 봤다.",
    ),
    WordInfoModel(
      wordId: 26,
      word: "zebra",
      meaning: "[명] 얼룩말",
      pronunciation: "ˈze.brə",
      mnemonicExample: "[zebra]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/zebra.png",
      exampleSentenceEn: "I saw a [zebra] yesterday.",
      exampleSentenceKo: "나는 어제 [zebra]를 봤다.",
    ),
    WordInfoModel(
      wordId: 27,
      word: "ball",
      meaning: "[명] 공",
      pronunciation: "bɔːl",
      mnemonicExample: "[ball]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/ball.png",
      exampleSentenceEn: "I saw a [ball] yesterday.",
      exampleSentenceKo: "나는 어제 [ball]를 봤다.",
    ),
    WordInfoModel(
      wordId: 28,
      word: "candle",
      meaning: "[명] 양초",
      pronunciation: "ˈkæn.dəl",
      mnemonicExample: "[candle]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/candle.png",
      exampleSentenceEn: "I saw a [candle] yesterday.",
      exampleSentenceKo: "나는 어제 [candle]를 봤다.",
    ),
    WordInfoModel(
      wordId: 29,
      word: "desk",
      meaning: "[명] 책상",
      pronunciation: "desk",
      mnemonicExample: "[desk]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/desk.png",
      exampleSentenceEn: "I saw a [desk] yesterday.",
      exampleSentenceKo: "나는 어제 [desk]를 봤다.",
    ),
    WordInfoModel(
      wordId: 30,
      word: "ear",
      meaning: "[명] 귀",
      pronunciation: "ɪər",
      mnemonicExample: "[ear]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/ear.png",
      exampleSentenceEn: "I saw a [ear] yesterday.",
      exampleSentenceKo: "나는 어제 [ear]를 봤다.",
    ),
    WordInfoModel(
      wordId: 31,
      word: "fan",
      meaning: "[명] 선풍기",
      pronunciation: "fæn",
      mnemonicExample: "[fan]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/fan.png",
      exampleSentenceEn: "I saw a [fan] yesterday.",
      exampleSentenceKo: "나는 어제 [fan]를 봤다.",
    ),
    WordInfoModel(
      wordId: 32,
      word: "glove",
      meaning: "[명] 장갑",
      pronunciation: "ɡlʌv",
      mnemonicExample: "[glove]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/glove.png",
      exampleSentenceEn: "I saw a [glove] yesterday.",
      exampleSentenceKo: "나는 어제 [glove]를 봤다.",
    ),
    WordInfoModel(
      wordId: 33,
      word: "hat",
      meaning: "[명] 모자",
      pronunciation: "hæt",
      mnemonicExample: "[hat]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/hat.png",
      exampleSentenceEn: "I saw a [hat] yesterday.",
      exampleSentenceKo: "나는 어제 [hat]를 봤다.",
    ),
    WordInfoModel(
      wordId: 34,
      word: "island",
      meaning: "[명] 섬",
      pronunciation: "ˈaɪ.lənd",
      mnemonicExample: "[island]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/island.png",
      exampleSentenceEn: "I saw a [island] yesterday.",
      exampleSentenceKo: "나는 어제 [island]를 봤다.",
    ),
    WordInfoModel(
      wordId: 35,
      word: "jacket",
      meaning: "[명] 재킷",
      pronunciation: "ˈdʒæk.ɪt",
      mnemonicExample: "[jacket]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/jacket.png",
      exampleSentenceEn: "I saw a [jacket] yesterday.",
      exampleSentenceKo: "나는 어제 [jacket]를 봤다.",
    ),
    WordInfoModel(
      wordId: 36,
      word: "key",
      meaning: "[명] 열쇠",
      pronunciation: "kiː",
      mnemonicExample: "[key]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/key.png",
      exampleSentenceEn: "I saw a [key] yesterday.",
      exampleSentenceKo: "나는 어제 [key]를 봤다.",
    ),
    WordInfoModel(
      wordId: 37,
      word: "lamp",
      meaning: "[명] 램프",
      pronunciation: "læmp",
      mnemonicExample: "[lamp]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/lamp.png",
      exampleSentenceEn: "I saw a [lamp] yesterday.",
      exampleSentenceKo: "나는 어제 [lamp]를 봤다.",
    ),
    WordInfoModel(
      wordId: 38,
      word: "mirror",
      meaning: "[명] 거울",
      pronunciation: "ˈmɪr.ər",
      mnemonicExample: "[mirror]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/mirror.png",
      exampleSentenceEn: "I saw a [mirror] yesterday.",
      exampleSentenceKo: "나는 어제 [mirror]를 봤다.",
    ),
    WordInfoModel(
      wordId: 39,
      word: "necklace",
      meaning: "[명] 목걸이",
      pronunciation: "ˈnek.ləs",
      mnemonicExample: "[necklace]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/necklace.png",
      exampleSentenceEn: "I saw a [necklace] yesterday.",
      exampleSentenceKo: "나는 어제 [necklace]를 봤다.",
    ),
    WordInfoModel(
      wordId: 40,
      word: "ocean",
      meaning: "[명] 바다",
      pronunciation: "ˈəʊ.ʃən",
      mnemonicExample: "[ocean]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/ocean.png",
      exampleSentenceEn: "I saw [ocean] yesterday.",
      exampleSentenceKo: "나는 어제 [ocean]를 봤다.",
    ),
    WordInfoModel(
      wordId: 41,
      word: "piano",
      meaning: "[명] 피아노",
      pronunciation: "piˈæn.əʊ",
      mnemonicExample: "[piano]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/piano.png",
      exampleSentenceEn: "I saw a [piano] yesterday.",
      exampleSentenceKo: "나는 어제 [piano]를 봤다.",
    ),
    WordInfoModel(
      wordId: 42,
      word: "quilt",
      meaning: "[명] 누비이불",
      pronunciation: "kwɪlt",
      mnemonicExample: "[quilt]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/quilt.png",
      exampleSentenceEn: "I saw a [quilt] yesterday.",
      exampleSentenceKo: "나는 어제 [quilt]를 봤다.",
    ),
    WordInfoModel(
      wordId: 43,
      word: "ring",
      meaning: "[명] 반지",
      pronunciation: "rɪŋ",
      mnemonicExample: "[ring]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/ring.png",
      exampleSentenceEn: "I saw a [ring] yesterday.",
      exampleSentenceKo: "나는 어제 [ring]를 봤다.",
    ),
    WordInfoModel(
      wordId: 44,
      word: "sock",
      meaning: "[명] 양말",
      pronunciation: "sɒk",
      mnemonicExample: "[sock]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/sock.png",
      exampleSentenceEn: "I saw a [sock] yesterday.",
      exampleSentenceKo: "나는 어제 [sock]를 봤다.",
    ),
    WordInfoModel(
      wordId: 45,
      word: "telephone",
      meaning: "[명] 전화기",
      pronunciation: "ˈtel.ɪ.fəʊn",
      mnemonicExample: "[telephone]는 발음처럼 쉽게 외우자!",
      mnemonicImageUrl: "https://example.com/images/telephone.png",
      exampleSentenceEn: "I saw a [telephone] yesterday.",
      exampleSentenceKo: "나는 어제 [telephone]를 봤다.",
    ),
  ];

  //임시 데이터 [api 반환값 역할]
  List<WordInfoModel> wordInfoList = [];

  //애니메이션 변수
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // 선택된 단어의 인덱스로 검색해서 구간 내 단어 정보 리스트 생성
    wordInfoList =
        dbWord.where((word) => widget.wordList.contains(word.wordId)).toList();

    _setupAnimation(); //카드 애니메이션 초기 상태 설정
  }

  @override
  void dispose() {
    _animationController.dispose();
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
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${widget.sectionIndex + 1}구간  ',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: '${currentIndex + 1}',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' / ${widget.wordList.length}',
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

      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  //현재 카드 (애니메이션 x)
                  if (!isAnimating)
                    WordCard(word: wordInfoList[currentIndex], accent: "us"),
                  //다음 카드 출력(애니메이션 중일 때)
                  if (showNext)
                    WordCard(word: wordInfoList[nextIndex], accent: "us"),
                  //현재 카드 (애니메이션 중일 때)
                  if (isAnimating)
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: _slideAnimation.value * screenWidth,
                          child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: WordCard(
                              word: wordInfoList[currentIndex],
                              accent: "us",
                            ),
                          ),
                        );
                      },
                    ),

                  // 왼쪽 화살표
                  if (currentIndex > 0)
                    Positioned(
                      left: 0,
                      child: ElevatedButton(
                        onPressed: () => _changeCard(true),
                        style: whiteOrangeButtonStyle(),
                        child: Icon(Icons.arrow_back_ios_new_rounded, size: 30),
                      ),
                    ),
                  // 오른쪽 화살표
                  if (currentIndex < widget.wordList.length - 1)
                    Positioned(
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () {
                          _changeCard(false);
                        },
                        style: whiteOrangeButtonStyle(),
                        child: Icon(Icons.arrow_forward_ios_rounded, size: 30),
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

  //카드 애니메이션 초기 상태 설정 (내부 함수로 사용)
  void _setupAnimation() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    //카드 이동 방향 애니메이션
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    //카드 이동 시 둥글게 이동하는 애니메이션
    _rotationAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  //화살표 버튼 -> 애니메이션 결정
  void _changeCard(bool left) {
    if (_animationController.isAnimating || isAnimating) return;

    final nextIndex = currentIndex + (left ? -1 : 1);
    if (nextIndex < 0 || nextIndex >= widget.wordList.length) return;

    setState(() {
      isAnimating = true;
      isLeft = left;

      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(left ? 1.2 : -1.2, 0),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      _rotationAnimation = Tween<double>(
        begin: 0.0,
        end: left ? -0.1 : 0.1,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
    });

    _animationController.forward(from: 0).whenComplete(() {
      setState(() {
        currentIndex = nextIndex;
        isAnimating = false;
      });
    });
  }
}
