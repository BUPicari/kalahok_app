part of 'local_questionnaire_bloc.dart';

@immutable
abstract class LocalQuestionnaireState extends Equatable {
  const LocalQuestionnaireState();

  @override
  List<Object> get props => [];
}

class LocalQuestionnaireInitialState extends LocalQuestionnaireState {}

class LocalQuestionnaireByDetailLoadingState extends LocalQuestionnaireState {}

/// Local Questionnaires by detail
class LocalQuestionnaireByDetailLoadedState extends LocalQuestionnaireState {
  final List<Questionnaire> questionnaires;
  const LocalQuestionnaireByDetailLoadedState(this.questionnaires);
}

class LocalQuestionnaireErrorState extends LocalQuestionnaireState {
  final String error;
  const LocalQuestionnaireErrorState(this.error);
}
