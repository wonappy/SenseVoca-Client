import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sense_voka/core/global_variables.dart';
import 'package:sense_voka/screens/main_screen.dart';
import 'package:sense_voka/screens/sign_up_screen.dart';
import 'package:sense_voka/services/inital_data_service.dart';
import 'package:sense_voka/services/users_service.dart';

import '../enums/app_enums.dart';
import '../models/user_model.dart';
import '../styles/error_snack_bar_style.dart';
import '../widgets/show_dialog_widget.dart';
import '../widgets/textfield_line_widget.dart';
import '../models/user_status_model.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  static final storage = FlutterSecureStorage();

  final _emailController = TextEditingController(); //아이디
  final _pwController = TextEditingController(); //비밀번호
  String email = "", pw = "";

  @override
  void initState() {
    super.initState();
    _autoSingIn();
  }


  Future<UserStatusModel> _getUserStatus() async {
    var statusResult = await UsersService.getUserStatus();
    if (statusResult.isSuccess && statusResult.data != null) {
      try {
        if (statusResult.data is UserStatusModel) {
          return statusResult.data as UserStatusModel;
        } else if (statusResult.data is Map<String, dynamic>) {
          return UserStatusModel.fromJson(
            statusResult.data as Map<String, dynamic>,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('UserStatusModel 변환 실패: $e');
        }
      }
    }

    return UserStatusModel(todayCount: 0, streakDays: 0);
  }
  
  //자동 로그인 -> 함수로 빼서 전체적인 흐름이 잘 보이게 변경 필요
  void _autoSingIn() async {
    //Token값들이 존재한다면,
    final refreshToken = await storage.read(key: "RefreshToken");

    if (refreshToken != null) {
      //refreshToken 유효성 확인 api 호출
      var result = await UsersService.postJWTToken(refreshToken: refreshToken);

      //승인 -> accessToken 재발급 -> 자동 로그인 진행
      //거부 -> 다시 로그인 (storage 모두 삭제!)
      if (mounted) {
        if (result.isSuccess) {
          //승인
          final accessToken = await storage.read(key: "AccessToken");
          final userJson = await storage.read(key: "UserInfo");

          if (accessToken != null && userJson != null) {
            //저장되어있던 사용자 정보 가져오기
            final userMap = jsonDecode(userJson);
            final user = UserModel(
              userId: userMap['userId'],
              email: userMap['email'],
              name: userMap['name'],
              accessToken: accessToken,
            );

            var loadCountry = await storage.read(key: "Country");
            if (loadCountry != null) {
              voiceCountry = Country.values.byName(loadCountry);
            }
            if (kDebugMode) {
              print("설정 음성 가져오기 : $voiceCountry");
            }

            //자동 로그인
            if (mounted) {
              //검색 단어 목록 초기화
              _getWordInfos();
              //로그인 화면 대체 생성
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(user: user),
                  fullscreenDialog: true,
                ),
              );
            }
          }
        } else {
          //거부
          //기존 저장소 내용 모두 삭제
          storage.deleteAll();
          //로그인 창에서 start
          return;
        }
      }
    }
  }

  //로그인 API
  void _loginButtonTap() async {
    email = _emailController.text;
    pw = _pwController.text;

    if (email == "") {
      await showDialogWidget(
        context: context,
        title: "필수 요소 입력",
        msg: "이메일을 입력해주세요.",
      );
      return;
    } else if (pw == "") {
      await showDialogWidget(
        context: context,
        title: "필수 요소 입력",
        msg: "비밀번호를 입력해주세요.",
      );
      return;
    }

    //api 호출
    var (result, user) = await UsersService.postSignIn(email: email, pw: pw);

    var loadCountry = await storage.read(key: "Country");
    if (loadCountry != null) {
      voiceCountry = Country.values.byName(loadCountry);
    }
    if (kDebugMode) {
      print("설정 음성 가져오기 : $voiceCountry");
    }

    if (mounted) {
      //await 이후 context를 사용하고자 할 때에는 context가 dispose될 때를 대비해 경고가 출력될 수 있음.
      if (result.isSuccess && user != null) {
        if (kDebugMode) {
          Map<String, String> allValues = await storage.readAll();
          print(
            "로그인한 사용자 정보 : ${user.email}, ${user.name}, ${user.userId}, ${user.accessToken}, ",
          );
          print("토큰 정보 : $allValues");
        }

        //단어 정보 리스트 불러오기
        _getWordInfos();

        if (mounted) {
          //로그인 화면 대체 생성
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(


              builder: (context) => MainScreen(user: user),

              fullscreenDialog: true,
            ),
          );
        }
      } else {
        if (result.title == "오류 발생") {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(errorSnackBarStyle(context: context, result: result));
        } else {
          await showDialogWidget(
            context: context,
            title: result.title,
            msg: result.msg,
          );
        }
      }
    }
  }

  //단어 검색 리스트 호출 api
  Future<void> _getWordInfos() async {
    //api 호출
    var result = await InitialDataService.getWordInfos();

    if (mounted) {
      if (result.isSuccess) {
        //global 변수 초기화
        wordSearchList = result.data;
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
                      onTap: () => _loginButtonTap(),
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
                            email = "";
                            pw = "";
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
