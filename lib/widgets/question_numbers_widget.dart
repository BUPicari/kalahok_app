import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/question_model.dart';

class QuestionNumbersWidget extends StatelessWidget {
  final List<Question> questions;
  final Question question;
  final ValueChanged<int> onClickedNumber;

  const QuestionNumbersWidget({
    Key? key,
    required this.questions,
    required this.question,
    required this.onClickedNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double padding = 16;

    return SizedBox(
      height: 50,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: padding),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => Container(width: padding),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final isSelected = question == questions[index];
          return buildNumber(index: index, isSelected: isSelected);
        },
      ),
    );
  }

  Widget buildNumber({required int index, required bool isSelected}) {
    final color = isSelected ? Colors.orange : Colors.white;

    return GestureDetector(
      onTap: () => onClickedNumber(index),
      child: CircleAvatar(
        backgroundColor: color,
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
