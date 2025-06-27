import 'package:flutter/material.dart';
import 'package:sense_voka/models/api_response.dart';
import 'package:sense_voka/models/interest_info_model.dart';
import 'package:sense_voka/screens/sign_in_screen.dart';
import 'package:sense_voka/services/inital_data_service.dart';
import 'package:sense_voka/services/users_service.dart';

import '../styles/error_snack_bar_style.dart';
import '../widgets/show_dialog_widget.dart';
import '../widgets/textfield_line_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController(); //이메일
  final _pwController = TextEditingController(); //비밀번호
  final _nameController = TextEditingController(); //닉네임
  String email = "", pw = "", name = "";

  List<InterestInfoModel> _interestCategories = [];
  int? _selectedInterest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //관심사 목록 가져오기
    _getInterestList();
  }

  //이메일 중복 확인 api 호출
  void _emailCheckButtonTap() async {
    final String email = _emailController.text;

    if (email == "") {
      await showDialogWidget(
        context: context,
        title: "이메일 미기입",
        msg: "이메일을 입력해주세요.",
      );
      return;
    }

    //api 호출
    final ApiResponseModel result = await UsersService.getCheckEmailDuplicate(
      email,
    );

    if (mounted) {
      if (result.isSuccess) {
        // 사용 가능한 이메일
        //await 이후 context를 사용하고자 할 때에는 context가 dispose될 때를 대비해 경고가 출력될 수 있음.
        await showDialogWidget(
          context: context,
          title: result.title,
          msg: result.msg,
        );
      } else {
        //경고창 출력됨.
        //api 호출 에러
        if (result.title == "오류 발생") {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(errorSnackBarStyle(context: context, result: result));
        }
        //결과 실패
        else {
          await showDialogWidget(
            context: context,
            title: result.title,
            msg: result.msg,
          );
        }
      }
    }
  }

  //회원가입 api 호출
  void _signUpButtonTap() async {
    final String email = _emailController.text;
    final String pw = _pwController.text;
    final String name = _nameController.text;
    final int? interestId = _selectedInterest;

    if (email == "" || pw == "" || name == "" || interestId == null) {
      await showDialogWidget(
        context: context,
        title: "필수 요소 입력",
        msg: "모든 정보를 입력해주세요.",
      );
      return;
    }

    //회원가입 api 호출
    final ApiResponseModel result = await UsersService.postSignUp(
      email,
      pw,
      name,
      interestId,
    );

    if (mounted) {
      //await 이후 context를 사용하고자 할 때에는 context가 dispose될 때를 대비해 경고가 출력될 수 있음.
      if (result.isSuccess) {
        // 회원가입 성공
        await showDialogWidget(
          context: context,
          title: result.title,
          msg: result.msg,
        );
        if (mounted) {
          Navigator.pop(context);
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

    _emailController.text = "";
    _nameController.text = "";
    _pwController.text = "";
    _selectedInterest = null;
  }

  //관심사 리스트 api 호출
  void _getInterestList() async {
    //api 호출
    final ApiResponseModel result = await InitialDataService.getInterestList();

    if (mounted) {
      if (result.isSuccess) {
        //관심사 리스트 대입
        setState(() {
          _interestCategories = result.data;
        });
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

    _emailController.text = "";
    _nameController.text = "";
    _pwController.text = "";
    _selectedInterest = null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _nameController.dispose();
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
                        TextFieldLineWidget(
                          hint: "이메일을 입력해주세요.",
                          fieldHeight: 35,
                          fieldWidth: 190,
                          lineThickness: 6,
                          obscureText: false,
                          controller: _emailController,
                        ),
                        //중복 확인 버튼
                        ElevatedButton(
                          onPressed: _emailCheckButtonTap,
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
                    TextFieldLineWidget(
                      hint: "비밀번호를 입력해주세요.",
                      fieldHeight: 35,
                      fieldWidth: 290,
                      lineThickness: 6,
                      obscureText: true,
                      controller: _pwController,
                    ),
                    SizedBox(height: 10),
                    //이름 입력
                    TextFieldLineWidget(
                      hint: "이름을 입력해주세요.",
                      fieldHeight: 35,
                      fieldWidth: 290,
                      lineThickness: 6,
                      obscureText: false,
                      controller: _nameController,
                    ),
                    SizedBox(height: 10),
                    //관심사 선택
                    SizedBox(
                      width: 290,
                      height: 35,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
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
                                    value: e.interestId,
                                    child: Text(e.type),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedInterest = value;
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
                    //회원가입 버튼
                    GestureDetector(
                      onTap: _signUpButtonTap,
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
                    SizedBox(height: 5),
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
