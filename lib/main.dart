import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sense_voka/providers/my_wordbook_list_provider.dart';
import 'package:sense_voka/screens/sign_in_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyWordbookListProvider(),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SignInScreen());
  }
}
