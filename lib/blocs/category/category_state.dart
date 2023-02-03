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

class CategoryErrorState extends CategoryState {
  final String error;
  const CategoryErrorState(this.error);
}
