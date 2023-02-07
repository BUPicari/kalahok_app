import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/helpers/variables.dart';

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
    final color = generateColor(
      question: questions[index],
      isSelected: isSelected,
    );

    return GestureDetector(
      onTap: () => onClickedNumber(index),
      child: CircleAvatar(
        backgroundColor: color,
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: AppColor.subSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Color generateColor({
    required Question question,
    required bool isSelected,
  }) {
    var color = AppColor.subPrimary;

    if (question.response != null || question.addedOthers != null) {
      color = AppColor.darkSuccess;
    }

    if (isSelected) {
      color = AppColor.warning;
    }

    return color;
  }
}
