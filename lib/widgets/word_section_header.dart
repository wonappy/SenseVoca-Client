import 'package:flutter/material.dart';

class WordSectionHeader extends StatelessWidget {
  final int sectionNumber;
  final int wordCount;
  final bool isExpended;
  final VoidCallback onToggle;
  final VoidCallback onStartWordStudy;

  const WordSectionHeader({
    super.key,
    required this.sectionNumber,
    required this.wordCount,
    required this.isExpended,
    required this.onToggle,
    required this.onStartWordStudy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xFFFF983D),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(0, 5),
            color: Colors.black.withValues(alpha: 0.3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 10),
                  Text(
                    "$sectionNumber구간",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "$wordCount단어",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                //학습 시작 버튼
                GestureDetector(
                  onTap: onStartWordStudy,
                  child: Container(
                    width: 90,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "학습 시작",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onToggle,
                  //highlightColor: Colors.transparent, //버튼 눌림 효과 제거
                  icon: Transform.translate(
                    offset: Offset(0, -2), //아이콘 위치 조정
                    child: Icon(
                      isExpended
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
