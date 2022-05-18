import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}
String? _myName;
DatabaseMethods databaseMethods = DatabaseMethods();
TextEditingController _searchController = TextEditingController();

class _SearchState extends State<Search> {
  QuerySnapshot? searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot?.docs[index].get("name"),
                userEmail: searchSnapshot?.docs[index].get("email"),
              );
            },
            itemCount: searchSnapshot?.docs.length,
          )
        : const SizedBox();
  }

  bool isLoading = false;

  initiateSearch() {
    databaseMethods.getUserByUsername(_searchController.text).then((val) {
      //print(val.toString());
      setState(() {
        isLoading = true;
        searchSnapshot = val;
      });
    });
  }

  createChatroomAndStartConversation({required String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };
      databaseMethods.createChatroom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) =>  ConversationScreen(chatRoomId: chatRoomId,))));
    }
  }

  Widget searchTile({required String userName, required String userEmail}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    userEmail,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 30, 49, 157)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ))),
                onPressed: () {
                  createChatroomAndStartConversation(userName: userName);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    'Message',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo()async{
    _myName = await HelperFunctions.getUserNameSharedPreferences();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          // if (snapshot.hasError) {
          //   return const Center(
          //     child: Text('Something went wrong'),
          //   );
          // }

          // Once complete, show your application
          // if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(19.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 59,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(237, 30, 49, 157)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios,
                          color: Color.fromARGB(134, 255, 255, 255)),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 230,
                    child: TextFormField(
                      style: const TextStyle(
                        color: Color.fromARGB(172, 255, 255, 255),
                      ),
                      //enabled: searchButton,
                      controller: _searchController,
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(237, 30, 49, 157),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(0, 30, 49, 157)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(0, 30, 49, 157)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        hintText: "Search username..",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(134, 255, 255, 255),
                          fontSize: 17,
                        ),
                      ),
                      // onTap: () {
                      //   initiateSearch();
                      // },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 60,
                    height: 59,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(237, 30, 49, 157)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ))),
                      onPressed: () {
                        initiateSearch();
                      },
                      child: const Icon(Icons.search_rounded,
                          color: Color.fromARGB(134, 255, 255, 255)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            child: searchList(),
          )
        ],
      ),
    );
  }
    );
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    // ignore: unnecessary_string_escapes
    return "$b\_$a";
  } else {
    // ignore: unnecessary_string_escapes
    return "$a\_$b";
  }
}
}