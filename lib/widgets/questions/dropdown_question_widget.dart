import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kalahok_app/data/models/dropdown_model.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/PreviousNextButtonWidget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/widgets/review_button_widget.dart';

class DropdownQuestionWidget extends StatefulWidget {
  final int index;
  final Survey survey;
  final Question question;
  final ValueChanged<String> onChanged;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const DropdownQuestionWidget({
    Key? key,
    required this.index,
    required this.survey,
    required this.question,
    required this.onChanged,
    required this.onPressedPrev,
    required this.onPressedNext,
  }) : super(key: key);

  @override
  State<DropdownQuestionWidget> createState() => _DropdownQuestionWidgetState();
}

class _DropdownQuestionWidgetState extends State<DropdownQuestionWidget> {
  late int tempId;

  @override
  void initState() {
    super.initState();

    tempId = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          QuestionTextWidget(
            isRequired: widget.question.config.isRequired,
            question: widget.question.question,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: buildDropdownForms(),
          ),
          PreviousNextButtonWidget(
            index: widget.index,
            question: widget.question,
            survey: widget.survey,
            onPressedPrev: widget.onPressedPrev,
            onPressedNext: widget.onPressedNext,
          ),
          ReviewButtonWidget(
            question: widget.question,
            survey: widget.survey,
          ),
        ],
      ),
    );
  }

  Widget buildDropdownForms() {
    return ListView(
      children: widget.question.labels
          .map(
            (label) => Column(
              children: [
                DropdownSearch<Dropdown>(
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: label.name,
                      hintText: 'Select a ${label.name}',
                    ),
                  ),
                  asyncItems: (String filter) async {
                    var path = widget.question.labels.indexOf(label) == 0
                        ? "/${label.endpoint}"
                        : "/${label.endpoint}?q=$tempId";
                    var url = Uri.parse(ApiConfig.baseUrl + path);
                    http.Response response = await http.get(url);
                    var dropdownJson = jsonDecode(response.body) as List;
                    return dropdownJson
                        .map((e) => Dropdown.fromJson(e))
                        .toList();
                  },
                  itemAsString: (Dropdown data) => data.name,
                  onChanged: (Dropdown? data) {
                    tempId = data?.id.toInt() ?? 0;
                    widget.onChanged(
                        '${widget.question.labels.indexOf(label)}, ${data?.name.toString()}');
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          )
          .toList(),
    );
  }
}
