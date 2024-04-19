import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/survey.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/offline/local_done_screen.dart';
import 'package:kalahok_app/screens/offline/local_questionnaire_screen.dart';

/// CHECKED
class LocalReviewButtonWidget extends StatelessWidget {
  final Survey survey;
  final List<Questionnaire> questionnaires;

  const LocalReviewButtonWidget({
    Key? key,
    required this.survey,
    required this.questionnaires,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 17),
      SizedBox(
        child: SizedBox(
          height: 50,
          child: Row(children: [
            _buildAnswerButton(context),
            const Spacer(),
            _buildSubmitBtn(context),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildAnswerButton(context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocalQuestionnaireScreen(
                survey: survey,
                questionnaires: questionnaires,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
        ),
        child: Text(
          'ANSWER',
          style: TextStyle(
            color: AppColor.subPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitBtn(context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocalDoneScreen(
                survey: survey,
                questionnaires: questionnaires,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
        ),
        child: Text(
          'SUBMIT',
          style: TextStyle(
            color: AppColor.subPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
