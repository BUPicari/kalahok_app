import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/PreviousNextButtonWidget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/widgets/record_answer_widget.dart';
import 'package:kalahok_app/widgets/review_button_widget.dart';

class OpenEndedQuestionWidget extends StatelessWidget {
  final int index;
  // final TextEditingController textController;
  final Surveys survey;
  final Questions question;
  // final ValueChanged<String> onChanged;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const OpenEndedQuestionWidget({
    Key? key,
    required this.index,
    // required this.textController,
    required this.survey,
    required this.question,
    // required this.onChanged,
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
          const SizedBox(height: 5),
          QuestionTextWidget(
            isRequired: question.config.isRequired,
            question: question.question,
          ),
          const SizedBox(height: 5),
          const RecordAnswerWidget(),
          const SizedBox(height: 12),
          Expanded(
            child: _buildTextFieldForms(),
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
    List<Widget> textFields = question.labels
        .map(
          (label) => Column(children: [
            TextField(
              // controller: textController,
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
              // onChanged: (value) {
              //   onChanged('${question.labels.indexOf(label)}, $value');
              //   // textController.text = value;
              // },
            ),
            const SizedBox(height: 5),
          ]),
        )
        .toList();

    return textFields;
  }
}
