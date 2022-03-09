import 'dart:math' as math;

import 'package:bloc_chatapp/utils/full_photo_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/PreferenceUtils.dart';
import '../../utils/app_utils.dart';
import 'bloc/chat_bloc.dart';

class ChatScreen extends StatelessWidget {
  String? userName;
  String? chatRoomId;

  ChatScreen({Key? key, this.userName, this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(GetChats()),
      child: ChatBodyView(
        chatRoomId: chatRoomId,
        userName: userName,
      ),
    );
  }
}

class ChatBodyView extends StatelessWidget {
  String? userName;
  String? chatRoomId;

  ChatBodyView({Key? key, this.userName, this.chatRoomId}) : super(key: key);

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: bodyView(context),
    );
  }

  AppBar appBar() {
    String asciiValue = userName!.toUpperCase().codeUnitAt(0).toString();
    Color backgroundColor = Color(int.parse(
            "#0ba0${asciiValue[1]}${asciiValue[0]}".substring(1, 7),
            radix: 16) +
        0xFF000000);

    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(userName!),
    );
  }

  Widget bodyView(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is GetChatSuccessfully) {
              return Column(
                children: [
                  Expanded(child: chatMessages(state)),
                  uploadImageView(state),
                  const SizedBox(
                    height: 63,
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
        Positioned(bottom: 0, left: 0, right: 0, child: buildInput(context))
      ],
    );
  }

  Widget uploadImageView(state) {
    return state.imageUploading
        ? Align(
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.center,
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(10),
              ),
              margin:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
              child: const CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget chatMessages(state) {
    return StreamBuilder(
      stream: state.chatMessageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          QuerySnapshot qSnap = snapshot.data as QuerySnapshot;
          List<QueryDocumentSnapshot> listMessage = qSnap.docs;
          return ListView.builder(
              // controller: listScrollController,
              reverse: true,
              // padding: EdgeInsets.only(bottom: 60),
              itemCount: listMessage.length,
              itemBuilder: (context, index) {
                return itemMessage(context, listMessage[index].data());
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

  Widget itemMessage(BuildContext context, var itemData) {
    bool sendByMe =
        PreferenceUtils.getString(keyUserId) == "${itemData["sendBy"]}";

    if (kDebugMode) {
      print("sendByMe $sendByMe");
      print("docs $itemData");
    }

    String asciiValue = userName!.toUpperCase().codeUnitAt(0).toString();
    Color backgroundColor = Color(int.parse(
            "#900a${asciiValue[1]}${asciiValue[0]}".substring(1, 7),
            radix: 16) +
        0xFF000000);

    return itemData["type"] == null || itemData["type"] == 0
        ? Container(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
            alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: sendByMe
                  ? const EdgeInsets.only(left: 30)
                  : const EdgeInsets.only(right: 30),
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 20),
              decoration: BoxDecoration(
                  borderRadius: sendByMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                  gradient: LinearGradient(
                    colors: sendByMe
                        // ? [const Color(0xAD004D40), const Color(0xAD004D40)]
                        //   ? [const Color(0x50000000), const Color(0x70000000)]
                        ? [backgroundColor, backgroundColor]
                        : [const Color(0xffE8E8E8), const Color(0xffE8E8E8)],
                  )),
              child: Text("${itemData["message"]}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: sendByMe ? Colors.white : Colors.black,
                    // fontSize: 15,
                  )),
            ),
          )
        : Container(
            alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: OutlinedButton(
              child: Material(
                child: Image.network(
                  itemData["message"],
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE7E4E4),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      width: 200,
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          value: loadingProgress.expectedTotalBytes != null &&
                                  loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, object, stackTrace) {
                    return Material(
                      child: Image.asset(
                        'assets/images/img_not_available.jpeg',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      clipBehavior: Clip.hardEdge,
                    );
                  },
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
                // Get.to(FullPhotoPage(
                //   url: itemData["message"],
                // ));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FullPhotoPage(url: itemData["message"])));
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(0))),
            ),
            margin:
                const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
          );
  }

  Widget buildInput(BuildContext context) {
    String asciiValue = userName!.toUpperCase().codeUnitAt(0).toString();
    Color backgroundColor = Color(int.parse(
            "#0ba0${asciiValue[1]}${asciiValue[0]}".substring(1, 7),
            radix: 16) +
        0xFF000000);

    return Container(
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      color: const Color(0xDF000000),
      child: Container(
        height: 58,
        color: backgroundColor.withAlpha(50),
        alignment: Alignment.center,
        child: Row(
          children: [
            Material(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                child: IconButton(
                  icon: const Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    BlocProvider.of<ChatBloc>(context).add(SendImage());
                  },
                ),
              ),
              color: Colors.transparent,
            ),
            Expanded(
                child: TextField(
              controller: messageController,
              style: whiteRegular16,
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                  hintText: "Message ...",
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  border: InputBorder.none),
            )),
            const SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                if (messageController.text != "") {
                  BlocProvider.of<ChatBloc>(context)
                      .add(SendMessage(message: messageController.text));
                  messageController.text = "";
                }
                // chatController!.sendMessage(type: 0);
              },
              child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0x57FFFFFF), Color(0x1BFFFFFF)],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight),
                      borderRadius: BorderRadius.circular(40)),
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: -math.pi / 4,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
