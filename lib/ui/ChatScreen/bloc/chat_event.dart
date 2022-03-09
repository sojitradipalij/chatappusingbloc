part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetChats extends ChatEvent {
  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;

  const SendMessage({required this.message});

  @override
  List<Object> get props => [message];
}

class SendImage extends ChatEvent {
  @override
  List<Object> get props => [];
}
