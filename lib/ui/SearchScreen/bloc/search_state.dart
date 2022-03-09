part of 'search_bloc.dart';

@immutable
abstract class SearchState {
  get userDocumentSnapshot => null;
}

class SearchInitial extends SearchState {}

class Loading extends SearchState {
  List<Object> get props => [];
}

class Success extends SearchState {
  @override
  List<DocumentSnapshot> userDocumentSnapshot = [];

  Success(this.userDocumentSnapshot);

  List<Object> get props => [];
}

class Fail extends SearchState {
  List<Object> get props => [];
}

class CreateSuccessfully extends SearchState {
  @override
  List<DocumentSnapshot>? userDocumentSnapshot = [];
  final String chatRoomId;
  final String userName;

  CreateSuccessfully(this.chatRoomId, this.userName,
      {this.userDocumentSnapshot});

  List<Object> get props => [];
}
