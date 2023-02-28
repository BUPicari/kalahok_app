part of 'dropdown_bloc.dart';

@immutable
abstract class DropdownEvent extends Equatable {
  const DropdownEvent();

  @override
  List<Object> get props => [];
}

class GetDropdownListEvent extends DropdownEvent {
  final String path;
  final int page;
  final String filter;
  final String q;

  const GetDropdownListEvent({
    required this.path,
    required this.page,
    required this.filter,
    required this.q,
  });
}
