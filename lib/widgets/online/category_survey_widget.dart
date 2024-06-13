import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/online/category_model.dart';
import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/online/category_survey_language_widget.dart';
import 'package:kalahok_app/widgets/online/passcode_widget.dart';

class CategorySurveyWidget extends StatelessWidget {
  final Category category;
  final Surveys survey;
  final List<String> addresses;

  const CategorySurveyWidget({
    Key? key,
    required this.category,
    required this.survey,
    required this.addresses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasscodeWidget(
              progressText: "Enter the passcode:",
              child: CategorySurveyLanguageWidget(
                category: category,
                surveys: _getNewSurveyArr(),
                addresses: addresses,
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.bgNeutral,
          border: Border(
            bottom: BorderSide(
              width: 3,
              color: AppColor.primary,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              survey.title,
              style: TextStyle(
                color: AppColor.warning,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            Wrap(
              runSpacing: 5,
              spacing: 5,
              children: [
                Text(
                  "Languages:",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColor.neutral,
                  ),
                ),
                Text(
                  _getAvailableLanguages(),
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: AppColor.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getAvailableLanguages() {
    List<String> languages = [];
    List<SurveyDetails> details = survey.details ?? [];
    for (SurveyDetails detail in details) {
      languages.add(detail.language.name);
    }
    return languages.join(", ");
  }

  List<Surveys> _getNewSurveyArr() {
    List<Surveys> newSurveyArr = [];

    for (SurveyDetails detail in survey.details!) {
      Surveys newSurvey = Surveys(
        id: survey.id,
        title: survey.title,
        description: survey.description,
        startDate: survey.startDate,
        endDate: survey.endDate,
        languageId: detail.id,
        languageName: detail.language.name,
        passcode: survey.passcode,
      );
      newSurveyArr.add(newSurvey);
    }

    return newSurveyArr;
  }
}
