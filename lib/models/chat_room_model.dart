// ignore_for_file: file_names

class ChatRoomModel {
  String? chatRoomID;
  List<String>? participants;

  ChatRoomModel({this.chatRoomID, this.participants});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomID = map["chatRoomID"];
    participants = map["participants"];
  }

  Map<String, dynamic> toMap() {
    return {"chatRoomID": chatRoomID, "participants": participants};
  }
}
