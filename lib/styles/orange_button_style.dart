import 'package:flutter/material.dart';

ButtonStyle orangeButtonStyle({required double width, required double heigth}) {
  return ButtonStyle(
    padding: WidgetStateProperty.all(EdgeInsets.zero),
    foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      return Colors.white;
    }),
    backgroundColor:
        WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
          WidgetState.focused | WidgetState.hovered: Color(0xFFF59038),
          WidgetState.any: Color(0xFFFF983D),
        }),
    overlayColor:
        WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
          WidgetState.focused |
              WidgetState.pressed |
              WidgetState.hovered: Color(0xFFF59038),
          WidgetState.any: Color(0xFFFF983D),
        }),
    minimumSize: WidgetStateProperty.all(Size(width, heigth)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    elevation: WidgetStateProperty.all(6),
  );
}
