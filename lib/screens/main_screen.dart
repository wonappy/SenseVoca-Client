import 'package:flutter/material.dart';
import 'package:sense_voka/models/user_model.dart';

import '../widgets/navigation_button_widget.dart';
import 'mywordbook_screen.dart';

class MainScreen extends StatefulWidget {
  final UserModel user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.menu_rounded, size: 40),
        centerTitle: true,
        backgroundColor: Color(0xFFFF983D),
        foregroundColor: Colors.white,
        //app bar 그림자 생기게 하기
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        //
        title: const Text(
          "센스보카",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 사용자 프로필 및 점수
              Container(
                padding: EdgeInsets.all(13),
                width: 370,
                height: 310,
                decoration: BoxDecoration(
                  color: Color(0xFFFFE4CA),
                  borderRadius: BorderRadius.circular(30),
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
                    SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //CircleAvatar(radius: 40, backgroundColor: Colors.white),
                        Container(
                          width: 120,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 120,
                            color: Colors.black12,
                          ),
                        ),
                        SizedBox(width: 25),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '오늘 학습한 단어',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '75',
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF983D),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '/ 100 개',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '퀴즈 랭킹',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '3512',
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF983D),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '위',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.user.name,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text('님, 연속 학습 ', style: TextStyle(fontSize: 15)),
                        Text(
                          '10',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text('일 째입니다.', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              NavigationButtonWidget(
                text: "기본 제공 단어장",
                bHeight: 90,
                bWidth: 360,
                destinationScreen: MyWordBookScreen(),
              ),
              SizedBox(height: 10),
              NavigationButtonWidget(
                text: "나만의 단어장",
                bHeight: 90,
                bWidth: 360,
                destinationScreen: MyWordBookScreen(),
              ),
              SizedBox(height: 10),
              NavigationButtonWidget(
                text: "복습 단어장",
                bHeight: 90,
                bWidth: 360,
                destinationScreen: MyWordBookScreen(),
              ),
              SizedBox(height: 10),
              NavigationButtonWidget(
                text: "단어 퀴즈",
                bHeight: 90,
                bWidth: 360,
                destinationScreen: MyWordBookScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
