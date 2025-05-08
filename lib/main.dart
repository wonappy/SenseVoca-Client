import 'package:flutter/material.dart';
import 'package:sense_voka/models/user_model.dart';
import 'package:sense_voka/screens/main_screen.dart';
import 'package:sense_voka/screens/sign_in_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // UserModel user = UserModel(
    //   userId: 1,
    //   email: "aaa@gmail.com",
    //   name: "권원경",
    //   accessToken: "1",
    // );
    return MaterialApp(home: SignInScreen());
  }
}
