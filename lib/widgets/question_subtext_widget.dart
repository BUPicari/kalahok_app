import 'package:flutter/material.dart';

class QuestionSubtextWidget extends StatelessWidget {
  final String subText;

  const QuestionSubtextWidget({
    Key? key,
    required this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (subText != '') {
      return Column(children: [
        const SizedBox(height: 10),
        Text(
          subText,
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
        ),
      ]);
    }

    return Column();
  }
}
