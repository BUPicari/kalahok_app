import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/question_model.dart';

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stars,
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
      return Colors.blueGrey;
    } else {
      return Colors.orange;
    }
  }
}
