part of 'category_bloc.dart';

@immutable
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<Category> categories;
  const CategoryLoadedState(this.categories);
}

class CategorySurveyInitialState extends CategoryState {}

class CategorySurveyLoadingState extends CategoryState {}

class CategorySurveyLoadedState extends CategoryState {
  final CategorySurvey categorySurvey;
  const CategorySurveyLoadedState(this.categorySurvey);
}

class CategoryErrorState extends CategoryState {
  final String error;
  const CategoryErrorState(this.error);
}
