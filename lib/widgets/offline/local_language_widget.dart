import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/survey_detail.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/offline/local_survey_screen.dart';
import 'package:kalahok_app/screens/offline/local_waiver_screen.dart';

/// CHECKED
class LocalLanguageWidget extends StatelessWidget {
  final List<SurveyDetail> surveyDetails;

  const LocalLanguageWidget({
    Key? key,
    required this.surveyDetails,
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
            builder: (context) => LocalSurveyScreen(
              category: surveyDetails[0].survey.category,
            ),
          )),
        ),
        foregroundColor: AppColor.subPrimary,
        title: Text(surveyDetails[0].survey.title),
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
        children: surveyDetails
          .map((detail) => _buildSurveyWithLanguageGridViewWidget(
            context: context,
            surveyDetail: detail,
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildSurveyWithLanguageGridViewWidget({
    context,
    required SurveyDetail surveyDetail,
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
              "${surveyDetail.survey.title} - ${surveyDetail.language.name}",
              style: TextStyle(
                color: AppColor.warning,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              surveyDetail.survey.description.replaceAll("\n", ""),
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: AppColor.subSecondary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
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
              "${surveyDetail.survey.startDate} to ${surveyDetail.survey.endDate}",
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: AppColor.secondary,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 25,
              width: 130,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocalWaiverScreen(surveyDetail: surveyDetail),
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
