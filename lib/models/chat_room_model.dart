class ChatRoomModel {
  String? chatRoomID;
  //map - b'coz when someone block then we change value false
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatRoomModel({this.chatRoomID, this.participants, this.lastMessage});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomID = map["chatRoomID"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatRoomID": chatRoomID,
      "participants": participants,
      "lastmessage": lastMessage
    };
  }
}
