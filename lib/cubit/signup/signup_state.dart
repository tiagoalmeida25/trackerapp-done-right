part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String username;
  final String email;
  final String password;
  final SignupStatus status;

  const SignupState({
    required this.username,
    required this.email,
    required this.password,
    required this.status,
  });

  factory SignupState.initial() {
    return const SignupState(
      username: '',
      email: '',
      password: '',
      status: SignupStatus.initial,
    );
  }

  @override
  List<Object> get props => [username, email, password, status];

  SignupState copyWith({
    String? username,
    String? email,
    String? password,
    SignupStatus? status,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}
