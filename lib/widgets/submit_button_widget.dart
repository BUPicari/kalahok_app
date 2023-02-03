import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/screens/survey_done_screen.dart';

class SubmitButtonWidget extends StatelessWidget {
  final Question question;
  final Survey survey;

  const SubmitButtonWidget({
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
                      builder: (context) => SurveyDoneScreen(survey: survey),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(33),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
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
