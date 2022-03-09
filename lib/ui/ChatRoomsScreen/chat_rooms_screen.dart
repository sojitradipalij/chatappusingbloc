import 'package:bloc_chatapp/ui/SearchScreen/search_screen.dart';
import 'package:bloc_chatapp/utils/PreferenceUtils.dart';
import 'package:bloc_chatapp/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../ChatScreen/chat_screen.dart';
import '../SignInScreen/sign_in_screen.dart';
import 'bloc/chat_rooms_bloc.dart';

class ChatRoomsScreen extends StatelessWidget {
  const ChatRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatRoomsBloc()..add(GetChatRooms()),
      child: const ChatRoomsBodyView(),
    );
  }
}

class ChatRoomsBodyView extends StatelessWidget {
  const ChatRoomsBodyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: bodyView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
        child: const Icon(Icons.message),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text("Chat Rooms"),
      actions: [
        InkWell(
          onTap: () {
            BlocProvider.of<ChatRoomsBloc>(context).add(SignOut());
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  Widget bodyView(BuildContext context) {
    return BlocConsumer<ChatRoomsBloc, ChatRoomsState>(
      listener: (context, state) {
        if (state is SignOutSuccessfully) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false);
        }
      },
      builder: (context, state) {
        if (state is ChatRooms) {
          return StreamBuilder(
            stream: state.chatRoomsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot qSnap = snapshot.data as QuerySnapshot;
                List<DocumentSnapshot> docs = qSnap.docs;
                return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return userView(context, docs[index].data());
                    });
              } else {
                if (kDebugMode) {
                  print("no data");
                }
                return Container();
              }
            },
          );
        }
        return Container();
      },
    );
  }

  Widget userView(BuildContext context, var userData) {
    String userName;

    if (userData["userIds"][0] == PreferenceUtils.getString(keyUserId)) {
      userName = userData["users"][1];
    } else {
      userName = userData["users"][0];
    }

    if (kDebugMode) {
      print("userData $userData");
    }

    String asciiValue = userName.toUpperCase().codeUnitAt(0).toString();
    Color backgroundColor = Color(int.parse(
            "#0ba0${asciiValue[1]}${asciiValue[0]}".substring(1, 7),
            radix: 16) +
        0xFF000000);

    return InkWell(
      onTap: () async {
        // searchController.createChatRoom(userData);
        await PreferenceUtils.setString(keyChatRoomId, userData["chatRoomId"]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      chatRoomId: userData["chatRoomId"],
                      userName: userName,
                    )));
      },
      onLongPress: () {
        if (kDebugMode) {
          print("${userData["chatRoomId"]}");
        }
        BlocProvider.of<ChatRoomsBloc>(context)
            .add(DeleteChatRooms(chatRoomId: userData["chatRoomId"]));
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 55,
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: backgroundColor,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    userName[0].toUpperCase(),
                    style: whiteBold16,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userName,
                      style: blackBold16,
                    ),
                    userData["lastMessage"] != null
                        ? lastMessageView(userData)
                        : Container(),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  userData["lastMessage"] != null
                      ? showTimeView(userData)
                      : Container(),
                ],
              ),
              const SizedBox(
                width: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget lastMessageView(var userData) {
    return userData["lastMessage"]["type"] == 0
        ? Text(
            "${userData["lastMessage"]["message"]}",
            style: blackBold14.copyWith(color: Colors.black26),
            maxLines: 1,
          )
        : Row(
            children: [
              const Icon(
                Icons.image,
                color: Colors.black26,
                size: 18,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Text(
                "Photo",
                style: blackBold14.copyWith(color: Colors.black26),
                maxLines: 1,
              ))
            ],
          );
  }

  Widget showTimeView(var userData) {
    DateTime messageDate = DateTime.fromMillisecondsSinceEpoch(
        userData["lastMessage"]["time"] + 1000);
    if (kDebugMode) {
      print("$messageDate");
    }
    if (DateFormat("dd MM yyyy").format(DateTime.now()) !=
        DateFormat("dd MM yyyy").format(messageDate)) {
      return Text(
        DateFormat("dd/MM/yy").format(messageDate),
        style: blackBold14.copyWith(color: Colors.black26, fontSize: 12),
        maxLines: 1,
      );
    }
    return Text(
      DateFormat("hh:mm a").format(messageDate),
      style: blackBold14.copyWith(color: Colors.black26, fontSize: 12),
      maxLines: 1,
    );
  }
}
