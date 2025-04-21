import 'package:flutter/material.dart';

ButtonStyle whiteOrangeButtonStyle() {
  return ButtonStyle(
    padding: WidgetStateProperty.all(EdgeInsets.zero),
    foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed) ||
          states.contains(WidgetState.hovered)) {
        return Colors.white;
      }
      return Colors.black;
    }),
    backgroundColor:
        WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
          WidgetState.focused | WidgetState.hovered: Color(0xFFFF983D),
          WidgetState.any: Colors.white,
        }),
    overlayColor:
        WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
          WidgetState.focused |
              WidgetState.pressed |
              WidgetState.hovered: Color(0xFFFF983D),
          WidgetState.any: Colors.white,
        }),
    minimumSize: WidgetStateProperty.all(Size(40, 110)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    elevation: WidgetStateProperty.all(6),
  );
}
