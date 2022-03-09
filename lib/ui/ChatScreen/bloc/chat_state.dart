part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class GetChatSuccessfully extends ChatState {
  final Stream chatMessageStream;
  final bool imageUploading;

  GetChatSuccessfully(
      {required this.chatMessageStream, this.imageUploading = false});

  List<Object> get props => [chatMessageStream, imageUploading];

  GetChatSuccessfully copyWith({
    Stream? chatMessageStream,
    bool? imageUploading,
  }) {
    return GetChatSuccessfully(
      chatMessageStream: chatMessageStream ?? this.chatMessageStream,
      imageUploading: imageUploading ?? this.imageUploading,
    );
  }
}
