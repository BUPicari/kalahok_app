part of 'survey_bloc.dart';

@immutable
abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

/// Get the survey w/ questionnaires
class GetSurveyWithQuestionnairesEvent extends SurveyEvent {
  final int surveyId;
  final int languageId;

  const GetSurveyWithQuestionnairesEvent({
    required this.surveyId,
    required this.languageId,
  });
}

/// Submit the survey responses
class SubmitSurveyResponseEvent extends SurveyEvent {
  final Surveys survey;

  const SubmitSurveyResponseEvent({ required this.survey });
}
