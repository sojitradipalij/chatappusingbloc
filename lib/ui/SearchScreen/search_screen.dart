import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/PreferenceUtils.dart';
import '../../utils/app_utils.dart';
import '../ChatScreen/chat_screen.dart';
import 'bloc/search_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: SearchBodyView(),
    );
  }
}

class SearchBodyView extends StatelessWidget {
  SearchBodyView({Key? key}) : super(key: key);

  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: bodyView(context),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF000000),
      title: TextField(
        controller: searchTextController,
        style: whiteRegular16,
        cursorColor: Colors.white,
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
          if (searchTextController.text != "") {
            BlocProvider.of<SearchBloc>(context).add(InitiateSearch(
                searchText: searchTextController.text, context: context));
          }
        },
        decoration: const InputDecoration(
          hintText: "Search Username Here...",
          hintStyle: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          border: InputBorder.none,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (searchTextController.text != "") {
              BlocProvider.of<SearchBloc>(context).add(InitiateSearch(
                  searchText: searchTextController.text, context: context));
            }
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Icon(
                Icons.search,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  Widget bodyView(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) async {
        if (state is CreateSuccessfully) {
          searchTextController.text = "";
          await PreferenceUtils.setString(keyChatRoomId, state.chatRoomId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        chatRoomId: state.chatRoomId,
                        userName: state.userName,
                      )));
        }
      },
      builder: (context, state) {
        if (state is Success || state is CreateSuccessfully) {
          return state.userDocumentSnapshot.length > 0
              ? ListView.builder(
                  padding: const EdgeInsets.only(top: 5),
                  itemBuilder: (context, index) {
                    return userView(context, index,
                        state.userDocumentSnapshot[index].data());
                  },
                  itemCount: state.userDocumentSnapshot.length,
                )
              : Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget userView(BuildContext context, int index, var userData) {
    String asciiValue =
        userData["userName"].toUpperCase().codeUnitAt(0).toString();
    Color backgroundColor = Color(int.parse(
            "#0ba0${asciiValue[1]}${asciiValue[0]}".substring(1, 7),
            radix: 16) +
        0xFF000000);

    return InkWell(
      onTap: () {
        BlocProvider.of<SearchBloc>(context).add(CreateChatRoom(userData: {
          "UserId": userData["UserId"],
          "userEmail": userData["userEmail"],
          "userName": userData["userName"]
        }));
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: backgroundColor,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    "${userData["userName"][0]}".toUpperCase(),
                    style: whiteBold16,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                "${userData["userName"]}",
                style: blackBold16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
