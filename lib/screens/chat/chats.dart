// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/helper/get_user_model.dart';
import 'package:pet_adoption_app/models/chat_room_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/chat/chat_room.dart';
import 'package:pet_adoption_app/screens/chat/search_page.dart';

class Chats extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const Chats({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Adoption Inquiry',
          style: TextStyle(fontFamily: 'AppFont', fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFE6E6FA),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participants.${widget.userModel.uName}",
                    isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot =
                      snapshot.data as QuerySnapshot;
                  print("Fetched chat rooms: ${chatRoomSnapshot.docs.length}");

                  if (chatRoomSnapshot.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No chats found!!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 134, 132, 132),
                          fontSize: 16,
                          fontFamily: 'AppFont',
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;

                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(widget.userModel.uName);
                      print(participantKeys);

                      return FutureBuilder(
                        future:
                            GetUserModel.getUserModelByName(participantKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserModel targetUser = userData.data as UserModel;
                              print("Target user name: ${targetUser.uName}");

                              return Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return ChatRoomPage(
                                            chatroom: chatRoomModel,
                                            firebaseUser: widget.firebaseUser,
                                            userModel: widget.userModel,
                                            targetUser: targetUser,
                                          );
                                        }),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(0),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlue,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(targetUser
                                                    .uProfile
                                                    .toString()),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  targetUser.uName.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'AppFont',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  (chatRoomModel.lastMessage
                                                              .toString() !=
                                                          "")
                                                      ? chatRoomModel
                                                          .lastMessage
                                                          .toString()
                                                      : "Say hi to your new friend!",
                                                  style: TextStyle(
                                                    color: (chatRoomModel
                                                                .lastMessage
                                                                .toString() !=
                                                            "")
                                                        ? Colors.grey
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    fontFamily: 'AppFont',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                ],
                              );
                            } else {
                              print("No data returned from FutureBuilder");
                              return Container();
                            }
                          } else {
                            print("FutureBuilder not completed");
                            return Container();
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No chats found. Start a conversation!",
                      style: TextStyle(fontFamily: 'MyFont', fontSize: 10),
                    ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(
                userModel: widget.userModel,
                user: widget.firebaseUser,
              ),
            ),
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
