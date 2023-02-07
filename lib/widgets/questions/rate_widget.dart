import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/helpers/variables.dart';

class RateWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<int> onClickedRate;

  const RateWidget({
    Key? key,
    required this.question,
    required this.onClickedRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stars =
        List<Widget>.generate(int.parse(question.rates[0].max), (index) {
      final containerColor = getColorForRate(index, question);
      return GestureDetector(
        onTap: () => onClickedRate(index),
        child: _buildRatingStar(containerColor),
      );
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: stars,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: question.labels.map((label) {
            return Text(
              label.name,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingStar(Color containerColor) {
    return Icon(
      Icons.star_border_outlined,
      color: containerColor,
      size: 30,
    );
  }

  Color getColorForRate(int rate, Question question) {
    var selectedRate = question.selectedRate?.toInt() ?? -1;
    final isSelected = rate <= selectedRate;

    if (!isSelected) {
      return AppColor.secondary;
    } else {
      return AppColor.warning;
    }
  }
}
