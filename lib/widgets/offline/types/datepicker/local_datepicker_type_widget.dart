import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:kalahok_app/widgets/offline/local_goto_widget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/response.dart';

/// CHECKED
class LocalDatePickerTypeWidget extends StatefulWidget {
  final int index;
  final List<Questionnaire> questionnaires;
  final Questionnaire questionnaire;
  final ValueChanged<Response> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const LocalDatePickerTypeWidget({
    Key? key,
    required this.index,
    required this.questionnaires,
    required this.questionnaire,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
  }) : super(key: key);

  @override
  State<LocalDatePickerTypeWidget> createState() => _LocalDatePickerTypeWidgetState();
}

class _LocalDatePickerTypeWidgetState extends State<LocalDatePickerTypeWidget> {
  late DateTime initialDate;
  List<String> selected = [];
  List<String> fieldTexts = [];

  @override
  void initState() {
    super.initState();

    initialDate = DateTime(1998, 01);
    selected = widget.questionnaire.response?.responses ?? [];
    fieldTexts = List.generate(1, (i) => widget.questionnaire.question);
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
              onSelectionChanged: _setDateSelected,
              view: DateRangePickerView.month,
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
    widget.onSetResponse(Response(
      surveyQuestion: widget.questionnaire.question,
      questionFieldTexts: fieldTexts,
      responses: selected,
      otherResponse: '',
    ));
  }
}
