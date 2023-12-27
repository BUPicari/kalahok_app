import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/category_survey_language_widget.dart';

class CategorySurveyWidget extends StatelessWidget {
  final Category category;
  final Surveys survey;

  const CategorySurveyWidget({
    Key? key,
    required this.category,
    required this.survey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.subPrimary,
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
            ),
            const SizedBox(height: 10),
            Text(
              "Available Languages",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColor.neutral,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _getAvailableLanguages(),
              style: TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: AppColor.secondary,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 25,
              width: 90,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategorySurveyLanguageWidget(category: category, surveys: _getNewSurveyArr()),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(33),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SELECT',
                      style: TextStyle(
                        color: AppColor.subPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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

    return languages.join(" | ");
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
      );
      newSurveyArr.add(newSurvey);
    }

    return newSurveyArr;
  }
}
