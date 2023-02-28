part of 'dropdown_bloc.dart';

@immutable
abstract class DropdownState extends Equatable {
  const DropdownState();

  @override
  List<Object> get props => [];
}

class DropdownInitialState extends DropdownState {}

class DropdownLoadingState extends DropdownState {}

class DropdownLoadedState extends DropdownState {
  final Dropdown dropdown;
  const DropdownLoadedState(this.dropdown);
}

class DropdownErrorState extends DropdownState {
  final String error;
  const DropdownErrorState(this.error);
}
