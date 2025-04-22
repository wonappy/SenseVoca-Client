import 'package:flutter/material.dart';
import 'package:sense_voka/styles/example_sentence_style.dart';
import 'package:sense_voka/widgets/orange_button.dart';

class EndCardWidget extends StatelessWidget {
  const EndCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFFF983D),
          borderRadius: BorderRadius.circular(45),
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
            //버튼
            Column(
              children: [
                OrangeButton(text: "발 음 교 정", bWidth: 290, bHeight: 60),
                SizedBox(height: 10),
                OrangeButton(text: "한 번 더 복습", bWidth: 290, bHeight: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
