import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }
  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatroom(String chatroomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatroomId)
        .set(chatRoomMap);
  }

  addConversationMessages(String chatroomId,messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
    .doc(chatroomId)
    .collection("chats")
    //if occures any error
    .add(messageMap).catchError((e){print(e.toString());});
  }

  getConversationMessages(String chatroomId)async{
    return  FirebaseFirestore.instance.collection("ChatRoom")
    .doc(chatroomId)
    .collection("chats")
    .orderBy("time",descending: false)
    //if occures any error
    .snapshots();
  }

  getChatRooms(String userName)async{
    return  FirebaseFirestore.instance.collection("ChatRoom")
    .where("users", arrayContains: userName)
    .snapshots();
  }
}
