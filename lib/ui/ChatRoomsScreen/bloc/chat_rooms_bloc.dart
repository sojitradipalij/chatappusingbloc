import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/services/database.dart';
import 'package:bloc_chatapp/utils/PreferenceUtils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../services/auth.dart';
import '../../../utils/app_utils.dart';

part 'chat_rooms_event.dart';

part 'chat_rooms_state.dart';

class ChatRoomsBloc extends Bloc<ChatRoomsEvent, ChatRoomsState> {
  ChatRoomsBloc() : super(ChatRoomsInitial()) {
    on<ChatRoomsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SignOut>(_signOut);
    on<GetChatRooms>(_getChatRooms);
    on<DeleteChatRooms>(_deleteChatRooms);
  }

  void _signOut(SignOut event, Emitter<ChatRoomsState> emit) async {
    AuthService().signOut();
    await PreferenceUtils.setString(keyUserId, "");
    emit(SignOutSuccessfully());
  }

  void _getChatRooms(GetChatRooms event, Emitter<ChatRoomsState> emit) {
    DatabaseMethods()
        .getUserChats(PreferenceUtils.getString(keyUserId))
        .then((chatRoomsStream) {
      if (kDebugMode) {
        print("val $chatRoomsStream");
      }
      // Stream chatRoomsStream;
      // chatRoomsStream=val;
      emit(ChatRooms(chatRoomsStream));
    });
  }

  void _deleteChatRooms(DeleteChatRooms event, Emitter<ChatRoomsState> emit) async{
    await DatabaseMethods().deleteChat(event.chatRoomId);
    DatabaseMethods().deleteChatRoom(event.chatRoomId);
    showToast("Delete Successfully");
  }
}
