import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/offline/local_done_screen.dart';
import 'package:kalahok_app/screens/offline/local_review_screen.dart';

/// CHECKED
class LocalGotoWidget extends StatelessWidget {
  final int index;
  final List<Questionnaire> questionnaires;
  final Questionnaire questionnaire;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const LocalGotoWidget({
    Key? key,
    required this.index,
    required this.questionnaires,
    required this.questionnaire,
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
    if (questionnaires.last == questionnaire) {
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
    bool condition = questionnaire == questionnaires.first;
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
              builder: (context) => LocalReviewScreen(
                survey: questionnaire.survey,
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
              builder: (context) => LocalDoneScreen(
                survey: questionnaire.survey,
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
    bool condition = questionnaire == questionnaires.last;
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
