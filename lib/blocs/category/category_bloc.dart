import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/resources/category/category_repo.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository = CategoryRepository();

  CategoryBloc() : super(CategoryInitialState()) {
    /// @usedFor: Getting all the categories/domains w/o surveys
    on<GetCategoryListEvent>((event, emit) async {
      try {
        emit(CategoryLoadingState());
        final categories = await _categoryRepository.getCategoryList();
        emit(CategoryLoadedState(categories));
      } catch (error) {
        emit(CategoryErrorState(error.toString()));
      }
    });

    /// @usedFor: Getting a category/domain w/ surveys
    on<GetCategoryWithSurveyListEvent>((event, emit) async {
      try {
        emit(CategoryWithSurveyLoadingState());
        final categoryWithSurvey = await _categoryRepository.getCategoryWithSurvey(
            categoryId: event.categoryId);
        emit(CategoryWithSurveyLoadedState(categoryWithSurvey));
      } catch (error) {
        emit(CategoryErrorState(error.toString()));
      }
    });
  }
}
