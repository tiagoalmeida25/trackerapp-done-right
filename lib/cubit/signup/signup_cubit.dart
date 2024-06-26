import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trackerapp/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(SignupState.initial());

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, status: SignupStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  Future<void> signupWithCredentials() async {
    if (state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      final result = await _authRepository.signup(
        username: state.username.trim(),
        email: state.email.trim(),
        password: state.password,
      );

      if (result) {
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        emit(state.copyWith(status: SignupStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }
}
