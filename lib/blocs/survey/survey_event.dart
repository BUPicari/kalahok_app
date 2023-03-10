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

class SubmitSurveyResponseEvent extends SurveyEvent {
  final Survey survey;

  const SubmitSurveyResponseEvent({required this.survey});
}
