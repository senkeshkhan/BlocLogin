import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:login/api/api_repository.dart';
import 'package:login/utils/app_utils.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  bool isVisible = false;
  final ApiRepository _apiRepo = ApiRepository();

  LoginBloc() : super(LoginInitial()) {
    on<LoginUserEvent>(loginUserBloc);
    on<ChangeVisibilityEvent>(changeVisibilityBloc);
  }

  loginUserBloc(LoginUserEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginUserLoadingState());

      // Validations
      if (event.email.trim().isEmpty) {
        emit(const LoginUserErrorState(message: "Email can't be empty"));
        return;
      } else if (event.password.trim().isEmpty) {
        emit(const LoginUserErrorState(message: "Password can't be empty"));
        return;
      }

      final response =
          await _apiRepo.loginWithEmailAndPassword(event.email, event.password);

      if (response.runtimeType == Exception) {
        emit(const LoginUserErrorState(message: "Unable to login right now"));
      } else {
        final body = jsonDecode(response.body);
        if (response.statusCode == 200) {
          await AppUtils.setToken(body['data']['token']);
          await AppUtils.setUserId(body['data']['user_id']);
          emit(LoginUserSuccessState());
        } else {
          if (body.containsKey('msg')) {
            emit(LoginUserErrorState(message: body['msg']));
          } else if (body.containsKey('error')) {
            emit(LoginUserErrorState(message: body['error']));
          } else {
            emit(const LoginUserErrorState(message: "Something went wrong"));
          }
        }
      }
    } catch (e) {
      emit(const LoginUserErrorState(message: "Internal Error Occured"));
    }
  }

  changeVisibilityBloc(
    ChangeVisibilityEvent event,
    Emitter<LoginState> emit,
  ) async {
    isVisible = event.isVisible;
    emit(ChangeVisibilityState(isVisible: isVisible));
  }
}
