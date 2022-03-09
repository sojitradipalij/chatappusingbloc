part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class InitiateSearch extends SearchEvent {
  InitiateSearch({required this.searchText, required this.context});

  final String searchText;
  BuildContext context;

  @override
  List<Object> get props => [searchText, context];
}

class CreateChatRoom extends SearchEvent {
  const CreateChatRoom({required this.userData});

  final Map<String, dynamic> userData;

  @override
  List<Object> get props => [userData];
}
