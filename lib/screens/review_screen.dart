import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/question_screen.dart';
import 'package:kalahok_app/widgets/review_btn_widget.dart';

class ReviewScreen extends StatelessWidget {
  final Survey survey;

  const ReviewScreen({
    Key? key,
    required this.survey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  '* Red boxes is required and has no answers',
                  style: TextStyle(
                    color: AppColor.darkError,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '* Gray boxes is not required and has no answers',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '* Green boxes has answers',
                  style: TextStyle(
                    color: AppColor.darkSuccess,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: Utils.heightBetween(
                  _buildListViewChildren(),
                  height: 8,
                ),
              ),
            ),
            ReviewBtnWidget(survey: survey),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildListViewChildren() {
    return survey.questionnaires.map(
      (question) {
        return Card(
          color: getColorForBox(question),
          child: ExpansionTile(
            title: Text(
              question.question,
              style: TextStyle(
                color: AppColor.subSecondary,
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ),
            children: [
              Container(
                color: AppColor.subTertiary,
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: question.getReviewResponse(),
              ),
            ],
          ),
        );
      },
    ).toList();
  }

  PreferredSizeWidget buildAppBar(context) {
    return AppBar(
      title: const Text('Review Survey'),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColor.linearGradient,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      ),
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back,
          color: AppColor.subPrimary,
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QuestionScreen(survey: survey),
        )),
      ),
    );
  }

  Color getColorForBox(Question question) {
    Color boxColor = AppColor.neutral;

    if (question.config.isRequired &&
        question.response == null &&
        question.addedOthers == null) {
      boxColor = AppColor.error;
    } else if (question.response != null || question.addedOthers != null) {
      boxColor = AppColor.success;
    }

    return boxColor;
  }
}
