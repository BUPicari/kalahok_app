import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';

class LocalQuestionnaireOrdersWidget extends StatelessWidget {
  final List<Questionnaire> questionnaires;
  final Questionnaire questionnaire;
  final ValueChanged<int> onClickedNumber;
  final ScrollController scrollController;
  final ListObserverController observerController;

  const LocalQuestionnaireOrdersWidget({
    Key? key,
    required this.questionnaires,
    required this.questionnaire,
    required this.onClickedNumber,
    required this.scrollController,
    required this.observerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double padding = 16;

    return SizedBox(
      height: 50,
      child: ListViewObserver(
        controller: observerController,
        child: ListView.separated(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: padding),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => Container(width: padding),
          itemCount: questionnaires.length,
          itemBuilder: (context, index) {
            final isSelected = questionnaire == questionnaires[index];
            return _buildNumber(index: index, isSelected: isSelected);
          },
        ),
      ),
    );
  }

  Widget _buildNumber({ required int index, required bool isSelected }) {
    final color = _generateColor(
      questionnaire: questionnaires[index],
      isSelected: isSelected,
    );

    return GestureDetector(
      onTap: () => onClickedNumber(index),
      child: CircleAvatar(
        backgroundColor: color,
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: AppColor.subSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Color _generateColor({
    required Questionnaire questionnaire,
    required bool isSelected,
  }) {
    var color = AppColor.subPrimary;
    String otherResponse = questionnaire.response?.otherResponse ?? '';
    List<String> response = questionnaire.response?.responses ?? [];
    String file = questionnaire.response?.file ?? '';

    if ((response.isNotEmpty &&
      Functions.arrDoesNotOnlyContainsEmptyString(strArr: response)) ||
      otherResponse.isNotEmpty) color = AppColor.darkSuccess;

    if (file.isNotEmpty) color = AppColor.darkSuccess;

    if (isSelected) color = AppColor.warning;

    return color;
  }
}
