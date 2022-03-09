part of 'chat_rooms_bloc.dart';

@immutable
abstract class ChatRoomsState {}

class ChatRoomsInitial extends ChatRoomsState {}

class SignOutSuccessfully extends ChatRoomsState {
  List<Object> get props => [];
}

class ChatRooms extends ChatRoomsState {
  Stream chatRoomsStream;

  ChatRooms(this.chatRoomsStream);

  List<Object> get props => [];
}
