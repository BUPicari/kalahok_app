part of 'local_category_bloc.dart';

@immutable
abstract class LocalCategoryState extends Equatable {
  const LocalCategoryState();

  @override
  List<Object> get props => [];
}

class LocalCategoryInitialState extends LocalCategoryState {}

class LocalCategoryLoadingState extends LocalCategoryState {}

/// All local categories
class LocalCategoryLoadedState extends LocalCategoryState {
  final List<Category> categories;
  const LocalCategoryLoadedState(this.categories);
}

class LocalCategoryErrorState extends LocalCategoryState {
  final String error;
  const LocalCategoryErrorState(this.error);
}
