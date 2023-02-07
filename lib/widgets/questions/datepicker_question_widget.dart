import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/widgets/PreviousNextButtonWidget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/widgets/review_button_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerQuestionWidget extends StatelessWidget {
  final int index;
  final Survey survey;
  final Question question;
  final ValueChanged<DateRangePickerSelectionChangedArgs> onDateSelected;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const DatePickerQuestionWidget({
    Key? key,
    required this.index,
    required this.survey,
    required this.question,
    required this.onDateSelected,
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
          const SizedBox(height: 15),
          QuestionTextWidget(
            isRequired: question.config.isRequired,
            question: question.question,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SfDateRangePicker(
              onSelectionChanged: onDateSelected,
              view: DateRangePickerView.month,
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
