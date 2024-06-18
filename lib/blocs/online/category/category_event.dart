part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

/// Get all the categories w/o surveys
class GetCategoryListEvent extends CategoryEvent {}

/// Get a category w/ surveys
class GetCategoryWithSurveyListEvent extends CategoryEvent {
  final int categoryId;

  const GetCategoryWithSurveyListEvent({ required this.categoryId });
}
