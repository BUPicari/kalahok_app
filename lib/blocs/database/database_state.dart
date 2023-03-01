part of 'database_bloc.dart';

@immutable
abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object> get props => [];
}

class DatabaseInitialState extends DatabaseState {}

class DatabaseLoadingState extends DatabaseState {}

class DatabaseLoadedState extends DatabaseState {}

class DatabaseErrorState extends DatabaseState {
  final String error;
  const DatabaseErrorState(this.error);
}
