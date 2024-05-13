import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/online/question_screen.dart';
import 'package:kalahok_app/screens/online/survey_done_screen.dart';

/// CHECKED
class ReviewButtonWidget extends StatelessWidget {
  final Surveys survey;
  final List<String> addresses;

  const ReviewButtonWidget({
    Key? key,
    required this.survey,
    required this.addresses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 17),
      SizedBox(
        child: SizedBox(
          height: 50,
          child: Row(children: [
            _buildAnswerBtn(context),
            const Spacer(),
            _buildSubmitBtn(context),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildAnswerBtn(context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionScreen(
                survey: survey,
                addresses: addresses,
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
            fontSize: 13,
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
              builder: (context) => SurveyDoneScreen(
                survey: survey,
                addresses: addresses,
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
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
