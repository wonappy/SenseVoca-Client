import 'package:flutter/material.dart';
import 'package:sense_voka/widgets/textfield_line_widget.dart';

class NewWordCardWidget extends StatelessWidget {
  final TextEditingController wordController;
  final TextEditingController meaningController;

  const NewWordCardWidget({
    super.key,
    required this.wordController,
    required this.meaningController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 260,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFieldLineWidget(
            hint: " 단어를 입력하세요.",
            fieldWidth: 240,
            fieldHeight: 40,
            lineThickness: 5,
            obscureText: false,
            controller: wordController,
          ),
          SizedBox(height: 45),
          TextFieldLineWidget(
            hint: " 뜻을 입력하세요.",
            fieldWidth: 240,
            fieldHeight: 40,
            lineThickness: 5,
            obscureText: false,
            controller: meaningController,
          ),
        ],
      ),
    );
  }
}
