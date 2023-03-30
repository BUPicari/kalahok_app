import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/question_screen.dart';
import 'package:kalahok_app/widgets/review_btn_widget.dart';

class ReviewScreen extends StatelessWidget {
  final Surveys survey;

  const ReviewScreen({
    Key? key,
    required this.survey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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
                  '* Red boxes are required and has no answers',
                  style: TextStyle(
                    color: AppColor.darkError,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '* Gray boxes are not required and has no answers',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '* Green boxes have answers',
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
    return survey.questionnaires!.map(
      (question) {
        return Card(
          color: _getColorForBox(question),
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
                child: Utils.getReviewResponse(question: question),
              ),
            ],
          ),
        );
      },
    ).toList();
  }

  PreferredSizeWidget _buildAppBar(context) {
    return AppBar(
      title: const Text('Recorded Response'),
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

  Color _getColorForBox(Questions question) {
    Color boxColor = AppColor.neutral;

    String otherAnswer = question.answer?.otherAnswer ?? '';
    List<String> answer = question.answer?.answers ?? [];

    if (question.config.isRequired && answer.isEmpty && otherAnswer.isEmpty) {
      boxColor = AppColor.error;
    } else if ((answer.isNotEmpty && Utils.doesNotOnlyContainsEmptyString(strArr: answer))
        || otherAnswer.isNotEmpty) {
      boxColor = AppColor.success;
    } else if ((answer.isNotEmpty && !Utils.doesNotOnlyContainsEmptyString(strArr: answer))
        || otherAnswer.isNotEmpty) {
      boxColor = AppColor.error;
    }

    return boxColor;
  }
}
