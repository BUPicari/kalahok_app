import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/choice_model.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:kalahok_app/helpers/variables.dart';

class ChoicesWidget extends StatelessWidget {
  final Question question;
  // final ValueChanged<Choice> onClickedChoice;

  const ChoicesWidget({
    Key? key,
    required this.question,
    // required this.onClickedChoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: Utils.heightBetween(
        question.choices.map((choice) => _buildChoice(context, choice)).toList(),
        height: 8,
      ),
    );
  }

  Widget _buildChoice(BuildContext context, Choice choice) {
    // final color = getColorForChoice(choice, question);

    return GestureDetector(
      // onTap: () => onClickedChoice(choice),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.subPrimary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildAnswer(choice),
            // buildSolution(question.selectedOption, choice),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswer(Choice choice) {
    return SizedBox(
      height: 50,
      child: Row(children: [
        // Text(
        //   choice.code,
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        // ),
        const SizedBox(width: 12),
        Text(
          choice.name,
          style: const TextStyle(fontSize: 20),
        )
      ]),
    );
  }

  // Widget buildSolution(Choice? solution, Choice answer) {
  //   if (solution == answer) {
  //     return Text(
  //       question.solution,
  //       style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

  // Color getColorForChoice(Choice choice, Question question) {
  //   final isSelected = choice == question.selectedOption;
  //
  //   if (!isSelected) {
  //     return Colors.grey.shade200;
  //   } else {
  //     return choice.isCorrect ? Colors.green : Colors.red;
  //   }
  // }
}
