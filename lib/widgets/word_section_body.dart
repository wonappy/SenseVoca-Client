import 'package:flutter/material.dart';

import '../models/word_preview_model.dart';

class WordSectionBody extends StatelessWidget {
  final List<WordPreviewModel> wordList;

  const WordSectionBody({super.key, required this.wordList});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, //너비 고정
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
      child: Column(
        children:
            wordList.map((entry) {
              final index = wordList.indexOf(entry);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            entry.word,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(entry.meaning.replaceAll('; ', '\n')),
                        ),
                      ],
                    ),
                    Divider(color: Colors.black12, thickness: 1.0, height: 8.0),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
