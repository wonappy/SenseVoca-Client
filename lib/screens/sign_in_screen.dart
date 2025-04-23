import 'package:flutter/material.dart';
import 'package:sense_voka/screens/main_screen.dart';
import 'package:sense_voka/screens/sign_up_screen.dart';

import '../models/user_model.dart';
import '../widgets/textfield_line_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController(); //아이디
  final _pwController = TextEditingController(); //비밀번호
  String email = "", pw = "";

  void _login() {
    //E/libEGL  ( 5158): called unimplemented OpenGL ES API 포커스한 채로 페이지 이동 방지
    FocusScope.of(context).unfocus();

    email = _emailController.text;
    pw = _pwController.text;
    if (email == "123" && pw == "123") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => MainScreen(
                user: UserModel(email: email, pw: pw, name: "권원경"),
              ),
          fullscreenDialog: true,
        ),
      );
    } else {
      //print("로그인 불가");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //앱 배경색
      backgroundColor: Color(0xFFFF983D),
      body: Center(
        child: Container(
          width: 350,
          height: 450,
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
                    Text(
                      '센스보카',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 21),
                    //아이디 입력
                    TextFieldLineWidget(
                      hint: "이메일을 입력해주세요.",
                      fieldHeight: 35,
                      fieldWidth: 290,
                      lineThickness: 6,
                      obscureText: false,
                      controller: _emailController,
                    ),
                    SizedBox(height: 10),
                    //비밀번호 입력
                    TextFieldLineWidget(
                      hint: "비밀번호를 입력해주세요.",
                      fieldHeight: 35,
                      fieldWidth: 290,
                      lineThickness: 6,
                      obscureText: true,
                      controller: _pwController,
                    ),
                    SizedBox(height: 35),
                    //로그인 버튼
                    GestureDetector(
                      onTap: () => _login(),
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
                            "로그인",
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
                    //아이디 찾기 | 비밀번호 재설정 | 회원가입
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(onTap: () {}, child: Text("아이디 찾기")),
                        SizedBox(width: 7),
                        Text("|"),
                        SizedBox(width: 7),
                        GestureDetector(onTap: () {}, child: Text("비밀번호 재설정")),
                        SizedBox(width: 7),
                        Text("|"),
                        SizedBox(width: 7),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          child: Text("회원가입"),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
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
                          "간편로그인",
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
