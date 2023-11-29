import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trackerapp/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  Future<void> loginWithCredentials() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final result =
          await _authRepository.loginWithEmailAndPassword(email: state.email, password: state.password);

      if (result) {
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        emit(state.copyWith(status: LoginStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
}
