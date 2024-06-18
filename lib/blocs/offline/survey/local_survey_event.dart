part of 'local_survey_bloc.dart';

@immutable
abstract class LocalSurveyEvent extends Equatable {
  const LocalSurveyEvent();

  @override
  List<Object> get props => [];
}

/// Get local surveys by category
class GetLocalSurveyByCategoryListEvent extends LocalSurveyEvent {
  final int categoryId;

  const GetLocalSurveyByCategoryListEvent({ required this.categoryId });
}
