import 'package:flutter/material.dart';
import 'package:kalahok_app/helpers/variables.dart';

class QuestionTextWidget extends StatelessWidget {
  final bool isRequired;
  final String question;

  const QuestionTextWidget({
    Key? key,
    required this.isRequired,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isRequired) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '* This question is required',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 16,
              color: AppColor.darkError,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      );
    }

    return Text(
      question,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }
}
