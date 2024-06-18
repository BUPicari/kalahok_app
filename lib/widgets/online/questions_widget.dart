import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/online/answer_model.dart';
import 'package:kalahok_app/data/models/online/questions_model.dart';
import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/widgets/online/types/datepicker/datepicker_question_widget.dart';
import 'package:kalahok_app/widgets/online/types/dropdown/dropdown_question_widget.dart';
import 'package:kalahok_app/widgets/online/types/openended/open_ended_question_widget.dart';
import 'package:kalahok_app/widgets/online/types/rating/rating_question_widget.dart';
import 'package:kalahok_app/widgets/unkown_question_type_widget.dart';
import 'package:kalahok_app/widgets/online/types/choice/with_choices_question_widget.dart';

class QuestionsWidget extends StatelessWidget {
  final Surveys survey;
  final PageController pageController;
  final ValueChanged<int> onChangedPage;
  final ValueChanged<Answer> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const QuestionsWidget({
    Key? key,
    required this.survey,
    required this.pageController,
    required this.onChangedPage,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
    required this.addresses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: onChangedPage,
      controller: pageController,
      itemCount: survey.questionnaires?.length,
      itemBuilder: (context, index) {
        final question = survey.questionnaires?[index];
        return _buildQuestion(index: index, question: question!);
      },
    );
  }

  Widget _buildQuestion({ required int index, required Questions question }) {
    switch (question.type) {
      case "multipleChoice":
        String subText = question.config.multipleAnswer
          ? 'Please select all that apply'
          : '';
        return WithChoicesQuestionWidget(
          index: index,
          survey: survey,
          question: question,
          subText: subText,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      case "openEnded":
        return OpenEndedQuestionWidget(
          index: index,
          survey: survey,
          question: question,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      case "trueOrFalse":
        return WithChoicesQuestionWidget(
          index: index,
          survey: survey,
          question: question,
          subText: '',
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      case "rating":
        return RatingQuestionWidget(
          index: index,
          survey: survey,
          question: question,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      case "datepicker":
        return DatePickerQuestionWidget(
          index: index,
          survey: survey,
          question: question,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      case "dropdown":
        return DropdownQuestionWidget(
          index: index,
          survey: survey,
          question: question,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      default:
        return const UnknownQuestionTypeWidget();
    }
  }
}
