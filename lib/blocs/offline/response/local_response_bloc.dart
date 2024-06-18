import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/survey.dart';
import 'package:kalahok_app/data/resources/offline/local_repo.dart';
import 'package:kalahok_app/helpers/functions.dart';

part 'local_response_event.dart';
part 'local_response_state.dart';

class LocalResponseBloc extends Bloc<LocalResponseEvent, LocalResponseState> {
  final LocalRepository _localRepository = LocalRepository();

  LocalResponseBloc() : super(LocalResponseInitialState()) {
    /// Submit response to local db
    on<SubmitLocalResponseEvent>((event, emit) async {
      try {
        int numOfRequiredResponses = 0;

        for (var question in event.questionnaires) {
          if (question.configs.isRequired) {
            String otherResponse = question.response?.otherResponse ?? '';
            List<String> response = question.response?.responses ?? [];
            String file = question.response?.file ?? '';

            if ((response.isNotEmpty && Functions.arrDoesNotOnlyContainsEmptyString(strArr: response)) ||
              (otherResponse.isNotEmpty) || (file.isNotEmpty)) {
              numOfRequiredResponses += 1;
            }
          }
        }

        if (event.survey.numOfRequired != numOfRequiredResponses) {
          emit(LocalResponseReviewState());
        } else {
          emit(LocalResponseDoneState());
          await _localRepository.postSubmitLocalResponse(
            survey: event.survey,
            questionnaires: event.questionnaires,
          );
        }
      } catch (error) {
        emit(LocalResponseErrorState(error.toString()));
      }
    });
  }
}
