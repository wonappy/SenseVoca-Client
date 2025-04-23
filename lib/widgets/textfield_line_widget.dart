import 'package:flutter/material.dart';

class TextFieldLineWidget extends StatelessWidget {
  final String hint;
  final double fieldWidth;
  final double fieldHeight;
  final double lineThickness;
  final bool obscureText;
  final TextEditingController? controller;

  const TextFieldLineWidget({
    super.key,
    required this.hint,
    required this.fieldWidth,
    required this.fieldHeight,
    required this.lineThickness,
    required this.obscureText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: fieldWidth,
          height: fieldHeight,
          child: TextField(
            obscureText: obscureText,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              hintText: hint,
              hintStyle: TextStyle(
                color: Color(0xFFE1E1E1),
                fontWeight: FontWeight.w600,
              ),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            controller: controller,
          ),
        ),
        Container(
          height: lineThickness,
          width: fieldWidth,
          decoration: BoxDecoration(
            color: Color(0xFFFF983D),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ],
    );
  }
}
