import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'classes/chatDetailed.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

_ChatDetailedPageState chatState;

class ChatDetailedPage extends StatefulWidget {
  @override
  _ChatDetailedPageState createState() => _ChatDetailedPageState();

  final String receiver;
  final String chatId;
  final String myId;
  final String phone;

  ChatDetailedPage({Key key, this.receiver, this.chatId, this.myId, this.phone})
      : super(key: key);
}

class _ChatDetailedPageState extends State<ChatDetailedPage>
    with TickerProviderStateMixin {
  var messages = [];
  Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  Widget build(BuildContext context) {
    chatState = this;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.receiver),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: IconButton(
                  onPressed: () => setState(() {
                    _launched = _makePhoneCall('tel:${widget.phone}');
                  }),
                  icon: Icon(Icons.phone),
                )),
          ],
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FutureBuilder<void>(future: _launched, builder: _launchStatus),
              FutureBuilder(
                  future: getMessages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Flexible(
                        child: ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          reverse: true,
                          itemBuilder: (_, int index) => messages[index],
                          itemCount: messages.length,
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              Divider(height: 1.0),
              MessagePanel(chatId: widget.chatId, myId: widget.myId),
            ]));
  }

  @override
  void dispose() {
    for (ChatMessage message in messages) message.animationController.dispose();
    super.dispose();
  }

  Future<MessagesList> getMessages() async {
    var url = 'http://34.90.131.200:3000/conversation/getMessages';

    Map data = {"id": widget.chatId, "who": "user", "n": 1};

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    List<dynamic> messagesMap = jsonDecode(response.body);

    var messagesDB = MessagesList.fromJson(messagesMap);

    messages.clear();
    for (var item in messagesDB.messages) {
      ChatMessage message = new ChatMessage(
        name: item.senderId == widget.myId ? "Me" : widget.receiver,
        text: item.text,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 250),
          vsync: this,
        ),
        receivedMessage: !(item.senderId == widget.myId),
      );

      messages.insert(0, message);
      message.animationController.forward();
    }

    return messagesDB;
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.name, this.text, this.animationController, this.receivedMessage});
  final String name;
  final String text;
  final AnimationController animationController;
  final bool receivedMessage;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: receivedMessage
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              receivedMessage
                  ? Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      child: CircleAvatar(child: Text(name[0])))
                  : Container(),
              Expanded(
                  child: Bubble(
                child: Column(
                  crossAxisAlignment: receivedMessage
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17)),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: Text(text,
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    )
                  ],
                ),
                color: receivedMessage ? Colors.grey : Colors.deepPurple[400],
                elevation: 4,
                padding: BubbleEdges.fromLTRB(12, 8, 12, 8),
                alignment:
                    receivedMessage ? Alignment.topLeft : Alignment.topRight,
                nip: receivedMessage ? BubbleNip.leftTop : BubbleNip.rightTop,
                radius: Radius.circular(15.0),
              )),
              !receivedMessage
                  ? Container(
                      margin: const EdgeInsets.only(left: 16.0),
                      child: CircleAvatar(child: Text(name[0])))
                  : Container()
            ],
          ),
        ));
  }
}

class MessagePanel extends StatefulWidget {
  @override
  _MessagePanelState createState() => _MessagePanelState();

  final String chatId;
  final String myId;

  MessagePanel({Key key, this.chatId, this.myId}) : super(key: key);
}

class _MessagePanelState extends State<MessagePanel>
    with TickerProviderStateMixin {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor),
        padding: EdgeInsets.only(bottom: 30, top: 15),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Transform.rotate(
                      angle: 120,
                      child: Icon(Icons.attach_file, color: Colors.grey)),
                  onPressed: () {}),
            ),
            Flexible(
              child: TextField(
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Send a message",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0))),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send,
                      color: _isComposing ? Colors.deepPurple : Colors.grey),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null),
            ),
          ],
        ));
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    sendMessage(text);

    chatState.setState(() {});
  }

  Future<void> sendMessage(text) async {
    var url = 'http://34.90.131.200:3000/conversation/sendMessage';

    Map data = {
      "id": widget.chatId,
      "message": {"senderId": widget.myId, "text": text}
    };

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    print(response.statusCode);
  }
}
