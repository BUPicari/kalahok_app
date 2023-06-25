import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/waiver_screen.dart';

class CategorySurveyWidget extends StatelessWidget {
  final Surveys survey;

  const CategorySurveyWidget({
    Key? key,
    required this.survey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WaiverScreen(survey: survey),
      )),
      child: Container(
        padding: const EdgeInsets.all(30),
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
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              survey.description.replaceAll("\n", ""),
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: AppColor.subSecondary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            Text(
              "Available from",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColor.neutral,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${survey.startDate} to ${survey.endDate}",
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: AppColor.secondary,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: 160,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaiverScreen(survey: survey),
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
                        fontSize: 14,
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
