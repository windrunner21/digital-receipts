class ChatShortList {
  final List<ChatShort> chats;

  ChatShortList({
    this.chats,
  });

  factory ChatShortList.fromJson(List<dynamic> parsedJson) {
    List<ChatShort> chats = new List<ChatShort>();
    chats = parsedJson.map((i) => ChatShort.fromJson(i)).toList();

    return new ChatShortList(chats: chats);
  }
}

class ChatShort {
  final String id;
  final String chatName;
  final String lastMessage;
  final String timeOrDate;
  final String photoIfExists;
  final bool hasBeenRead;
  final bool isFavorite;
  final bool isArchived;
  final String uid;
  final String phone;

  ChatShort(
      {this.id,
      this.chatName,
      this.lastMessage,
      this.timeOrDate,
      this.photoIfExists,
      this.hasBeenRead,
      this.isFavorite,
      this.isArchived,
      this.uid,
      this.phone});

  factory ChatShort.fromJson(Map<String, dynamic> json) {
    return new ChatShort(
        id: json['_id'],
        chatName: json['chatName'],
        lastMessage: json['lastMessage'],
        timeOrDate: json['time'],
        photoIfExists: json['profilePhotoURL'],
        hasBeenRead: json['hasBeenRead'],
        isFavorite: json['isFavorite'],
        isArchived: json['isArchived'],
        uid: json["uid"],
        phone: json["phoneNumber"]);
  }
}
