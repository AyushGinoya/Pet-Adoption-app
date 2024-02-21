import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_adoption_app/main.dart';
import 'package:pet_adoption_app/models/chat_room_model.dart';
import 'package:pet_adoption_app/models/message_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({
    Key? key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        createdOn: DateTime.now(),
        seen: false,
        sender: widget.userModel.uName,
        text: msg,
        messageid: uuid.v1(),
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomID)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomID)
          .set(widget.chatroom.toMap());

      log("Message sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 224, 84),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage:
                  NetworkImage(widget.targetUser.uProfile.toString()),
            ),
            const SizedBox(width: 15),
            Text(widget.targetUser.uName.toString()),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatroom.chatRoomID)
                      .collection("messages")
                      .orderBy("createdOn", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>,
                            );
                            return Row(
                              mainAxisAlignment: currentMessage.sender ==
                                      widget.userModel.uName
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    color: currentMessage.sender ==
                                            widget.userModel.uName
                                        ? Colors.blue[200]
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                              "Error occurred, please check your internet connection."),
                        );
                      } else {
                        return const Center(
                          child: Text("Say hi to the owner of the pet."),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Enter message"),
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send,
                        color: Color.fromARGB(255, 240, 224, 84)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
