part of 'chat_rooms_bloc.dart';

@immutable
abstract class ChatRoomsEvent extends Equatable {
  const ChatRoomsEvent();

  @override
  List<Object> get props => [];
}

class SignOut extends ChatRoomsEvent {
  @override
  List<Object> get props => [];
}

class GetChatRooms extends ChatRoomsEvent {
  @override
  List<Object> get props => [];
}

class DeleteChatRooms extends ChatRoomsEvent {
  final String chatRoomId;

  const DeleteChatRooms({required this.chatRoomId});

  @override
  List<Object> get props => [];
}
