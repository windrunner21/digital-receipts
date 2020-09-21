class MessagesList {
  final List<Message> messages;

  MessagesList({
    this.messages,
  });

  factory MessagesList.fromJson(List<dynamic> parsedJson) {
    List<Message> messages = new List<Message>();
    messages = parsedJson.map((i) => Message.fromJson(i)).toList();

    return new MessagesList(messages: messages);
  }
}

class Message {
  final String senderId;
  final String text;
  final int type;
  final String date;

  Message({this.senderId, this.text, this.type, this.date});

  factory Message.fromJson(Map<String, dynamic> json) {
    return new Message(
        senderId: json['senderId'],
        text: json['text'],
        type: json['type'],
        date: json['date']);
  }
}
