part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {
  bool isSecure;

  SignUpInitial({this.isSecure = true});

  List<Object> get props => [isSecure];

  SignUpInitial copyWith({
    bool? isSecure,
  }) {
    return SignUpInitial(
      isSecure: isSecure ?? this.isSecure,
    );
  }
}

class Loading extends SignUpState {
  List<Object> get props => [];
}

class SignedUpSuccess extends SignUpState {
  List<Object> get props => [];
}

class SignedUpFail extends SignUpState {
  List<Object> get props => [];
}
