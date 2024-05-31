import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/data/models/offline/dropdown.dart';
import 'package:kalahok_app/data/resources/offline/local_repo.dart';
import 'package:kalahok_app/widgets/offline/local_goto_widget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/response.dart';
import 'package:kalahok_app/helpers/variables.dart';

/// CHECKED
class LocalDropdownTypeWidget extends StatefulWidget {
  final int index;
  final List<Questionnaire> questionnaires;
  final Questionnaire questionnaire;
  final ValueChanged<Response> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const LocalDropdownTypeWidget({
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
  State<LocalDropdownTypeWidget> createState() => _LocalDropdownTypeWidgetState();
}

class _LocalDropdownTypeWidgetState extends State<LocalDropdownTypeWidget> {
  late String _filter;
  late LocalRepository _localRepository;
  List<String> responses = [];
  List<String> fieldTexts = [];
  late GlobalKey _gestureDetectorKey;

  Future<List<Dropdown>> _getData({
    required String endpoint,
    String? filter,
    String? query,
  }) async {
    return await _localRepository.getDropdownData(
      endpoint: endpoint,
      filter: filter,
      query: query,
    );
  }

  @override
  void initState() {
    super.initState();
    _gestureDetectorKey = GlobalKey();

    _filter = '';
    _localRepository = LocalRepository();
    responses = widget.questionnaire.response?.responses ?? [];
    fieldTexts = widget.questionnaire.labels.map((label) => label.name).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Trigger the tap on GestureDetector after the first frame is built
      _triggerTap();
    });
  }

  void _triggerTap() {
    // Access the GestureDetector widget using the GlobalKey
    final GestureDetector? gestureDetector = _gestureDetectorKey.currentWidget as GestureDetector?;
    gestureDetector?.onTap?.call();
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
            isRequired: widget.questionnaire.configs.isRequired,
            question: widget.questionnaire.question,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: _buildDropdownForm(),
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

  Widget _buildDropdownForm() {
    bool useStaticDropdown = widget.questionnaire.configs.useStaticDropdown ?? false;

    if (widget.questionnaire.labels.first.endpoint == "address/paginate/province" ||
      widget.questionnaire.labels.first.endpoint == "address/paginate/city") {
      return _buildProvinceAndCityDropdown();
    }

    return ListView(
      children: widget.questionnaire.labels.asMap().map((i, label) => MapEntry(i,
        Column(children: [
          SearchableDropdown<Dropdown>.paginated(
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
            hintText: responses.isNotEmpty && responses[i] != '' ?
              Text(responses[i]) :
              Text('Select a ${label.name}'),
            margin: const EdgeInsets.all(15),
            paginatedRequest: (int page, String? searchKey) async {
              if (i == 0) {
                _filter = '';
              }
              /// todo: add filter too sa static
              if (useStaticDropdown) {
                return _staticPaginatedRequest(label: label);
              }
              return _nonStaticPaginatedRequest(
                endpoint: label.endpoint,
                filter: _filter != '' ? _filter : null,
                query: searchKey?.toString(),
              );
            },
            requestItemCount: 10,
            onChanged: (Dropdown? val) {
              setState(() {
                _filter = val?.value ?? '';
                int index = widget.questionnaire.labels.indexOf(label);

                responses.isNotEmpty
                  ? responses[index] = (val?.label).toString()
                  : responses = List.generate(widget.questionnaire.labels.length, (i) =>
                    i == index ? (val?.label).toString() : '');
              });

              if (widget.questionnaire.response == null) {
                _setResponse();
              } else {
                widget.questionnaire.response?.responses = responses;
              }
            },
          ),
          const SizedBox(height: 10),
        ]),
      )).values.toList(),
    );
  }

  Future<List<SearchableDropdownMenuItem<Dropdown>>> _staticPaginatedRequest({
    required Label label,
  }) async {
    final options = label.endpoint.split(',');

    return options.asMap().entries.map((e) {
      return SearchableDropdownMenuItem(
        value: Dropdown(value: e.key.toString(), label: e.value.trim()),
        label: e.value.trim(),
        child: Text(e.value.trim()),
      );
    }).toList();
  }

  Future<List<SearchableDropdownMenuItem<Dropdown>>> _nonStaticPaginatedRequest({
    required String endpoint,
    String? filter,
    String? query,
  }) async {
    final paginatedList = await _getData(
      endpoint: endpoint,
      filter: filter,
      query: query,
    );

    return paginatedList.map((e) => SearchableDropdownMenuItem(
      value: Dropdown(value: e.value, label: e.label),
      label: e.label,
      child: Text(e.label),
    )).toList();
  }

  Widget _buildProvinceAndCityDropdown() {
    List<Choice> addressChoices = [];
    List<String> addr = widget.addresses;

    for (var i = 0; i < addr.length; i++) {
      addressChoices.add(Choice(name: addr[i]));
      responses.isNotEmpty
        ? responses[i] = addr[i]
        : responses = List.generate(addr.length, (index) =>
          index == i ? addr[i] : '');
    }

    return GestureDetector(
      key: _gestureDetectorKey,
      onTap: () => _setResponse(),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: Functions.heightBetween(
          _buildChoiceContainer(choices: addressChoices),
          height: 8,
        ),
      ),
    );
  }

  List<Widget> _buildChoiceContainer({ required List<Choice> choices }) {
    var boxDecoration = BoxDecoration(
      color: AppColor.warning,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColor.neutral,
        width: 2.0,
      ),
    );

    return <Widget>[
      Container(
        padding: const EdgeInsets.all(12),
        decoration: boxDecoration,
        child: _buildChoice(label: "Province", choice: choices.first),
      ),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: boxDecoration,
        child: _buildChoice(label: "City", choice: choices.last),
      ),
    ].toList();
  }

  Widget _buildChoice({ required String label, required Choice choice }) {
    return SizedBox(
      height: 50,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.subPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Text(
                  choice.name,
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColor.subSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _setResponse() {
    widget.onSetResponse(Response(
      surveyQuestion: widget.questionnaire.question,
      questionFieldTexts: fieldTexts,
      responses: responses,
      otherResponse: '',
    ));
  }
}
