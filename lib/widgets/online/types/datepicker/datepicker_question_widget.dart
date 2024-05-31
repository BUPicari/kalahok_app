import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:kalahok_app/helpers/variables.dart';
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
  late DateRangePickerController _controller;

  @override
  void initState() {
    super.initState();

    initialDate = DateTime(1998, 01);
    selected = widget.question.answer?.answers ?? [];
    fieldTexts = List.generate(1, (i) => widget.question.question);
    _controller = DateRangePickerController();
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
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              controller: _controller,
              cellBuilder: _cellBuilder,
              onSelectionChanged: _setDateSelected,
              initialDisplayDate: _getDate(display: true),
              initialSelectedDate: _getDate(),
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

  Widget _cellBuilder(
    BuildContext context,
    DateRangePickerCellDetails cellDetails,
  ) {
    var boxDecoration = BoxDecoration(
      color: AppColor.bgNeutral,
      shape: BoxShape.circle,
    );
    var margin = const EdgeInsets.all(2);
    var mainAxisSize = MainAxisSize.max;
    var mainAxisAlignment = MainAxisAlignment.spaceAround;

    if (_controller.view == DateRangePickerView.month) {
      return Container(
        margin: margin,
        decoration: boxDecoration,
        child: Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Text(DateFormat('dd').format(cellDetails.date)),
          ],
        ),
      );
    } else if (_controller.view == DateRangePickerView.year) {
      return Container(
        margin: margin,
        decoration: boxDecoration,
        child: Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Text(DateFormat('MMM').format(cellDetails.date)),
          ],
        ),
      );
    } else if (_controller.view == DateRangePickerView.decade) {
      return Container(
        margin: margin,
        decoration: boxDecoration,
        child: Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Text(DateFormat('yyy').format(cellDetails.date)),
          ],
        ),
      );
    } else {
      final int yearValue = cellDetails.date.year;
      return Container(
        margin: margin,
        decoration: boxDecoration,
        child: Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Text('$yearValue - ${yearValue + 9}'),
          ],
        ),
      );
    }
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
