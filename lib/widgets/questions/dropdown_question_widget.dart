import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/dropdown_model.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/data/resources/dropdown/dropdown_repo.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/PreviousNextButtonWidget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/widgets/review_button_widget.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class DropdownQuestionWidget extends StatefulWidget {
  final int index;
  final Surveys survey;
  final Questions question;
  // final ValueChanged<String> onChanged;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const DropdownQuestionWidget({
    Key? key,
    required this.index,
    required this.survey,
    required this.question,
    // required this.onChanged,
    required this.onPressedPrev,
    required this.onPressedNext,
  }) : super(key: key);

  @override
  State<DropdownQuestionWidget> createState() => _DropdownQuestionWidgetState();
}

class _DropdownQuestionWidgetState extends State<DropdownQuestionWidget> {
  late int _tempId;
  late DropdownRepository _dropdownRepository;

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

    _tempId = 0;
    _dropdownRepository = DropdownRepository();
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
            child: _buildDropdownForms(),
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

  Widget _buildDropdownForms() {
    return ListView(
      children: widget.question.labels
          .map(
            (label) => Column(
              children: [
                SearchableDropdown<Result>.paginated(
                  backgroundDecoration: (child) => Card(
                    margin: EdgeInsets.zero,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: AppColor.neutral,
                          width: 2.0
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: child,
                    ),
                  ),
                  hintText: Text('Select a ${label.name}'),
                  margin: const EdgeInsets.all(15),
                  paginatedRequest: (int page, String? searchKey) async {
                    final paginatedList = await _getData(
                      path: '/${label.endpoint}',
                      page: page,
                      filter: _tempId != 0 ? _tempId.toString() : '',
                      q: searchKey != null ? searchKey.toString() : '',
                    );

                    /// todo: fix this, nag tutuloy and data kahit nasa pinaka dulo na data na siya

                    return paginatedList
                        .map((e) => SearchableDropdownMenuItem(
                          value: Result(value: e.value, label: e.label),
                          label: e.label ?? '',
                          child: Text(e.label ?? ''),
                        ))
                        .toList();
                  },
                  requestItemCount: 10,
                  onChanged: (Result? val) {
                    setState(() {
                      _tempId = (val?.value)?.toInt() ?? 0;
                    });
                    // widget.onChanged(
                    //     '${widget.question.labels.indexOf(label)},${val?.label.toString()}'
                    // );
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
