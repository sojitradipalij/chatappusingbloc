part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class UserSignedIn extends SplashState {
  List<Object> get props => [];
}

class UserNotSignedIn extends SplashState {
  List<Object> get props => [];
}
