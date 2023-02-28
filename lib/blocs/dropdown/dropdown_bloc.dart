import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalahok_app/data/models/dropdown_model.dart';
import 'package:kalahok_app/data/resources/dropdown/dropdown_repo.dart';

part 'dropdown_event.dart';
part 'dropdown_state.dart';

class DropdownBloc extends Bloc<DropdownEvent, DropdownState> {
  final DropdownRepository _dropdownRepository = DropdownRepository();

  DropdownBloc() : super(DropdownInitialState()) {
    on<GetDropdownListEvent>((event, emit) async {
      try {
        emit(DropdownLoadingState());
        final dropdown = await _dropdownRepository.getDropdownList(
          path: event.path,
          page: event.page,
          filter: event.filter,
          q: event.q,
        );
        emit(DropdownLoadedState(dropdown));
      } on NetworkError {
        emit(const DropdownErrorState("Failed to fetch data"));
      }
    });
  }
}
