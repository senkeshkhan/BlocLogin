part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUserEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginUserEvent({required this.email, required this.password});
}

class ChangeVisibilityEvent extends LoginEvent {
  final bool isVisible;

  const ChangeVisibilityEvent({required this.isVisible});
}
