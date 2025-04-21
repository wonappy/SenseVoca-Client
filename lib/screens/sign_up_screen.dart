import 'package:flutter/material.dart';
import 'package:sense_voka/screens/sign_in_screen.dart';

import '../widgets/textfield_line_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final List<String> _interestCategories = ["운동", "낚시", "음악"];
  String? _selectedInterest = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedInterest = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //앱 배경색
      backgroundColor: Color(0xFFFF983D),
      body: Center(
        child: Container(
          width: 350,
          height: 500,
          decoration: BoxDecoration(
            color: Colors.white,
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                //페이지 이동 애니메이션 제거
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => SignInScreen(),
                                  transitionDuration:
                                      Duration.zero, // 애니메이션 지속시간 0
                                  reverseTransitionDuration:
                                      Duration.zero, // 뒤로 갈 때도 0
                                ),
                              );
                            },
                            icon: Icon(Icons.arrow_back_ios_new_rounded),
                            color: Colors.black,
                            iconSize: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 21),
                    //아이디 입력
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFieldLine(
                          hint: "아이디를 입력해주세요.",
                          fieldHeight: 35,
                          fieldWidth: 190,
                          lineThickness: 6,
                          obscureText: false,
                        ),
                        //중복 확인 버튼
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Color(0xFFFF983D),
                            ),
                            minimumSize: WidgetStateProperty.all(Size(10, 50)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            elevation: WidgetStateProperty.all(3),
                          ),
                          child: Text(
                            "중복\n확인",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    //비밀번호 입력
                    TextFieldLine(
                      hint: "비밀번호를 입력해주세요.",
                      fieldHeight: 35,
                      fieldWidth: 290,
                      lineThickness: 6,
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    //이름 입력
                    TextFieldLine(
                      hint: "이름을 입력해주세요.",
                      fieldHeight: 35,
                      fieldWidth: 290,
                      lineThickness: 6,
                      obscureText: false,
                    ),
                    SizedBox(height: 10),
                    //관심사 선택
                    SizedBox(
                      width: 290,
                      height: 35,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        underline: SizedBox.shrink(),
                        hint: Text(
                          "관심사를 선택해주세요.",
                          style: TextStyle(
                            color: Color(0xFFE1E1E1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: _selectedInterest,
                        items:
                            _interestCategories
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedInterest = value!;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 6,
                      width: 290,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF983D),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    SizedBox(height: 35),
                    //로그인 버튼
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 45,
                        width: 290,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF983D),
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              offset: Offset(0, 8),
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "회원가입",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              //간편 로그인 기능
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Divider(color: Colors.black12, thickness: 2.0),
                        ),
                        Text(
                          "간편가입",
                          style: TextStyle(
                            color: Color(0xFFFF983D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Divider(color: Colors.black12, thickness: 2.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.white,
                              minimumSize: Size(60, 60),
                            ),
                            child: Image.asset(
                              'assets/images/img_google_icon.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Color(0xFFFF983D),
                              minimumSize: Size(60, 60),
                            ),
                            child: Image.asset(
                              'assets/images/img_kakaotalk_icon.png',
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
