import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/online/answer_model.dart';
import 'package:kalahok_app/data/models/online/questions_model.dart';
import 'package:kalahok_app/data/models/online/choice_model.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/question_subtext_widget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';

class ChoiceWidget extends StatefulWidget {
  final Questions question;
  final ValueChanged<Answer> onSetResponse;
  final String subText;

  const ChoiceWidget({
    Key? key,
    required this.question,
    required this.onSetResponse,
    required this.subText,
  }) : super(key: key);

  @override
  State<ChoiceWidget> createState() => _ChoiceWidgetState();
}

class _ChoiceWidgetState extends State<ChoiceWidget> {
  TextEditingController addOthersController = TextEditingController();
  String otherAnswer = '';
  List<String> selected = [];
  List<String> fieldTexts = [];

  @override
  void initState() {
    super.initState();

    addOthersController.text = widget.question.answer?.otherAnswer ?? '';
    otherAnswer = widget.question.answer?.otherAnswer ?? '';
    selected = widget.question.answer?.answers ?? [];
    fieldTexts = List.generate(1, (i) => widget.question.question);
  }

  @override
  void dispose() {
    addOthersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      children: Functions.heightBetween(
        _buildListViewChildren(),
        height: 8,
      ),
    );
  }

  List<Widget> _buildListViewChildren() {
    var children = <Widget>[];

    children.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        QuestionTextWidget(
          isRequired: widget.question.config.isRequired,
          question: widget.question.question,
        ),
        QuestionSubtextWidget(subText: widget.subText),
        const SizedBox(height: 12),
      ],
    ));

    widget.question.choices
      .map((choice) => children.add(_buildChoiceContainer(choice: choice)))
      .toList();

    if (widget.question.config.canAddOthers) {
      children.add(_buildAddOthers());
    }

    return children;
  }

  Widget _buildChoiceContainer({ required Choice choice }) {
    final containerColor = _getColorForChoice(choice: choice);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          selected.contains(choice.name) ?
            selected.remove(choice.name) :
            widget.question.config.multipleAnswer ?
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
    String subText = widget.question.type == 'trueOrFalse' ?
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
          otherAnswer = value;
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

    if (!isSelected) {
      return AppColor.subPrimary;
    } else {
      return AppColor.warning;
    }
  }

  void _setResponse() {
    widget.onSetResponse(Answer(
      surveyQuestion: widget.question.question,
      questionFieldTexts: fieldTexts,
      answers: selected,
      otherAnswer: otherAnswer,
    ));
  }
}
