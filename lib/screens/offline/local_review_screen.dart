import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/survey.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/offline/local_questionnaire_screen.dart';
import 'package:kalahok_app/screens/offline/local_record_screen.dart';
import 'package:kalahok_app/widgets/offline/local_review_button_widget.dart';

/// CHECKED
class LocalReviewScreen extends StatefulWidget {
  final Survey survey;
  final List<Questionnaire> questionnaires;

  const LocalReviewScreen({
    Key? key,
    required this.survey,
    required this.questionnaires,
  }) : super(key: key);

  @override
  State<LocalReviewScreen> createState() => _LocalReviewScreenState();
}

class _LocalReviewScreenState extends State<LocalReviewScreen> {
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
                children: Functions.heightBetween(
                  _buildListViewChildren(context),
                  height: 8,
                ),
              ),
            ),
            LocalReviewButtonWidget(
              survey: widget.survey,
              questionnaires: widget.questionnaires,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildListViewChildren(context) {
    return widget.questionnaires.map(
      (questionnaire) {
        return Card(
          color: _getColorForBox(questionnaire),
          child: ExpansionTile(
            title: Text(
              questionnaire.question,
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
                child: _getReviewResponses(
                  context: context,
                  questionnaire: questionnaire,
                ),
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
          builder: (context) => LocalQuestionnaireScreen(
            survey: widget.survey,
            questionnaires: widget.questionnaires,
          ),
        )),
      ),
    );
  }

  Color _getColorForBox(Questionnaire questionnaire) {
    Color boxColor = AppColor.neutral;
    String otherResponse = questionnaire.response?.otherResponse ?? '';
    List<String> response = questionnaire.response?.responses ?? [];
    String file = questionnaire.response?.file ?? '';

    if (questionnaire.configs.isRequired &&
      response.isEmpty &&
      otherResponse.isEmpty
    ) {
      boxColor = AppColor.error;
    } else if ((response.isNotEmpty &&
      Functions.arrDoesNotOnlyContainsEmptyString(strArr: response)) ||
      otherResponse.isNotEmpty
    ) {
      boxColor = AppColor.success;
    } else if ((response.isNotEmpty &&
      !Functions.arrDoesNotOnlyContainsEmptyString(strArr: response)) ||
      otherResponse.isNotEmpty
    ) {
      boxColor = AppColor.error;
    }

    if (file.isNotEmpty) {
      boxColor = AppColor.success;
    }

    return boxColor;
  }

  Widget _getReviewResponses({
    required context,
    required Questionnaire questionnaire,
  }) {
    List<String> response = questionnaire.response?.responses ?? [];
    String otherResponse = questionnaire.response?.otherResponse ?? '';
    String file = questionnaire.response?.file ?? '';
    if (questionnaire.configs.multipleAnswer ||
      questionnaire.configs.canAddOthers ||
      questionnaire.type == 'openEnded' ||
      questionnaire.type == 'dropdown'
    ) {
      List<Widget> responsesWidget = response.map((res) {
        String ans = response.length == 1 && res.isNotEmpty ?
          'Answer: $res' :
          res.isNotEmpty ?
            'Answer (${response.indexOf(res) + 1}):  $res' :
            '';

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
          ]);
      }).toList();

      Widget addOthersWidget = const Column();
      String othersOrSpecifyText = questionnaire.type == 'trueOrFalse' ?
        'Specify:' :
        'Others:';

      if (otherResponse.isNotEmpty) {
        addOthersWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              '$othersOrSpecifyText $otherResponse',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ),
          ],
        );
      }

      if (questionnaire.type == 'openEnded' && file.isNotEmpty) {
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
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocalRecordScreen(
                      questionnaire: questionnaire,
                      questionnaires: widget.questionnaires,
                      survey: widget.survey,
                      screen: "Review",
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
          ),
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
      response.isNotEmpty ? 'Answer: ${response.join(', ')}' : '',
      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
    );
  }
}
