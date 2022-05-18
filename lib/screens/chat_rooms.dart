import 'package:chat_app/screens/account_screen.dart';
import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/helper_function.dart';

import 'package:chat_app/widgets/search_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream<QuerySnapshot>? chatRoomsStream;

  chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    userName: snapshot.data!.docs[index]
                        .get("chatroomId")
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data!.docs[index]
                        .get("chatroomId"),
                  );
                },
              )
            : Container(
                
              );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreferences();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 30, 49, 157),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const Search()));
              },
              child: const Icon(Icons.search_rounded),
            ),
            appBar: AppBar(
              toolbarHeight: 60,
              title: Image.asset(
                'assets/images/bubble_logo.png',
                width: 80,
              ),
              backgroundColor: const Color.fromARGB(255, 30, 49, 157),
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => const AccountScreen()));
                      },
                      icon: const Icon(Icons.person)),
                )
              ],
            ),
            body: chatRoomsList(),
          );
        });
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  const ChatRoomTile({Key? key, required this.userName, required this.chatRoomId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ConversationScreen(chatRoomId: chatRoomId)));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(150, 105, 124, 230),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 200,
          height: 90,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 30, 49, 157),
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      margin: const EdgeInsets.only(left: 7.0),
                      child: Text(
                        "${userName.substring(0, 1)}",
                        style:
                            const TextStyle(fontSize: 23, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
