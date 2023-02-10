import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/question_screen.dart';
import 'package:kalahok_app/screens/survey_done_screen.dart';

class ReviewBtnWidget extends StatelessWidget {
  final Survey survey;

  const ReviewBtnWidget({
    Key? key,
    required this.survey,
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
              builder: (context) => QuestionScreen(survey: survey),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
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
              builder: (context) => SurveyDoneScreen(survey: survey),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
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
