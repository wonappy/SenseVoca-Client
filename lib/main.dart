import 'package:flutter/material.dart';
import 'package:sense_voka/screens/main_screen.dart';
import 'package:sense_voka/screens/sign_in_screen.dart';

import 'models/user_model.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel user = UserModel(
      userId: 1,
      email: "123",
      pw: "123",
      name: "권원경",
      accessToken: "--",
    );
    return MaterialApp(home: MainScreen(user: user));
  }
}
