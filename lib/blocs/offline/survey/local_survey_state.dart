part of 'local_survey_bloc.dart';

@immutable
abstract class LocalSurveyState extends Equatable {
  const LocalSurveyState();

  @override
  List<Object> get props => [];
}

class LocalSurveyInitialState extends LocalSurveyState {}

class LocalSurveyByCategoryLoadingState extends LocalSurveyState {}

/// Local surveys by category
class LocalSurveyByCategoryLoadedState extends LocalSurveyState {
  final List<Survey> surveys;
  const LocalSurveyByCategoryLoadedState(this.surveys);
}

class LocalSurveyErrorState extends LocalSurveyState {
  final String error;
  const LocalSurveyErrorState(this.error);
}
