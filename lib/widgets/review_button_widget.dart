import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/review_screen.dart';

class ReviewButtonWidget extends StatelessWidget {
  final Question question;
  final Survey survey;

  const ReviewButtonWidget({
    Key? key,
    required this.question,
    required this.survey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (survey.questionnaires.last == question) {
      return Column(children: [
        const SizedBox(height: 17),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: SizedBox(
              height: 50,
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
            ),
          ),
        ),
      ]);
    }

    return Container();
  }
}
