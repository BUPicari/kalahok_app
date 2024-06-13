part of 'category_bloc.dart';

@immutable
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

/// Categories w/o surveys
class CategoryLoadedState extends CategoryState {
  final List<Category> categories;
  const CategoryLoadedState(this.categories);
}

class CategoryWithSurveyLoadingState extends CategoryState {}

/// Category w/ surveys
class CategoryWithSurveyLoadedState extends CategoryState {
  final Category? categoryWithSurvey;
  const CategoryWithSurveyLoadedState(this.categoryWithSurvey);
}

class CategoryErrorState extends CategoryState {
  final String error;
  const CategoryErrorState(this.error);
}
