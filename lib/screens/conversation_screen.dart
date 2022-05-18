import 'package:chat_app/services/constants.dart';
import 'package:chat_app/widgets/search_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  String chatRoomId;
  ConversationScreen({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController _messageController = TextEditingController();
  Stream<QuerySnapshot>? chatMessageStream;

  chatMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data!.docs[index].get("message"),
                    isSendByMe: snapshot.data!.docs[index].get("sendBy") ==
                        Constants.myName,
                  );
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": _messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      _messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              //title: ,
              backgroundColor: const Color.fromARGB(237, 30, 49, 157),
            ),
            body: chatMessageList(),
            bottomSheet: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 288,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Color.fromARGB(172, 255, 255, 255),
                        ),
                        //enabled: searchButton,
                        controller: _messageController,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(237, 30, 49, 157),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(0, 30, 49, 157)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(0, 30, 49, 157)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          hintText: "Message...",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(134, 255, 255, 255),
                            fontSize: 17,
                          ),
                        ),
                        // onTap: () {
                        //   //initiateSearch();

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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        onPressed: () {
                          //initiateSearch();
                          sendMessage();
                        },
                        child: const Icon(Icons.send_rounded,
                            color: Color.fromARGB(134, 255, 255, 255)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageTile({Key? key, required this.message, required this.isSendByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
              color: isSendByMe? const Color.fromARGB(224, 30, 49, 157):const Color.fromARGB(183, 0, 0, 0),
              borderRadius:isSendByMe? const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ):const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
