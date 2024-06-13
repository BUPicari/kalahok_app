import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:kalahok_app/data/models/offline/survey.dart';
import 'package:kalahok_app/data/resources/offline/local_repo.dart';

part 'local_survey_event.dart';
part 'local_survey_state.dart';

class LocalSurveyBloc extends Bloc<LocalSurveyEvent, LocalSurveyState> {
  final LocalRepository _localRepository = LocalRepository();

  LocalSurveyBloc() : super(LocalSurveyInitialState()) {
    /// Get local surveys by category
    on<GetLocalSurveyByCategoryListEvent>((event, emit) async {
      try {
        emit(LocalSurveyByCategoryLoadingState());
        final surveys = await _localRepository.getSurveysByCategory(
          categoryId: event.categoryId,
        );
        emit(LocalSurveyByCategoryLoadedState(surveys));
      } catch (error) {
        emit(LocalSurveyErrorState(error.toString()));
      }
    });
  }
}
