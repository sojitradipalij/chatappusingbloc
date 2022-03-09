part of 'sign_in_bloc.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {
  bool isSecure;

  SignInInitial({this.isSecure = true});

  List<Object> get props => [isSecure];

  SignInInitial copyWith({
    bool? isSecure,
  }) {
    return SignInInitial(
      isSecure: isSecure ?? this.isSecure,
    );
  }
}

class Loading extends SignInState {
  List<Object> get props => [];
}

class SignedInSuccess extends SignInState {
  List<Object> get props => [];
}

class SignedInFail extends SignInState {
  List<Object> get props => [];
}
