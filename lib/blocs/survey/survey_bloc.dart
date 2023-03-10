import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/data/resources/survey/survey_repo.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SurveyRepository _surveyRepository = SurveyRepository();

  SurveyBloc() : super(SurveyInitialState()) {
    /// @usedFor: Getting a survey w/ questionnaires
    on<GetSurveyWithQuestionnairesEvent>((event, emit) async {
      try {
        emit(SurveyLoadingState());
        final surveyWithQuestionnaires = await _surveyRepository.getSurveyWithQuestionnaires(
            surveyId: event.surveyId);
        emit(SurveyLoadedState(surveyWithQuestionnaires));
      } catch (error) {
        emit(SurveyErrorState(error.toString()));
      }
    });

    on<SubmitSurveyResponseEvent>((event, emit) async {
      try {
        int numOfRequiredResponses = 0;

        for (var question in event.survey.questionnaires) {
          if (question.config.isRequired) {
            if ((question.response != null && question.response != "") ||
                (question.addedOthers != null && question.addedOthers != "")) {
              numOfRequiredResponses = numOfRequiredResponses + 1;
            }
          }
        }

        print('numOfRequired: ${event.survey.numOfRequired}');
        print('numOfRequiredResponses: $numOfRequiredResponses');

        if (event.survey.numOfRequired != numOfRequiredResponses) {
          emit(SurveyForReviewState());
        } else {
          emit(SurveyDoneState());
          await _surveyRepository.postSubmitSurveyResponse(
            survey: event.survey,
          );
        }
      } catch (error) {
        emit(SurveyErrorState(error.toString()));
      }
    });
  }
}
