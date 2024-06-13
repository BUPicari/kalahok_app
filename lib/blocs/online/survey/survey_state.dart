part of 'survey_bloc.dart';

@immutable
abstract class SurveyState extends Equatable {
  const SurveyState();

  @override
  List<Object> get props => [];
}

class SurveyInitialState extends SurveyState {}

class SurveyLoadingState extends SurveyState {}

/// Survey w/ questionnaires
class SurveyLoadedState extends SurveyState {
  final Surveys? surveyWithQuestionnaires;
  const SurveyLoadedState(this.surveyWithQuestionnaires);
}

class SurveyForReviewState extends SurveyState {}

class SurveyDoneState extends SurveyState {}

class SurveyErrorState extends SurveyState {
  final String error;
  const SurveyErrorState(this.error);
}
