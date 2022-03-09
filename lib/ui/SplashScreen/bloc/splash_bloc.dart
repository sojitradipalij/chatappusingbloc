import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/utils/PreferenceUtils.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashStarted>(_onStarted);
  }

  void _onStarted(SplashStarted event, Emitter<SplashState> emit) async {
    await Future.delayed(const Duration(seconds: 2));
    await PreferenceUtils.init();
    if (PreferenceUtils.getString(keyUserId) != "") {
      emit(UserSignedIn());
    } else {
      emit(UserNotSignedIn());
    }
  }
}
