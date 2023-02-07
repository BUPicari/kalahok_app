part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryListEvent extends CategoryEvent {}

class GetCategorySurveyListEvent extends CategoryEvent {
  final int categoryId;

  const GetCategorySurveyListEvent({required this.categoryId});
}
