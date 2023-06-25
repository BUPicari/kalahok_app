import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/review_screen.dart';

class ReviewButtonWidget extends StatelessWidget {
  final Questions question;
  final Surveys survey;

  const ReviewButtonWidget({
    Key? key,
    required this.question,
    required this.survey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (survey.questionnaires?.last == question) {
      return Column(children: [
        const SizedBox(height: 17),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewScreen(survey: survey),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(33),
            ),
          ),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'REVIEW ANSWERS',
              style: TextStyle(
                color: AppColor.subPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
      ]);
    }

    return Container();
  }
}
