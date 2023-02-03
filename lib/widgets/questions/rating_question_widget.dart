import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/widgets/questions/rate_widget.dart';
import 'package:kalahok_app/widgets/submit_button_widget.dart';

class RatingQuestionWidget extends StatelessWidget {
  final Survey survey;
  final Question question;
  final ValueChanged<int> onClickedRate;

  const RatingQuestionWidget({
    Key? key,
    required this.survey,
    required this.question,
    required this.onClickedRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            question.question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please rate from below base on the question',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: RateWidget(
              question: question,
              onClickedRate: onClickedRate,
            ),
          ),
          SubmitButtonWidget(
            question: question,
            survey: survey,
          ),
        ],
      ),
    );
  }
}
