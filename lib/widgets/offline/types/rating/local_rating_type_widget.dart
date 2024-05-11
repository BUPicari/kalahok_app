import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/response.dart';
import 'package:kalahok_app/widgets/offline/local_goto_widget.dart';
import 'package:kalahok_app/widgets/question_text_widget.dart';
import 'package:kalahok_app/widgets/offline/types/rating/local_rate_widget.dart';

/// CHECKED
class LocalRatingTypeWidget extends StatelessWidget {
  final int index;
  final List<Questionnaire> questionnaires;
  final Questionnaire questionnaire;
  final ValueChanged<Response> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const LocalRatingTypeWidget({
    Key? key,
    required this.index,
    required this.questionnaires,
    required this.questionnaire,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
    required this.addresses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          QuestionTextWidget(
            isRequired: questionnaire.configs.isRequired,
            question: questionnaire.question,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: LocalRateWidget(
              questionnaire: questionnaire,
              onSetResponse: onSetResponse,
            ),
          ),
          LocalGotoWidget(
            index: index,
            questionnaires: questionnaires,
            questionnaire: questionnaire,
            onPressedPrev: onPressedPrev,
            onPressedNext: onPressedNext,
            addresses: addresses,
          ),
        ],
      ),
    );
  }
}
