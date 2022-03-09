part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent {}

class SplashStarted extends SplashEvent {
  List<Object> get props => [];
}
