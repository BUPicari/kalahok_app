import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/online/questions_model.dart';
import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/online/record_screen.dart';
import 'package:kalahok_app/widgets/online/review_button_widget.dart';

/// CHECKED
class ReviewScreen extends StatelessWidget {
  final Surveys survey;
  final List<String> addresses;

  const ReviewScreen({
    Key? key,
    required this.survey,
    required this.addresses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '* Gray boxes are not required and has no answers',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '* Green boxes have answers',
                  style: TextStyle(
                    color: AppColor.darkSuccess,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: Functions.heightBetween(
                  _buildListViewChildren(context),
                  height: 8,
                ),
              ),
            ),
            ReviewButtonWidget(survey: survey, addresses: addresses),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildListViewChildren(context) {
    return survey.questionnaires!.map(
      (question) {
        return Card(
          color: _getColorForBox(question),
          child: ExpansionTile(
            title: Text(
              question.question,
              style: TextStyle(
                color: AppColor.subSecondary,
                fontSize: 16,
              ),
            ),
            children: [
              Container(
                color: AppColor.subTertiary,
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: _getReviewResponse(context: context, question: question),
              ),
            ],
          ),
        );
      },
    ).toList();
  }

  PreferredSizeWidget _buildAppBar(context) {
    return AppBar(
      foregroundColor: AppColor.subPrimary,
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
        onTap: () {
          // Navigate back to the previous screen by popping the current route
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Color _getColorForBox(Questions question) {
    Color boxColor = AppColor.neutral;

    String otherAnswer = question.answer?.otherAnswer ?? '';
    List<String> answer = question.answer?.answers ?? [];
    String file = question.answer?.file ?? '';

    if (question.config.isRequired && answer.isEmpty && otherAnswer.isEmpty) {
      boxColor = AppColor.error;
    } else if ((answer.isNotEmpty && Functions.arrDoesNotOnlyContainsEmptyString(strArr: answer))
      || otherAnswer.isNotEmpty) {
      boxColor = AppColor.success;
    } else if ((answer.isNotEmpty && !Functions.arrDoesNotOnlyContainsEmptyString(strArr: answer))
      || otherAnswer.isNotEmpty) {
      boxColor = AppColor.error;
    }

    if (file.isNotEmpty) {
      boxColor = AppColor.success;
    }

    return boxColor;
  }

  Widget _getReviewResponse({
    required context,
    required Questions question,
  }) {
    List<String> answer = question.answer?.answers ?? [];
    String otherAnswer = question.answer?.otherAnswer ?? '';
    String file = question.answer?.file ?? '';

    if (question.config.multipleAnswer ||
      question.config.canAddOthers ||
      question.type == 'openEnded' ||
      question.type == 'dropdown'
    ) {
      List<Widget> responsesWidget = answer.map((res) {
        String ans = answer.length == 1 && res.isNotEmpty
          ? 'Answer: $res'
          : res.isNotEmpty
            ? 'Answer (${answer.indexOf(res) + 1}):  $res'
            : '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              ans,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ),
          ],
        );
      }).toList();

      Widget addOthersWidget = const Column();
      String othersOrSpecifyText = question.type == 'trueOrFalse'
        ? 'Specify:'
        : 'Others:';

      if (otherAnswer.isNotEmpty) {
        addOthersWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              '$othersOrSpecifyText $otherAnswer',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ),
          ],
        );
      }

      if (question.type == 'openEnded' && file.isNotEmpty) {
        List<Widget> tempResponsesWidget = responsesWidget;
        responsesWidget = [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tempResponsesWidget,
          ),
          const SizedBox(height: 5),
          const Text(
            'Recorded File:',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(160, 50),
                backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(33),
                ),
              ),
              icon: Icon(
                color: AppColor.subPrimary,
                Icons.play_arrow,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecordScreen(
                      question: question,
                      survey: survey,
                      screen: "Review",
                      addresses: addresses,
                    ),
                  ),
                );
              },
              label: Text(
                'Play Recorded File',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColor.subPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ];
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: responsesWidget,
          ),
          addOthersWidget,
        ],
      );
    }

    return Text(
      answer.isNotEmpty ? 'Answer: ${answer.join(', ')}' : '',
      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
    );
  }
}
