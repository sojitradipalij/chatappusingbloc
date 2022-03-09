import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/database.dart';
import '../../../utils/PreferenceUtils.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetChats>(_getChats);
    on<SendMessage>(_sendMessage);
    on<SendImage>(_sendImage);
  }

  void _getChats(event, emit) {
    DatabaseMethods()
        .getChats(PreferenceUtils.getString(keyChatRoomId))
        .then((chatMessageStream) {
      if (kDebugMode) {
        print("chatMessageStream $chatMessageStream");
      }
      emit(GetChatSuccessfully(
          chatMessageStream: chatMessageStream, imageUploading: false));
    });
  }

  void _sendMessage(SendMessage event, emit) {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": PreferenceUtils.getString(keyUserId),
      "message": event.message,
      "type": 0,
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    if (kDebugMode) {
      print("chatMessageMap $chatMessageMap");
    }
    // DatabaseMethods().sendMessage(PreferenceUtils.getString(keyChatRoomId), chatMessageMap);
    DatabaseMethods()
        .sendMessage(PreferenceUtils.getString(keyChatRoomId), chatMessageMap);
    DatabaseMethods().setLastMessage(
        PreferenceUtils.getString(keyChatRoomId), chatMessageMap);
  }

  void _sendImage(SendImage event, emit) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final state = this.state;
      if (state is GetChatSuccessfully) {
        emit(state.copyWith(imageUploading: true));
        await DatabaseMethods().uploadFile(imageFile).then((value) {
          if (value != null) {
            Map<String, dynamic> chatMessageMap = {
              "sendBy": PreferenceUtils.getString(keyUserId),
              "message": value,
              "type": 1,
              'time': DateTime.now().millisecondsSinceEpoch,
            };
            DatabaseMethods().sendMessage(
                PreferenceUtils.getString(keyChatRoomId), chatMessageMap);
            DatabaseMethods().setLastMessage(
                PreferenceUtils.getString(keyChatRoomId), chatMessageMap);
          }
        });
        emit(state.copyWith(imageUploading: false));
      }
    }
  }
}
