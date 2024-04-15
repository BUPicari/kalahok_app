import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/response.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/offline/local_goto_widget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/widgets/offline/local_record_response_widget.dart';

/// CHECKED
class LocalOpenEndedTypeWidget extends StatefulWidget {
  final int index;
  final List<Questionnaire> questionnaires;
  final Questionnaire questionnaire;
  final ValueChanged<Response> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const LocalOpenEndedTypeWidget({
    Key? key,
    required this.index,
    required this.questionnaires,
    required this.questionnaire,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
  }) : super(key: key);

  @override
  State<LocalOpenEndedTypeWidget> createState() => _LocalOpenEndedTypeWidgetState();
}

class _LocalOpenEndedTypeWidgetState extends State<LocalOpenEndedTypeWidget> {
  List<TextEditingController> fieldControllers = [];
  List<String> responses = [];
  List<String> fieldTexts = [];

  @override
  void initState() {
    super.initState();

    fieldControllers = widget.questionnaire.response?.responses.map((e)
      => TextEditingController(text: e)).toList() ?? [];
    responses = widget.questionnaire.response?.responses ?? [];
    fieldTexts = widget.questionnaire.labels.map((label) => label.name).toList();
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
          _recordingButton(),
          const SizedBox(height: 12),
          Expanded(
            child: _buildTextFieldForms(),
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

  Widget _recordingButton() {
    bool enableAudioRecording =
      widget.questionnaire.configs.enableAudioRecording ?? false;
    bool hasInput = widget.questionnaire.hasInput ?? false;

    if (enableAudioRecording && hasInput == false) {
      return Column(
        children: [
          const SizedBox(height: 5),
          LocalRecordResponseWidget(
            questionnaire: widget.questionnaire,
            questionnaires: widget.questionnaires,
            survey: widget.questionnaire.survey,
          ),
        ],
      );
    }

    return Column();
  }

  Widget _buildTextFieldForms() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: Functions.heightBetween(
        _buildTextField(),
        height: 5,
      ),
    );
  }

  List<Widget> _buildTextField() {
    List<Widget> textFields = widget.questionnaire.labels
      .map(
        (label) => Column(children: [
          TextField(
            readOnly: widget.questionnaire.hasRecording == true,
            controller: fieldControllers.isNotEmpty
              ? fieldControllers[widget.questionnaire.labels.indexOf(label)]
              : null,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColor.neutral,
                  width: 2.0,
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
                int index = widget.questionnaire.labels.indexOf(label);

                responses.isNotEmpty
                  ? responses[index] = value
                  : responses = List.generate(
                    widget.questionnaire.labels.length, (i) =>
                      i == index ? value : '');

                if (fieldControllers.isNotEmpty) {
                  fieldControllers[index].text = value;
                  fieldControllers[index].selection =
                    TextSelection.fromPosition(
                      TextPosition(offset: fieldControllers[index].text.length),
                    );
                } else {
                  fieldControllers = List.generate(
                    widget.questionnaire.labels.length, (j) =>
                      j == index ? TextEditingController(text: value) :
                      TextEditingController(text: ''));
                }
              });

              if (widget.questionnaire.response == null) {
                _setResponse();
              } else {
                widget.questionnaire.response?.responses = responses;
              }

              if (Functions.arrDoesNotOnlyContainsEmptyString(strArr: responses)) {
                widget.questionnaire.hasRecording = false;
                widget.questionnaire.hasInput = true;
              } else {
                widget.questionnaire.hasRecording = false;
                widget.questionnaire.hasInput = false;
              }
            },
          ),
          const SizedBox(height: 5),
        ]),
      ).toList();

    return textFields;
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
