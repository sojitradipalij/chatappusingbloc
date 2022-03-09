import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/services/auth.dart';
import 'package:bloc_chatapp/services/database.dart';
import 'package:bloc_chatapp/utils/PreferenceUtils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignInEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoginWithCredentialsPressed>(_signInWithEmailAndPassword);
    on<SetSecureUnSecurePassword>(_setSecureUnSecurePassword);
  }

  void _signInWithEmailAndPassword(
      LoginWithCredentialsPressed event, Emitter<SignInState> emit) async {
    emit(Loading());
    await AuthService()
        .signInWithEmailAndPassword(event.email, event.password)
        .then((result) async {
      if (result != null) {
        await PreferenceUtils.setString(keyUserId, result.uid);
        await PreferenceUtils.setString(keyUserEmail, "${result.email}");

        QuerySnapshot userInfoSnapshot =
            await DatabaseMethods().getUserInfo(event.email);
        final userData =
            userInfoSnapshot.docs[0].data() as Map<String, dynamic>;
        await PreferenceUtils.setString(keyUserName, "${userData["userName"]}");

        emit(SignedInSuccess());
      } else {
        emit(SignedInFail());
        emit(SignInInitial());
      }
    });
  }

  void _setSecureUnSecurePassword(event, emit) {
    final state = this.state;
    if (state is SignInInitial) {
      emit(state.copyWith(isSecure: !state.isSecure));
    }
  }
}
