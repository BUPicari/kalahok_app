import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/answer_model.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/previous_next_button_widget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/widgets/record_answer_widget.dart';
import 'package:kalahok_app/widgets/review_button_widget.dart';

class OpenEndedQuestionWidget extends StatefulWidget {
  final int index;
  final Surveys survey;
  final Questions question;
  final ValueChanged<Answer> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const OpenEndedQuestionWidget({
    Key? key,
    required this.index,
    required this.survey,
    required this.question,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
  }) : super(key: key);

  @override
  State<OpenEndedQuestionWidget> createState() => _OpenEndedQuestionWidgetState();
}

class _OpenEndedQuestionWidgetState extends State<OpenEndedQuestionWidget> {
  List<TextEditingController> fieldControllers = [];
  List<String> responses = [];
  List<String> fieldTexts = [];

  @override
  void initState() {
    super.initState();

    fieldControllers = widget.question.answer?.answers.map((e)
      => TextEditingController(text: e)).toList() ?? [];
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
          const SizedBox(height: 5),
          QuestionTextWidget(
            isRequired: widget.question.config.isRequired,
            question: widget.question.question,
          ),
          _recordingButton(),
          const SizedBox(height: 12),
          Expanded(
            child: _buildTextFieldForms(),
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

  Widget _recordingButton() {
    if (widget.question.config.enableAudioRecording) {
      return Column(
        children: [
          const SizedBox(height: 5),
          RecordAnswerWidget(question: widget.question),
        ]);
    }

    return Column();
  }

  Widget _buildTextFieldForms() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: Utils.heightBetween(
        _buildTextField(),
        height: 5,
      ),
    );
  }

  List<Widget> _buildTextField() {
    List<Widget> textFields = widget.question.labels
        .map(
          (label) => Column(children: [
            TextField(
              controller: fieldControllers.isNotEmpty
                  ? fieldControllers[widget.question.labels.indexOf(label)]
                  : null,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: AppColor.neutral,
                      width: 2.0
                  ),
                ),
                border: const OutlineInputBorder(),
                hintText: label.name,
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(height: 2.0),
              onChanged: (value) {
                setState(() {
                  int index = widget.question.labels.indexOf(label);

                  responses.isNotEmpty
                    ? responses[index] = value
                    : responses = List.generate(widget.question.labels.length, (i) =>
                      i == index ? value : '');

                  if (fieldControllers.isNotEmpty) {
                    fieldControllers[index].text = value;
                    fieldControllers[index].selection =
                      TextSelection.fromPosition(TextPosition(offset: fieldControllers[index].text.length));
                  } else {
                    fieldControllers = List.generate(widget.question.labels.length, (j) => j == index
                      ? TextEditingController(text: value)
                      : TextEditingController(text: ''));
                  }
                });

                if (widget.question.answer == null) {
                  _setResponse();
                } else {
                  widget.question.answer?.answers = responses;
                }
              },
            ),
            const SizedBox(height: 5),
          ]),
        )
        .toList();

    return textFields;
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
