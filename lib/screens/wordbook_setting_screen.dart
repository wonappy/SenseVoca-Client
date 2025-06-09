import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sense_voka/screens/create_mywordcard_screen.dart';
import 'package:sense_voka/screens/create_random_wordbook_screen.dart';
import 'package:sense_voka/services/mywordbooks_service.dart';
import 'package:sense_voka/widgets/callback_button_widget.dart';

import '../enums/app_enums.dart';
import '../models/word_book_info_model.dart';
import '../models/word_preview_model.dart';
import '../styles/error_snack_bar_style.dart';
import '../widgets/show_dialog_widget.dart';
import '../widgets/word_set_button_widget.dart';

class WordBookSettingScreen extends StatefulWidget {
  const WordBookSettingScreen({super.key});

  @override
  State<WordBookSettingScreen> createState() => _WordBookSettingScreenState();
}

class _WordBookSettingScreenState extends State<WordBookSettingScreen> {
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
        centerTitle: true,
        backgroundColor: Color(0xFFFF983D),
        foregroundColor: Colors.white,
        //app bar 그림자 생기게 하기
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        //
        title: const Text(
          "환경설정",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("환경설정"),
        ),
      ),
    );
  }
}
