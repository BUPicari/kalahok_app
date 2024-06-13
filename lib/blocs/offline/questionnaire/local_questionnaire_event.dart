part of 'local_questionnaire_bloc.dart';

@immutable
abstract class LocalQuestionnaireEvent extends Equatable {
  const LocalQuestionnaireEvent();

  @override
  List<Object> get props => [];
}

/// Get local questionnaires by detail
class GetLocalQuestionnaireByDetailListEvent extends LocalQuestionnaireEvent {
  final int surveyId;
  final int detailsId;

  const GetLocalQuestionnaireByDetailListEvent({
    required this.surveyId,
    required this.detailsId,
  });
}
