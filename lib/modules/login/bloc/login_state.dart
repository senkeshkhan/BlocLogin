part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

class LoginUserLoadingState extends LoginState {}

class LoginUserErrorState extends LoginState {
  final String message;
  const LoginUserErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class LoginUserSuccessState extends LoginState {}

class ChangeVisibilityState extends LoginState {
  final bool isVisible;

  const ChangeVisibilityState({required this.isVisible});

  @override
  List<Object> get props => [isVisible];
}
