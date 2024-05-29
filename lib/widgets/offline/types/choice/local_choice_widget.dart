import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/response.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';

/// CHECKED
class LocalChoiceWidget extends StatefulWidget {
  final Questionnaire questionnaire;
  final ValueChanged<Response> onSetResponse;

  const LocalChoiceWidget({
    Key? key,
    required this.questionnaire,
    required this.onSetResponse,
  }) : super(key: key);

  @override
  State<LocalChoiceWidget> createState() => _LocalChoiceWidgetState();
}

class _LocalChoiceWidgetState extends State<LocalChoiceWidget> {
  TextEditingController addOthersController = TextEditingController();
  String otherResponse = '';
  List<String> selected = [];
  List<String> fieldTexts = [];

  @override
  void initState() {
    super.initState();

    addOthersController.text = widget.questionnaire.response?.otherResponse ?? '';
    otherResponse = widget.questionnaire.response?.otherResponse ?? '';
    selected = widget.questionnaire.response?.responses ?? [];
    fieldTexts = List.generate(1, (i) => widget.questionnaire.question);
  }

  @override
  void dispose() {
    addOthersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: Functions.heightBetween(
        _buildListViewChildren(),
        height: 8,
      ),
    );
  }

  List<Widget> _buildListViewChildren() {
    var children = <Widget>[];

    children = widget.questionnaire.choices
      .map((choice) => _buildChoiceContainer(choice: choice)).toList();

    if (widget.questionnaire.configs.canAddOthers) {
      children.add(_buildAddOthers());
    }

    return children;
  }

  Widget _buildChoiceContainer({ required Choice choice }) {
    final containerColor = _getColorForChoice(choice: choice);

    return GestureDetector(
      onTap: () {
        setState(() {
          selected.contains(choice.name) ?
            selected.remove(choice.name) :
            widget.questionnaire.configs.multipleAnswer ?
              selected.add(choice.name) :
              selected.isEmpty ?
                selected.add(choice.name) :
                selected[0] = choice.name;
        });
        _setResponse();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor.neutral,
            width: 2.0,
          ),
        ),
        child: Column(
          children: [
            _buildChoice(choice: choice),
          ],
        ),
      ),
    );
  }

  Widget _buildChoice({ required Choice choice }) {
    return SizedBox(
      height: 50,
      child: Row(
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
    );
  }

  Widget _buildAddOthers() {
    String subText = widget.questionnaire.type == 'trueOrFalse' ?
      'If Yes/No or True/False, please specify' :
      'If others, please specify';

    return TextField(
      controller: addOthersController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColor.neutral,
            width: 2.0,
          ),
        ),
        border: const OutlineInputBorder(),
        hintText: subText,
      ),
      style: const TextStyle(height: 2.0),
      onChanged: (value) {
        var cursorPos = addOthersController.selection;
        setState(() {
          otherResponse = value;
          addOthersController.text = value;
          if (cursorPos.start > value.length) {
            cursorPos = TextSelection.fromPosition(
              TextPosition(offset: value.length));
          }
          addOthersController.selection = cursorPos;
        });
        _setResponse();
      },
    );
  }

  Color _getColorForChoice({ required Choice choice }) {
    final isSelected = selected.contains(choice.name);
    if (!isSelected) return AppColor.subPrimary;

    return AppColor.warning;
  }

  void _setResponse() {
    widget.onSetResponse(Response(
      surveyQuestion: widget.questionnaire.question,
      questionFieldTexts: fieldTexts,
      responses: selected,
      otherResponse: otherResponse,
    ));
  }
}
