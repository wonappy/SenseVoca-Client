import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sense_voka/screens/create_mywordcard_screen.dart';
import 'package:sense_voka/screens/sign_in_screen.dart';
import 'package:sense_voka/widgets/show_dialog_widget.dart';

import '../models/word_book_info_model.dart';
import '../widgets/show_confirm_dialog_widget.dart';
import '../widgets/textfield_line_widget.dart';

class SettingAccountScreen extends StatefulWidget {
  SettingAccountScreen({super.key});

  static final storage = FlutterSecureStorage();

  @override
  State<SettingAccountScreen> createState() => _SettingAccountScreenState();
}

class _SettingAccountScreenState extends State<SettingAccountScreen> {
  final titleController = TextEditingController();

  //단어장 명
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width; //화면 가로 길이

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 40,
            color: Color(0xFFFF983D),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        //app bar 그림자 생기게 하기
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        title: SizedBox(
          // 글자 왼쪽 정렬을 위한 sizedBox
          width: double.infinity,
          child: const Text(
            "계정 관리",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF983D),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text(
                  "계정 관리",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            InkWell(
              splashColor: Color(0xFFFF983D),
              highlightColor: Color(0xFFFFE4CA),
              onTap: () async {
                final navigator = Navigator.of(
                  context,
                ); //context를 비동기 호출 전 미리 저장해 둠.

                //로그아웃 하시겠습니까? 창 출력
                final result = await showConfirmDialogWidget(
                  context: context,
                  title: "로그아웃",
                  msg: "로그아웃 하시겠습니까?",
                );

                if (result != null && result == true) {
                  //기존 저장소 내용 모두 삭제
                  await SettingAccountScreen.storage.deleteAll();
                  //provider로 정적으로 저장하던 내용 또한 삭제

                  //로그인 화면으로 이동
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => SignInScreen()),
                    (route) => false,
                  );
                }
              },
              child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                title: Text("로그아웃", style: TextStyle(fontSize: 18)),
              ),
            ),
            InkWell(
              splashColor: Color(0xFFFF983D),
              highlightColor: Color(0xFFFFE4CA),
              onTap: () {
                // 이벤트 처리
              },
              child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                title: Text("회원 탈퇴", style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 20),
            Container(color: Color(0xFFFFE4CA), height: 10),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
