import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/models/category_survey_model.dart';
import 'package:kalahok_app/data/resources/category/category_repo.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository = CategoryRepository();

  CategoryBloc() : super(CategoryInitialState()) {
    on<GetCategoryListEvent>((event, emit) async {
      try {
        emit(CategoryLoadingState());
        final categories = await _categoryRepository.getCategoryList();
        emit(CategoryLoadedState(categories));
      } on NetworkError {
        emit(const CategoryErrorState("Failed to fetch data"));
      }
    });

    on<GetCategorySurveyListEvent>((event, emit) async {
      try {
        emit(CategorySurveyLoadingState());
        final categorySurvey = await _categoryRepository.getCategorySurvey(
            categoryId: event.categoryId);
        emit(CategorySurveyLoadedState(categorySurvey));
      } on NetworkError {
        emit(const CategoryErrorState("Failed to fetch data"));
      }
    });
  }
}
