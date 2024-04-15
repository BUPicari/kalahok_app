import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/response.dart';
import 'package:kalahok_app/widgets/offline/types/choice/local_choice_type_widget.dart';
import 'package:kalahok_app/widgets/offline/types/datepicker/local_datepicker_type_widget.dart';
import 'package:kalahok_app/widgets/offline/types/dropdown/local_dropdown_type_widget.dart';
import 'package:kalahok_app/widgets/offline/types/openended/local_open_ended_type_widget.dart';
import 'package:kalahok_app/widgets/offline/types/rating/local_rating_type_widget.dart';
import 'package:kalahok_app/widgets/unkown_question_type_widget.dart';

/// CHECKED
class LocalQuestionnaireWidget extends StatelessWidget {
  final List<Questionnaire> questionnaires;
  final PageController pageController;
  final ValueChanged<int> onChangedPage;
  final ValueChanged<Response> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;

  const LocalQuestionnaireWidget({
    Key? key,
    required this.questionnaires,
    required this.pageController,
    required this.onChangedPage,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: onChangedPage,
      controller: pageController,
      itemCount: questionnaires.length,
      itemBuilder: (context, index) {
        final questionnaire = questionnaires[index];
        return _buildQuestionnaire(index: index, questionnaire: questionnaire);
      },
    );
  }

  Widget _buildQuestionnaire({
    required int index,
    required Questionnaire questionnaire,
  }) {
    switch (questionnaire.type) {
      case "multipleChoice":
        String subText = questionnaire.configs.multipleAnswer ?
          'Please select all that apply' :
          '';
        return LocalChoiceTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          subText: subText,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case "openEnded":
        return LocalOpenEndedTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case "trueOrFalse":
        return LocalChoiceTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          subText: '',
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case "rating":
        return LocalRatingTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case "datepicker":
        return LocalDatePickerTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      case "dropdown":
        return LocalDropdownTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
        );
      default:
        return const UnknownQuestionTypeWidget();
    }
  }
}
