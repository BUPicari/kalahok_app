import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/offline/local_goto_widget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/response.dart';

class LocalDatePickerTypeWidget extends StatefulWidget {
  final int index;
  final List<Questionnaire> questionnaires;
  final Questionnaire questionnaire;
  final ValueChanged<Response> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const LocalDatePickerTypeWidget({
    Key? key,
    required this.index,
    required this.questionnaires,
    required this.questionnaire,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
    required this.addresses,
  }) : super(key: key);

  @override
  State<LocalDatePickerTypeWidget> createState() => _LocalDatePickerTypeWidgetState();
}

class _LocalDatePickerTypeWidgetState extends State<LocalDatePickerTypeWidget> {
  late DateTime initialDate;
  List<String> selected = [];
  List<String> fieldTexts = [];
  late DateRangePickerController _controller;

  @override
  void initState() {
    super.initState();

    initialDate = DateTime(1998, 01);
    selected = widget.questionnaire.response?.responses ?? [];
    fieldTexts = List.generate(1, (i) => widget.questionnaire.question);
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
            isRequired: widget.questionnaire.configs.isRequired,
            question: widget.questionnaire.question,
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
          LocalGotoWidget(
            index: widget.index,
            questionnaires: widget.questionnaires,
            questionnaire: widget.questionnaire,
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
    widget.onSetResponse(Response(
      surveyQuestion: widget.questionnaire.question,
      questionFieldTexts: fieldTexts,
      responses: selected,
      otherResponse: '',
    ));
  }
}
