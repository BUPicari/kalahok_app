import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/answer_model.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/widgets/previous_next_button_widget.dart';
import 'package:kalahok_app/widgets/questions/choice_widget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/widgets/question_subtext_widget.dart';
import 'package:kalahok_app/widgets/review_button_widget.dart';

class WithChoicesQuestionWidget extends StatelessWidget {
  final int index;
  final Surveys survey;
  final Questions question;
  final String subText;
  final ValueChanged<Answer> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const WithChoicesQuestionWidget({
    Key? key,
    required this.index,
    required this.survey,
    required this.question,
    required this.subText,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          QuestionTextWidget(
            isRequired: question.config.isRequired,
            question: question.question,
          ),
          QuestionSubtextWidget(subText: subText),
          const SizedBox(height: 30),
          Expanded(
            child: ChoiceWidget(
              question: question,
              onSetResponse: onSetResponse,
            ),
          ),
          PreviousNextButtonWidget(
            index: index,
            question: question,
            survey: survey,
            onPressedPrev: onPressedPrev,
            onPressedNext: onPressedNext,
          ),
          ReviewButtonWidget(
            question: question,
            survey: survey,
          ),
        ],
      ),
    );
  }
}
