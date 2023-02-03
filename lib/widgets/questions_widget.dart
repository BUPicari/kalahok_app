import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/choice_model.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/widgets/questions/open_ended_question_widget.dart';
import 'package:kalahok_app/widgets/questions/rating_question_widget.dart';
import 'package:kalahok_app/widgets/questions/unkown_question_widget.dart';
import 'package:kalahok_app/widgets/questions/with_choices_question_widget.dart';

class QuestionsWidget extends StatelessWidget {
  final Survey survey;
  final PageController controller;
  final ValueChanged<int> onChangedPage;
  final ValueChanged<Choice> onClickedChoice;
  final ValueChanged<int> onClickedRate;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onAddOthers;

  const QuestionsWidget({
    Key? key,
    required this.survey,
    required this.controller,
    required this.onChangedPage,
    required this.onClickedChoice,
    required this.onClickedRate,
    required this.onChanged,
    required this.onAddOthers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: onChangedPage,
      controller: controller,
      itemCount: survey.questionnaires.length,
      itemBuilder: (context, index) {
        final question = survey.questionnaires[index];

        return buildQuestion(question: question);
      },
    );
  }

  Widget buildQuestion({required Question question}) {
    switch (question.type) {
      case "multipleChoice":
        var subText = 'Please choose one choice from below';
        if (question.config.multipleAnswer) {
          subText = 'Please select choices from below';
        }
        return WithChoicesQuestionWidget(
          survey: survey,
          question: question,
          subText: subText,
          onClickedChoice: onClickedChoice,
          onAddOthers: onAddOthers,
        );
      case "openEnded":
        return OpenEndedQuestionWidget(
          survey: survey,
          question: question,
          onChanged: onChanged,
        );
      case "trueOrFalse":
        var subText = 'Please choose True or False from below';
        if (question.config.useYesOrNo) {
          subText = 'Please choose Yes or No from below';
        }
        return WithChoicesQuestionWidget(
          survey: survey,
          question: question,
          subText: subText,
          onClickedChoice: onClickedChoice,
          onAddOthers: onAddOthers,
        );
      case "rating":
        return RatingQuestionWidget(
          survey: survey,
          question: question,
          onClickedRate: onClickedRate,
        );
      default:
        return const UnknownQuestionWidget();
    }
  }
}
