import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/review_screen.dart';
import 'package:kalahok_app/screens/survey_done_screen.dart';

class PreviousNextButtonWidget extends StatelessWidget {
  final int index;
  final Questions question;
  final Surveys survey;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const PreviousNextButtonWidget({
    Key? key,
    required this.index,
    required this.question,
    required this.survey,
    required this.onPressedPrev,
    required this.onPressedNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 17),
      SizedBox(
        child: SizedBox(
          height: 50,
          child: _actions(context),
        ),
      ),
    ]);
  }

  Widget _actions(context) {
    if (survey.questionnaires?.last == question) {
      return Row(children: [
        _buildPrevBtn(),
        const SizedBox(width: 20),
        _buildReviewBtn(context),
        const SizedBox(width: 20),
        _buildSubmitBtn(context),
      ]);
    }

    return Row(children: [
      _buildPrevBtn(),
      const Spacer(),
      _buildNextBtn(),
    ]);
  }

  Widget _buildPrevBtn() {
    bool condition = question == survey.questionnaires?.first;
    var color = condition ? AppColor.secondary : AppColor.primary;

    return Expanded(
      child: ElevatedButton(
        onPressed: condition ? null : () => onPressedPrev(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
        ),
        child: Text(
          'Prev',
          style: TextStyle(
            color: AppColor.subPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewBtn(context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewScreen(survey: survey),
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
          'Review',
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
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
        ),
        child: Text(
          'Submit',
          style: TextStyle(
            color: AppColor.subPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNextBtn() {
    bool condition = question == survey.questionnaires?.last;
    var color = condition ? AppColor.secondary : AppColor.primary;

    return Expanded(
      child: ElevatedButton(
        onPressed: condition ? null : () => onPressedNext(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
        ),
        child: Text(
          'Next',
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
