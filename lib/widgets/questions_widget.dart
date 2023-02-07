import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/choice_model.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/widgets/questions/datepicker_question_widget.dart';
import 'package:kalahok_app/widgets/questions/dropdown_question_widget.dart';
import 'package:kalahok_app/widgets/questions/open_ended_question_widget.dart';
import 'package:kalahok_app/widgets/questions/rating_question_widget.dart';
import 'package:kalahok_app/widgets/questions/unkown_question_widget.dart';
import 'package:kalahok_app/widgets/questions/with_choices_question_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class QuestionsWidget extends StatelessWidget {
  final Survey survey;
  final PageController pageController;
  // final TextEditingController textController;
  final ValueChanged<int> onChangedPage;
  final ValueChanged<Choice> onClickedChoice;
  final ValueChanged<int> onClickedRate;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onAddOthers;
  final ValueChanged<DateRangePickerSelectionChangedArgs> onDateSelected;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const QuestionsWidget({
    Key? key,
    required this.survey,
    required this.pageController,
    // required this.textController,
    required this.onChangedPage,
    required this.onClickedChoice,
    required this.onClickedRate,
    required this.onChanged,
    required this.onAddOthers,
    required this.onDateSelected,
    required this.onPressedPrev,
    required this.onPressedNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: onChangedPage,
      controller: pageController,
      itemCount: survey.questionnaires.length,
      itemBuilder: (context, index) {
        final question = survey.questionnaires[index];

        return buildQuestion(index: index, question: question);
      },
    );
  }

  Widget buildQuestion({
    required int index,
    required Question question,
  }) {
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
          onClickedChoice: onClickedChoice,
          onAddOthers: onAddOthers,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case "openEnded":
        return OpenEndedQuestionWidget(
          index: index,
          // textController: textController,
          survey: survey,
          question: question,
          onChanged: onChanged,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case "trueOrFalse":
        return WithChoicesQuestionWidget(
          index: index,
          survey: survey,
          question: question,
          subText: '',
          onClickedChoice: onClickedChoice,
          onAddOthers: onAddOthers,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case "rating":
        return RatingQuestionWidget(
          index: index,
          survey: survey,
          question: question,
          onClickedRate: onClickedRate,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case "datepicker":
        return DatePickerQuestionWidget(
          index: index,
          survey: survey,
          question: question,
          onDateSelected: onDateSelected,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case "dropdown":
        return DropdownQuestionWidget(
          index: index,
          survey: survey,
          question: question,
          onChanged: onChanged,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      default:
        return const UnknownQuestionWidget();
    }
  }
}
