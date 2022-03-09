import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/services/auth.dart';
import 'package:bloc_chatapp/services/database.dart';
import 'package:bloc_chatapp/utils/PreferenceUtils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpPressed>(_signUnPassword);
    on<SetSecureUnSecurePassword>(_setSecureUnSecurePassword);
  }

  void _signUnPassword(SignUpPressed event, Emitter<SignUpState> emit) async {
    emit(Loading());
    await AuthService()
        .signUpWithEmailAndPassword(event.email, event.password)
        .then((result) async {
      if (result != null) {
        if (kDebugMode) {
          print("result : $result");
        }

        await PreferenceUtils.setString(keyUserId, "${result.uid}");
        await PreferenceUtils.setString(keyUserName, event.userName);
        await PreferenceUtils.setString(keyUserEmail, event.email);

        Map<String, dynamic> userDataMap = {
          "UserId": result.uid,
          "userName": event.userName,
          "userEmail": event.email
        };
        await DatabaseMethods().addUserInfo(userDataMap);

        emit(SignedUpSuccess());
      } else {
        emit(SignUpInitial());
      }
    });
  }

  void _setSecureUnSecurePassword(event, emit) {
    final state = this.state;
    if (state is SignUpInitial) {
      emit(state.copyWith(isSecure: !state.isSecure));
    }
  }
}
