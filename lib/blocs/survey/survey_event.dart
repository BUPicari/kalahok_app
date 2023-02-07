part of 'survey_bloc.dart';

@immutable
abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

class GetSurveyListEvent extends SurveyEvent {
  final int surveyId;

  const GetSurveyListEvent({required this.surveyId});
}

class SubmitSurveyResponseEvent extends SurveyEvent {
  final Survey survey;

  const SubmitSurveyResponseEvent({required this.survey});
}
