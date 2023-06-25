part of 'survey_bloc.dart';

@immutable
abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

/// @usedFor: Get the survey w/ questionnaires
class GetSurveyWithQuestionnairesEvent extends SurveyEvent {
  final int surveyId;

  const GetSurveyWithQuestionnairesEvent({required this.surveyId});
}

/// @usedFor: Submit the survey responses
class SubmitSurveyResponseEvent extends SurveyEvent {
  final Surveys survey;

  const SubmitSurveyResponseEvent({required this.survey});
}
