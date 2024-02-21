

class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdOn;

  MessageModel(
      {this.messageid, this.sender, this.text, this.seen, this.createdOn});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map['messageid'];
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createdOn = map["createdon"]?.toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'messageid': messageid,
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdOn': createdOn
    };
  }
}
