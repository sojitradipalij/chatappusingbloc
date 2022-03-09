part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class LoginWithCredentialsPressed extends SignInEvent {
  const LoginWithCredentialsPressed(
      {required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SetSecureUnSecurePassword extends SignInEvent {
  @override
  List<Object> get props => [];
}
