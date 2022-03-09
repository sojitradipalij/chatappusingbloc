import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../utils/PreferenceUtils.dart';
import '../utils/app_utils.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  getAllUserInfo(String userName) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userName", isEqualTo: userName)
        .where("UserId", isNotEqualTo: PreferenceUtils.getString(keyUserId))
        .get()
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  Future<bool?> addChatRoom(chatRoom, chatRoomId) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }

  setLastMessage(chatRoomId, message) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .update({"lastMessage": message}).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots();
  }

  deleteChat(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(chatRoomId)
            .collection("chats")
            .doc(element.id)
            .delete()
            .then((value) {
          if (kDebugMode) {
            print("Success!");
          }
        });
      });
    });
  }

  deleteChatRoom(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .delete();
  }

  Future<void> sendMessage(String chatRoomId, chatMessageData) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  getUserChats(String itIsMyID) async {
    if (kDebugMode) {
      print("itIsMyID $itIsMyID");
    }
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('userIds', arrayContains: itIsMyID)
        .snapshots();
  }

  Future uploadFile(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    try {
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (e) {
      showToast(e.message ?? e.toString());
      return null;
    }
  }
}
