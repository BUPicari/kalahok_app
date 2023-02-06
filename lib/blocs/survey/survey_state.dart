part of 'survey_bloc.dart';

@immutable
abstract class SurveyState extends Equatable {
  const SurveyState();

  @override
  List<Object> get props => [];
}

class SurveyInitialState extends SurveyState {}

class SurveyLoadingState extends SurveyState {}

class SurveyLoadedState extends SurveyState {
  final Survey survey;
  const SurveyLoadedState(this.survey);
}

class SurveyForReviewState extends SurveyState {}

class SurveyDoneState extends SurveyState {}

class SurveyErrorState extends SurveyState {
  final String error;
  const SurveyErrorState(this.error);
}
