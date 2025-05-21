import 'package:flutter/material.dart';
import 'package:sense_voka/widgets/callback_button_widget.dart';
import 'package:sense_voka/widgets/navigation_button_widget.dart';

class SpeechBubbleModal extends StatelessWidget {
  final VoidCallback onManualPressed;
  final VoidCallback onRandomPressed;

  const SpeechBubbleModal({
    super.key,
    required this.onManualPressed,
    required this.onRandomPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 말풍선 본체
          Container(
            width: 180,
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shadows: [BoxShadow(color: Colors.black26, blurRadius: 6)],
              shape: TooltipShapeBorder(arrowArc: 0.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CallbackButtonWidget(
                  text: "단어장 직접 입력",
                  bWidth: 100,
                  bHeight: 10,
                  fontSize: 14,
                  onPressed: onManualPressed,
                ),
                ElevatedButton(
                  onPressed: onRandomPressed,
                  child: Text("단어장 랜덤 생성"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;

  const TooltipShapeBorder({
    this.arrowWidth = 20.0,
    this.arrowHeight = 15.0,
    this.arrowArc = 0.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - arrowHeight),
      Radius.circular(16),
    );
    final path = Path()..addRRect(r);

    // 꼬리 위치: 아래 중앙 (중앙으로 수정하고 싶을 경우)
    final double x = rect.left + rect.width / 2 - 3.5 * (-arrowWidth / 2);
    final double y = rect.bottom - arrowHeight;

    path.moveTo(x, y);
    path.relativeLineTo(arrowWidth / 2, arrowHeight);
    path.relativeLineTo(0, 0);
    path.relativeLineTo(arrowWidth / 2, -arrowHeight);
    path.close();

    return path;
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect);
}
