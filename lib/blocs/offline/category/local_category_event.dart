part of 'local_category_bloc.dart';

@immutable
abstract class LocalCategoryEvent extends Equatable {
  const LocalCategoryEvent();

  @override
  List<Object> get props => [];
}

/// Get local categories
class GetLocalCategoryListEvent extends LocalCategoryEvent {}
