part of 'local_response_bloc.dart';

@immutable
abstract class LocalResponseEvent extends Equatable {
  const LocalResponseEvent();

  @override
  List<Object> get props => [];
}

/// Submit the responses to local db
class SubmitLocalResponseEvent extends LocalResponseEvent {
  final Survey survey;
  final List<Questionnaire> questionnaires;

  const SubmitLocalResponseEvent({
    required this.survey,
    required this.questionnaires,
  });
}
