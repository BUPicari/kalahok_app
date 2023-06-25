part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

/// @usedFor: Get all the categories/domain w/o surveys
class GetCategoryListEvent extends CategoryEvent {}

/// @usedFor: Get a category/domain w/ surveys
class GetCategoryWithSurveyListEvent extends CategoryEvent {
  final int categoryId;

  const GetCategoryWithSurveyListEvent({required this.categoryId});
}
