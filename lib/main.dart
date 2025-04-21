import 'package:flutter/material.dart';
import 'package:sense_voka/screens/create_mywordbook_screen.dart';
import 'package:sense_voka/screens/main_screen.dart';
import 'package:sense_voka/screens/main_wordbook_screen.dart';
import 'package:sense_voka/screens/mywordbook_screen.dart';
import 'package:sense_voka/screens/sign_in_screen.dart';
import 'package:sense_voka/screens/sign_up_screen.dart';
import 'package:sense_voka/screens/word_study_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignInScreen());
  }
}
