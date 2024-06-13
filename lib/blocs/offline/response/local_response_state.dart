part of 'local_response_bloc.dart';

@immutable
abstract class LocalResponseState extends Equatable {
  const LocalResponseState();

  @override
  List<Object> get props => [];
}

class LocalResponseInitialState extends LocalResponseState {}

class LocalResponseLoadingState extends LocalResponseState {}

class LocalResponseReviewState extends LocalResponseState {}

class LocalResponseDoneState extends LocalResponseState {}

class LocalResponseErrorState extends LocalResponseState {
  final String error;
  const LocalResponseErrorState(this.error);
}
