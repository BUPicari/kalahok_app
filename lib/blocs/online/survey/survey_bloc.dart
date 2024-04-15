import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kalahok_app/data/models/online/questions_model.dart';
import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/data/resources/online/survey/survey_repo.dart';
import 'package:kalahok_app/helpers/functions.dart';

part 'survey_event.dart';
part 'survey_state.dart';

/// CHECKED
class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SurveyRepository _surveyRepository = SurveyRepository();

  SurveyBloc() : super(SurveyInitialState()) {
    /// Getting a survey w/ questionnaires
    on<GetSurveyWithQuestionnairesEvent>((event, emit) async {
      try {
        emit(SurveyLoadingState());
        final surveyWithQuestionnaires = await _surveyRepository.getSurveyWithQuestionnaires(
          surveyId: event.surveyId,
          languageId: event.languageId,
        );
        emit(SurveyLoadedState(surveyWithQuestionnaires));
        Functions.audioRename(from: 'PENDING', to: 'DENY');
      } catch (error) {
        emit(SurveyErrorState(error.toString()));
      }
    });

    /// Submit a response from a survey
    on<SubmitSurveyResponseEvent>((event, emit) async {
      try {
        int numOfRequiredResponses = 0;
        List<Questions> questionnaires = event.survey.questionnaires ?? [];

        for (var question in questionnaires) {
          if (question.config.isRequired) {
            var answer = question.answer;
            if ((answer != null && answer.answers.isNotEmpty) ||
              (answer != null && answer.otherAnswer.isNotEmpty) ||
              (answer != null && answer.file != null)) {
              numOfRequiredResponses += 1;
            }
          }
        }

        print('numOfRequired: ${event.survey.numOfRequired}');
        print('numOfRequiredResponses: $numOfRequiredResponses');

        if (event.survey.numOfRequired != numOfRequiredResponses) {
          emit(SurveyForReviewState());
        } else {
          emit(SurveyDoneState());
          await _surveyRepository.postSubmitSurveyResponse(survey: event.survey);
        }
      } catch (error) {
        emit(SurveyErrorState(error.toString()));
      }
    });
  }
}
