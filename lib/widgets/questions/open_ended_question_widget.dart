import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/widgets/PreviousNextButtonWidget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/widgets/review_button_widget.dart';

class OpenEndedQuestionWidget extends StatelessWidget {
  final int index;
  // final TextEditingController textController;
  final Survey survey;
  final Question question;
  final ValueChanged<String> onChanged;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const OpenEndedQuestionWidget({
    Key? key,
    required this.index,
    // required this.textController,
    required this.survey,
    required this.question,
    required this.onChanged,
    required this.onPressedPrev,
    required this.onPressedNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          QuestionTextWidget(
            isRequired: question.config.isRequired,
            question: question.question,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Column(children: buildTextFieldForms()),
          ),
          PreviousNextButtonWidget(
            index: index,
            question: question,
            survey: survey,
            onPressedPrev: onPressedPrev,
            onPressedNext: onPressedNext,
          ),
          ReviewButtonWidget(
            question: question,
            survey: survey,
          ),
        ],
      ),
    );
  }

  List<Widget> buildTextFieldForms() {
    List<Widget> textFields = question.labels
        .map(
          (label) => Column(children: [
            TextField(
              // controller: textController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: label.name,
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(height: 2.0),
              onChanged: (value) {
                onChanged('${question.labels.indexOf(label)}, $value');
                // textController.text = value;
              },
            ),
            const SizedBox(height: 10),
          ]),
        )
        .toList();

    return textFields;
  }
}
