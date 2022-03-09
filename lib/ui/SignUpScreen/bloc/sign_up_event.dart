part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpPressed extends SignUpEvent {
  const SignUpPressed(
      {required this.userName, required this.email, required this.password});

  final String userName;
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SetSecureUnSecurePassword extends SignUpEvent {
  @override
  List<Object> get props => [];
}
