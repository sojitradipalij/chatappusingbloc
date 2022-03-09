import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/services/database.dart';
import 'package:bloc_chatapp/utils/app_utils.dart';
import 'package:bloc_chatapp/utils/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utils/PreferenceUtils.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<InitiateSearch>(_initiateSearch);
    on<CreateChatRoom>(_createChatRoom);
  }

  _initiateSearch(InitiateSearch event, Emitter<SearchState> emit) async {
    showLoader(event.context);
    emit(Loading());
    await DatabaseMethods()
        .getAllUserInfo(event.searchText)
        .then((snapshot) async {
      QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getAllUserInfo(event.searchText);
      List<DocumentSnapshot> userDocumentSnapshot = [];
      userDocumentSnapshot.addAll(userInfoSnapshot.docs);
      if (kDebugMode) {
        print("User Document ${userDocumentSnapshot.length}");
      }
      if (userDocumentSnapshot.isEmpty) {
        showToast("No Data Found");
      }
      emit(Success(userDocumentSnapshot));
    });
    Navigator.pop(event.context);
  }

  _createChatRoom(CreateChatRoom event, Emitter<SearchState> emit) async {
    List<String> userIds = [
      PreferenceUtils.getString(keyUserId),
      event.userData["UserId"] ?? ""
    ];
    List<String> users = [
      PreferenceUtils.getString(keyUserName),
      event.userData["userName"] ?? ""
    ];

    String chatRoomId;
    if (PreferenceUtils.getString(keyUserId).codeUnitAt(0) >
        event.userData["UserId"].codeUnitAt(0)) {
      chatRoomId =
          "${PreferenceUtils.getString(keyUserId)}_${event.userData["UserId"]}";
    } else {
      chatRoomId =
          "${event.userData["UserId"]}_${PreferenceUtils.getString(keyUserId)}";
    }

    Map<String, dynamic> chatRoom = {
      "sendBy": {
        "userId": PreferenceUtils.getString(keyUserId),
        "userName": PreferenceUtils.getString(keyUserName),
      },
      "receiveBy": {
        "userId": event.userData["UserId"],
        "userName": event.userData["userName"],
      },
      "userIds": userIds,
      "users": users,
      "chatRoomId": chatRoomId,
    };

    DatabaseMethods().addChatRoom(chatRoom, chatRoomId);

    await PreferenceUtils.setString(keyChatRoomId, chatRoomId);

    final state = this.state;
    if (state is Success || state is CreateSuccessfully) {
      emit(CreateSuccessfully(chatRoomId, event.userData["userName"] ?? "",
          userDocumentSnapshot: state.userDocumentSnapshot));
    } else {
      emit(CreateSuccessfully(chatRoomId, event.userData["userName"] ?? ""));
    }
  }
}
