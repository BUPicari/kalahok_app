import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/online/category_model.dart';
import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/online/category_survey_screen.dart';
import 'package:kalahok_app/screens/online/waiver_screen.dart';
import 'package:kalahok_app/widgets/online/passcode_widget.dart';

/// CHECKED
class CategorySurveyLanguageWidget extends StatelessWidget {
  final Category category;
  final List<Surveys> surveys;
  final List<String> addresses;

  const CategorySurveyLanguageWidget({
    Key? key,
    required this.category,
    required this.surveys,
    required this.addresses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: AppColor.subPrimary,
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategorySurveyScreen(
              category: category,
              addresses: addresses,
            ),
          )),
        ),
        foregroundColor: AppColor.subPrimary,
        title: Text(surveys[0].title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: _buildWelcome(),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColor.linearGradient,
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _buildSurveyWithLanguageGridView(context),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your preferred',
          style: TextStyle(fontSize: 16, color: AppColor.subPrimary),
        ),
        Text(
          'Languages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.subPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSurveyWithLanguageGridView(context) {
    return SizedBox(
      height: 600,
      child: GridView(
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: surveys
          .map((survey) => _buildSurveyWithLanguageGridViewWidget(context: context, survey: survey))
          .toList(),
      ),
    );
  }

  Widget _buildSurveyWithLanguageGridViewWidget({
    context,
    required Surveys survey,
  }) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(30),
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
              "( ${survey.languageName} )",
              style: TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              survey.title,
              style: TextStyle(
                color: AppColor.warning,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            Text(
              survey.description.replaceAll("\n", ""),
              style: TextStyle(
                fontSize: 12,
                color: AppColor.subSecondary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            Text(
              "Available from:",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColor.neutral,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${survey.startDate} to ${survey.endDate}",
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: AppColor.secondary,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 25,
              width: 130,
              child: ElevatedButton(
                onPressed: () {
                  if (survey.passcode != "" && survey.passcode != null) {
                    PasscodeWidget.of(context).show(
                      survey: survey,
                      addresses: addresses,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaiverScreen(
                          survey: survey,
                          addresses: addresses,
                        ),
                      ),
                    );
                  }
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
                      'TAKE SURVEY',
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
}
