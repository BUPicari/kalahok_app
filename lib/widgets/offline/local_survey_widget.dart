import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/survey.dart';
import 'package:kalahok_app/data/models/offline/survey_detail.dart';
import 'package:kalahok_app/data/resources/offline/local_repo.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/widgets/offline/local_language_widget.dart';
import 'package:kalahok_app/widgets/offline/local_passcode_widget.dart';

/// CHECKED
class LocalSurveyWidget extends StatelessWidget {
  final Survey survey;
  final List<String> addresses;

  const LocalSurveyWidget({
    Key? key,
    required this.survey,
    required this.addresses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _getDetailsBySurvey().then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocalPasscodeWidget(
                progressText: "Enter the passcode:",
                child: LocalLanguageWidget(
                  surveyDetails: value,
                  addresses: addresses,
                ),
              ),
            ),
          );
        });
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
                FutureBuilder(
                  future: _getAvailableLanguages(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.done ?
                    Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: AppColor.secondary,
                      ),
                    ) :
                    const SizedBox();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getAvailableLanguages() async {
    List<String> languages = [];
    List<SurveyDetail> details = await _getDetailsBySurvey();
    for (var detail in details) {
      languages.add(detail.language.name);
    }
    return languages.join(", ");
  }

  Future<List<SurveyDetail>> _getDetailsBySurvey() async {
    final LocalRepository localRepo = LocalRepository();

    List<SurveyDetail> details = await localRepo.getDetailsBySurvey(
      surveyId: survey.id,
    );

    return details.toList();
  }
}
