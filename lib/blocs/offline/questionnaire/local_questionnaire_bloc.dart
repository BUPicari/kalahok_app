import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/resources/offline/local_repo.dart';
import 'package:kalahok_app/helpers/functions.dart';

part 'local_questionnaire_event.dart';
part 'local_questionnaire_state.dart';

/// CHECKED
class LocalQuestionnaireBloc extends Bloc<LocalQuestionnaireEvent, LocalQuestionnaireState> {
  final LocalRepository _localRepository = LocalRepository();

  LocalQuestionnaireBloc() : super(LocalQuestionnaireInitialState()) {
    /// Get local questionnaires by detail
    on<GetLocalQuestionnaireByDetailListEvent>((event, emit) async {
      try {
        emit(LocalQuestionnaireByDetailLoadingState());
        final questionnaires = await _localRepository.getQuestionnairesBySurvey(
          surveyId: event.surveyId,
          detailsId: event.detailsId,
        );
        emit(LocalQuestionnaireByDetailLoadedState(questionnaires));
        Functions.audioRename(from: 'PENDING', to: 'DENY');
      } catch (error) {
        emit(LocalQuestionnaireErrorState(error.toString()));
      }
    });
  }
}
