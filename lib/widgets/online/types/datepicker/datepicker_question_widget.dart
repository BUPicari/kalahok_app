import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:kalahok_app/data/models/online/answer_model.dart';
import 'package:kalahok_app/data/models/online/questions_model.dart';
import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/widgets/online/previous_next_button_widget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';

/// CHECKED
class DatePickerQuestionWidget extends StatefulWidget {
  final int index;
  final Surveys survey;
  final Questions question;
  final ValueChanged<Answer> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const DatePickerQuestionWidget({
    Key? key,
    required this.index,
    required this.survey,
    required this.question,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
    required this.addresses,
  }) : super(key: key);

  @override
  State<DatePickerQuestionWidget> createState() => _DatePickerQuestionWidgetState();
}

class _DatePickerQuestionWidgetState extends State<DatePickerQuestionWidget> {
  late DateTime initialDate;
  List<String> selected = [];
  List<String> fieldTexts = [];

  @override
  void initState() {
    super.initState();

    initialDate = DateTime(1998, 01);
    selected = widget.question.answer?.answers ?? [];
    fieldTexts = List.generate(1, (i) => widget.question.question);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          QuestionTextWidget(
            isRequired: widget.question.config.isRequired,
            question: widget.question.question,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 35),
              child: SfDateRangePicker(
                onSelectionChanged: _setDateSelected,
                view: DateRangePickerView.month,
                initialDisplayDate: _getDate(display: true),
                initialSelectedDate: _getDate(),
              ),
            ),
          ),
          PreviousNextButtonWidget(
            index: widget.index,
            question: widget.question,
            survey: widget.survey,
            onPressedPrev: widget.onPressedPrev,
            onPressedNext: widget.onPressedNext,
            addresses: widget.addresses,
          ),
        ],
      ),
    );
  }

  DateTime? _getDate({ bool display = false }) {
    if (selected.isNotEmpty) {
      List<String> temp = selected[0].split('-');
      return DateTime(
        int.parse(temp[0]),
        int.parse(temp[1]),
        int.parse(temp[2]),
      );
    }

    return display ? initialDate : null;
  }

  void _setDateSelected(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      String date = DateFormat('yyyy-MM-dd').format(args.value);
      selected.isEmpty ? selected.add(date) : selected[0] = date;
    });
    _setResponse();
  }

  void _setResponse() {
    widget.onSetResponse(Answer(
      surveyQuestion: widget.question.question,
      questionFieldTexts: fieldTexts,
      answers: selected,
      otherAnswer: '',
    ));
  }
}
