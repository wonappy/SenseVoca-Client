import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sense_voka/models/word_preview_model.dart';
import 'package:sense_voka/widgets/show_dialog_widget.dart';

import '../widgets/textfield_line_widget.dart';

class CreateMywordbookScreen extends StatefulWidget {
  final List<WordPreviewModel> wordsInfo;

  const CreateMywordbookScreen({super.key, required this.wordsInfo});

  @override
  State<CreateMywordbookScreen> createState() => _CreateMywordbookScreenState();
}

class _CreateMywordbookScreenState extends State<CreateMywordbookScreen> {
  final titleController = TextEditingController(); //단어장 명

  @override
  initState() {
    super.initState();
    if (kDebugMode) {
      print("단어 내용 : ${widget.wordsInfo}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 40),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () async {
                //단어장 생성 api 활용
                String title = titleController.text;
                if (title == "") {
                  showDialogWidget(
                    context: context,
                    title: "경고",
                    msg: "단어장 명은 필수 입력 요소입니다.",
                  );
                  return;
                }

                //나만의 단어장 화면으로 돌아감
                Navigator.pop(context); // 단어 입력 부분으로
                Navigator.pop(context, {
                  "title": title,
                  "words": widget.wordsInfo,
                }); // 단어장 리스트 부분으로... -> true는 api 재호출 시점을 알려줌
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
                "생성",
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                TextFieldLineWidget(
                  hint: "단어장 명을 입력해주세요.",
                  fieldHeight: 35,
                  fieldWidth: 350,
                  lineThickness: 6,
                  obscureText: false,
                  controller: titleController,
                ),
                SizedBox(height: 15),
                Divider(color: Colors.black12, thickness: 1.0, height: 8.0),
                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "총 ${widget.wordsInfo.length} 단어",
                      style: TextStyle(color: Colors.black26),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "단어",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "뜻",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                for (WordPreviewModel word in widget.wordsInfo)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: Text(" ${word.word}")), //단어
                          Expanded(
                            flex: 3,
                            child: Text(" ${word.meaning}"),
                          ), //뜻
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                backgroundColor: Colors.white,
                                minimumSize: Size(40, 25),
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "수정",
                                style: TextStyle(
                                  color: Color(0xFFFF983D),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.black12,
                        thickness: 1.0,
                        height: 8.0,
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
