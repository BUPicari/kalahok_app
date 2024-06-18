import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import 'package:kalahok_app/data/models/online/answer_model.dart';
import 'package:kalahok_app/data/models/online/dropdown_model.dart';
import 'package:kalahok_app/data/models/online/questions_model.dart';
import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/data/resources/online/dropdown/dropdown_repo.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/online/previous_next_button_widget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';

class DropdownQuestionWidget extends StatefulWidget {
  final int index;
  final Surveys survey;
  final Questions question;
  final ValueChanged<Answer> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const DropdownQuestionWidget({
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
  State<DropdownQuestionWidget> createState() => _DropdownQuestionWidgetState();
}

class _DropdownQuestionWidgetState extends State<DropdownQuestionWidget> {
  late DropdownRepository _dropdownRepository;
  List<String> responses = [];
  List<String> fieldTexts = [];
  List<int> filters = [];
  bool isReset = false;

  Future<List<Result>> _getData({
    required path,
    required page,
    required filter,
    required q,
  }) async {
    final list = await _dropdownRepository.getDropdownList(
      path: path,
      page: page,
      filter: filter,
      q: q,
    );

    return list.result;
  }

  @override
  void initState() {
    super.initState();

    _dropdownRepository = DropdownRepository();
    responses = widget.question.answer?.answers ?? [];
    fieldTexts = widget.question.labels.map((label) => label.name).toList();
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
          isReset ? _errorMessage() : Container(),
          Expanded(
            child: _buildDropdownForms(),
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

  Widget _errorMessage() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Responses has been reset, please select new ${widget.question.labels.last.name}.",
              style: TextStyle(
                color: AppColor.darkError,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDropdownForms() {
    bool useStaticDropdown = widget.question.config.useStaticDropdown ?? false;

    if (useStaticDropdown) {
      return _buildStaticForm();
    }

    return _buildNonStaticForm();
  }

  Widget _buildStaticForm() {
    return ListView(children: widget.question.labels.asMap().map((index, label)
      => MapEntry(index, Column(children: [
        SearchableDropdown<Result>.paginated(
          backgroundDecoration: (child) => Card(
            margin: EdgeInsets.zero,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColor.neutral,
                width: 2.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
          ),
          hintText: responses.isNotEmpty && responses[index] != '' ?
            Text(responses[index]) :
            Text('Select a ${label.name}'),
          margin: const EdgeInsets.all(15),
          paginatedRequest: (int page, String? searchKey) async {
            final options = label.endpoint.split(',');

            return options.asMap().entries.map((e) => SearchableDropdownMenuItem(
              value: Result(value: e.key, label: e.value.trim()),
              label: e.value.trim(),
              child: Text(e.value.trim()),
            )).toList();
          },
          requestItemCount: 10,
          onChanged: (Result? val) {
            setState(() {
              responses.isNotEmpty
                ? responses[index] = (val?.label).toString()
                : responses = List.generate(widget.question.labels.length, (i) =>
                  i == index ? (val?.label).toString() : '');
            });

            if (widget.question.answer == null) {
              _setResponse();
            } else {
              widget.question.answer?.answers = responses;
            }
          },
        ),
        const SizedBox(height: 10),
      ]))).values.toList());
  }

  Widget _buildNonStaticForm() {
    return ListView(children: widget.question.labels.asMap().map((index, label)
      => MapEntry(index, Column(children: [
        SearchableDropdown<Result>.paginated(
          backgroundDecoration: (child) => Card(
            margin: EdgeInsets.zero,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColor.neutral,
                width: 2.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
          ),
          hintText: responses.isNotEmpty && responses[index] != '' ?
            Text(responses[index]) :
            Text('Select a ${label.name}'),
          margin: const EdgeInsets.all(15),
          paginatedRequest: (int page, String? searchKey) async {
            String f = (index == 0) ? "0" :
              (index > 0 && filters.isNotEmpty && filters[index-1] != 0) ?
                filters[index-1].toString() : '';

            final paginatedList = await _getData(
              path: '/${label.endpoint}',
              page: page,
              filter: f,
              q: searchKey != null ? searchKey.toString() : '',
            );

            return paginatedList.map((e) => SearchableDropdownMenuItem(
              value: Result(value: e.value, label: e.label),
              label: e.label,
              child: Text(e.label),
            )).toList();
          },
          requestItemCount: 10,
          onChanged: (Result? val) {
            setState(() {
              if (index == 0 &&
                responses.isNotEmpty &&
                responses[index+1] != '') {
                isReset = true;
              } else {
                isReset = false;
              }

              if (index == 0) {
                filters = [];
                responses = [];
              }

              filters.isNotEmpty ?
                filters[index] = (val?.value) ?? 0 :
                filters = List.generate(widget.question.labels.length, (i) =>
                  i == index ? (val?.value) ?? 0 : 0);

              responses.isNotEmpty ?
                responses[index] = (val?.label).toString() :
                responses = List.generate(widget.question.labels.length, (i) =>
                  i == index ? (val?.label).toString() : '');
            });

            if (widget.question.answer == null) {
              _setResponse();
            } else {
              widget.question.answer?.answers = responses;
            }
          },
        ),
        const SizedBox(height: 10),
      ]))).values.toList());
  }

  void _setResponse() {
    widget.onSetResponse(Answer(
      surveyQuestion: widget.question.question,
      questionFieldTexts: fieldTexts,
      answers: responses,
      otherAnswer: '',
    ));
  }
}
