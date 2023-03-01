part of 'database_bloc.dart';

@immutable
abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object> get props => [];
}

class GetDatabaseListEvent extends DatabaseEvent {}
