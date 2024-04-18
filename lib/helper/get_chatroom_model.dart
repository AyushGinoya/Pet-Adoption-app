import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption_app/main.dart';
import 'package:pet_adoption_app/models/chat_room_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';

class GetChatRoom {
  static Future<ChatRoomModel?> getChatRoomModel(
      UserModel targetModel, UserModel userModel) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${userModel.uName}", isEqualTo: true)
        .where("participants.${targetModel.uName}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs.first.data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatRoom;
    } else {
      ChatRoomModel chatRoomModel = ChatRoomModel(
        chatRoomID: uuid.v1(),
        lastMessage: "",
        participants: {
          userModel.uName.toString(): true,
          targetModel.uName.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomModel.chatRoomID)
          .set(chatRoomModel.toMap());
      log("New chatRoom created");

      chatRoom = chatRoomModel;
    }

    return chatRoom;
  }
}
