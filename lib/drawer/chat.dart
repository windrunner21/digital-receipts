import 'package:flutter/material.dart';
import '../chatdetailed.dart';
import '../classes/chatShort.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../classes/chatProfile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool searchEnabled = false;
  bool undoPressed = false;
  List<String> options = ['Messages', 'Contacts', 'Archives'];
  int selectedIndex = 0;
  List<ChatProfile> favorites = [];

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
      return SizedBox.shrink();
    } else {
      return SizedBox.shrink();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(title: Text("Chats"), elevation: 0, actions: [
          Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      searchEnabled = !searchEnabled;
                    });
                  },
                  icon: Icon(searchEnabled ? Icons.cancel : Icons.search))),
        ]),
        body: Column(
          children: <Widget>[
            // just in case
            FutureBuilder<void>(future: _launched, builder: _launchStatus),
            // search
            Visibility(
                visible: searchEnabled,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        hintText: "Search",
                        isDense: true,
                        prefixIcon: Icon(Icons.search, color: Colors.black38),
                      ),
                    ))),
            // options
            Container(
              color: Colors.deepPurple,
              height: MediaQuery.of(context).size.height / 10,
              child: ListView.builder(
                itemCount: options.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          child: Text(options[index],
                              style: TextStyle(
                                  color: index == selectedIndex
                                      ? Colors.white
                                      : Colors.white60,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2))));
                },
              ),
            ),
            // favorite and chats
            FutureBuilder(
                future: getChatsShortInfo(selectedIndex == 0 ? false : true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // favorites loop adding and deleting
                    // updating undo in snackbar
                    undoPressed = false;
                    favorites.clear();
                    for (var chat in snapshot.data.chats) {
                      if (chat.isFavorite) {
                        ChatProfile profile = new ChatProfile(chat.chatName,
                            chat.photoIfExists, chat.id, chat.uid, chat.phone);

                        bool check = false;

                        for (var fav in favorites) {
                          if (fav.id == profile.id) {
                            check = true;
                            break;
                          }
                        }

                        if (!check) {
                          favorites.add(profile);
                        }
                      }
                    }

                    // sort by name
                    favorites.sort((a, b) => a.name[0].compareTo(b.name[0]));

                    return Expanded(
                        child: Column(children: [
                      // favorite
                      Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: selectedIndex == 2
                                      ? Text("Archived chats",
                                          style: TextStyle(
                                              letterSpacing: 1,
                                              color: Colors.blueGrey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))
                                      : Text("Favorite chats",
                                          style: TextStyle(
                                              letterSpacing: 1,
                                              color: Colors.blueGrey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                              Container(
                                  height: favorites.length == 0
                                      ? MediaQuery.of(context).size.height / 18
                                      : MediaQuery.of(context).size.height / 10,
                                  child: selectedIndex == 2
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          child: Text(
                                            "You can hide a conversation from your chats screen and access it later, if needed.",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                                fontStyle: FontStyle.italic,
                                                letterSpacing: 1),
                                          ))
                                      : favorites.length == 0
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 20),
                                              child: Text(
                                                "No favorite chats found. Swipe left to add a favorite chat.",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                    fontStyle: FontStyle.italic,
                                                    letterSpacing: 1),
                                              ))
                                          : ListView.builder(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: favorites.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ChatDetailedPage(
                                                                receiver:
                                                                    favorites[
                                                                            index]
                                                                        .name,
                                                                chatId: favorites[
                                                                        index]
                                                                    .id,
                                                                myId: favorites[
                                                                        index]
                                                                    .uid,
                                                                phone: favorites[
                                                                        index]
                                                                    .phone,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child:
                                                            Column(children: [
                                                          CircleAvatar(
                                                              child: Icon(Icons
                                                                  .person)),
                                                          SizedBox(height: 6.0),
                                                          Text(
                                                              favorites[index]
                                                                  .name,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        ])));
                                              },
                                            ))
                            ],
                          )),
                      // chats
                      selectedIndex == 0 || selectedIndex == 2
                          ? Expanded(
                              child: Container(
                                  color: Colors.white,
                                  child: ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.chats.length,
                                      padding: EdgeInsets.only(top: 6.0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Slidable(
                                            key: ValueKey(index),
                                            dismissal: SlidableDismissal(
                                              child: SlidableDrawerDismissal(),
                                              onDismissed: (actionType) {
                                                if (actionType ==
                                                    SlideActionType.primary) {
                                                  updateChat(
                                                      false,
                                                      false,
                                                      true,
                                                      true,
                                                      snapshot.data.chats[index]
                                                          .id);

                                                  if (!undoPressed) {
                                                    setState(() {});
                                                  }
                                                } else {
                                                  deleteChat(snapshot
                                                      .data.chats[index].id);

                                                  if (!undoPressed) {
                                                    setState(() {});
                                                  }
                                                }

                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                  duration: actionType ==
                                                          SlideActionType
                                                              .primary
                                                      ? const Duration(
                                                          seconds: 10)
                                                      : const Duration(
                                                          seconds: 10),
                                                  content: Text(
                                                      actionType ==
                                                              SlideActionType
                                                                  .primary
                                                          ? 'Chat archived'
                                                          : 'Chat Deleted',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  action: SnackBarAction(
                                                    label: 'Undo',
                                                    onPressed: () {
                                                      setState(() {
                                                        undoPressed = true;
                                                      });
                                                    },
                                                  ),
                                                ));
                                              },
                                            ),
                                            actionPane:
                                                SlidableDrawerActionPane(),
                                            actions: <Widget>[
                                              IconSlideAction(
                                                caption: snapshot.data
                                                        .chats[index].isArchived
                                                    ? 'Unarchive'
                                                    : 'Archive',
                                                color: Colors.grey[800],
                                                icon: snapshot.data.chats[index]
                                                        .isArchived
                                                    ? Icons.unarchive
                                                    : Icons.archive,
                                                onTap: () {
                                                  if (snapshot.data.chats[index]
                                                      .isArchived) {
                                                    updateChat(
                                                        false,
                                                        false,
                                                        true,
                                                        false,
                                                        snapshot.data
                                                            .chats[index].id);
                                                    setState(() {});
                                                  } else {
                                                    updateChat(
                                                        false,
                                                        false,
                                                        true,
                                                        true,
                                                        snapshot.data
                                                            .chats[index].id);

                                                    setState(() {});
                                                  }
                                                },
                                              ),
                                              IconSlideAction(
                                                caption: 'Call',
                                                color: Colors.green,
                                                icon: Icons.phone,
                                                onTap: () => setState(() {
                                                  _launched = _makePhoneCall(
                                                      'tel:${snapshot.data.chats[index].phone}');
                                                }),
                                              ),
                                            ],
                                            secondaryActions: <Widget>[
                                              IconSlideAction(
                                                caption: snapshot.data
                                                        .chats[index].isFavorite
                                                    ? 'Unfavorite'
                                                    : 'Favorite',
                                                color: Colors.blue,
                                                icon: snapshot.data.chats[index]
                                                        .isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                onTap: () {
                                                  if (snapshot.data.chats[index]
                                                      .isFavorite) {
                                                    updateChat(
                                                        true,
                                                        false,
                                                        false,
                                                        false,
                                                        snapshot.data
                                                            .chats[index].id);
                                                    setState(() {});
                                                  } else {
                                                    updateChat(
                                                        true,
                                                        true,
                                                        false,
                                                        false,
                                                        snapshot.data
                                                            .chats[index].id);

                                                    setState(() {});
                                                  }
                                                },
                                              ),
                                              IconSlideAction(
                                                caption: 'Delete',
                                                color: Colors.red,
                                                icon: Icons.delete,
                                                onTap: () {
                                                  deleteChat(snapshot
                                                      .data.chats[index].id);
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                child: snapshot
                                                            .data
                                                            .chats[index]
                                                            .photoIfExists ==
                                                        null
                                                    ? Icon(Icons.person)
                                                    : Image.asset(
                                                        "assets/profile.png",
                                                        height: 100,
                                                        width: 100,
                                                      ),
                                              ),
                                              title: Text(snapshot
                                                  .data.chats[index].chatName),
                                              subtitle: Text(snapshot.data
                                                  .chats[index].lastMessage),
                                              trailing: Text(formatDate(snapshot
                                                  .data
                                                  .chats[index]
                                                  .timeOrDate)),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatDetailedPage(
                                                      receiver: snapshot
                                                          .data
                                                          .chats[index]
                                                          .chatName,
                                                      chatId: snapshot
                                                          .data.chats[index].id,
                                                      myId: snapshot.data
                                                          .chats[index].uid,
                                                      phone: snapshot.data
                                                          .chats[index].phone,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ));
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          indent: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5,
                                          color: Colors.grey[350],
                                          height: 0,
                                        );
                                      })))
                          : Expanded(
                              child: Container(
                                  color: Colors.white,
                                  child: ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.chats.length,
                                      padding: EdgeInsets.only(top: 6.0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        bool newGroup = false;

                                        if (index == 0) {
                                          newGroup = true;
                                        } else {
                                          if (snapshot.data.chats[index]
                                                  .chatName[0] !=
                                              snapshot.data.chats[index - 1]
                                                  .chatName[0]) {
                                            newGroup = true;
                                          } else {
                                            newGroup = false;
                                          }
                                        }

                                        return Column(children: [
                                          newGroup
                                              ? Container(
                                                  color: Colors.grey.shade300,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 30),
                                                  child: Text(
                                                    snapshot.data.chats[index]
                                                        .chatName[0],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ))
                                              : SizedBox.shrink(),
                                          ListTile(
                                            leading: CircleAvatar(
                                              child: snapshot.data.chats[index]
                                                          .photoIfExists ==
                                                      null
                                                  ? Icon(Icons.person)
                                                  : Image.asset(
                                                      "assets/profile.png",
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                            ),
                                            title: Text(snapshot
                                                .data.chats[index].chatName),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatDetailedPage(
                                                    receiver: snapshot.data
                                                        .chats[index].chatName,
                                                    chatId: snapshot
                                                        .data.chats[index].id,
                                                    myId: snapshot
                                                        .data.chats[index].uid,
                                                    phone: snapshot.data
                                                        .chats[index].phone,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ]);
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          indent: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5,
                                          color: Colors.grey[350],
                                          height: 0,
                                        );
                                      })))
                    ]));
                  } else {
                    return Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 4),
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.white));
                  }
                }),
          ],
        ));
  }

  Future<ChatShortList> getChatsShortInfo(archived) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userid = user.uid;

    if (user != null) {
      var url = 'http://34.90.131.200:3000/conversation/find';

      Map data;
      if (archived) {
        data = {"uid": userid, "archived": true};
      } else {
        data = {"uid": userid};
      }

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      List<dynamic> chatsMap = jsonDecode(response.body);

      for (var item in chatsMap) {
        item.putIfAbsent("uid", () => userid);
      }

      var chats = ChatShortList.fromJson(chatsMap);

      return chats;
    }
    return null;
  }
}

Future<void> updateChat(
    favoriteOption, favoriteValue, archiveOption, arciveValue, id) async {
  if (favoriteOption) {
    var url = 'http://34.90.131.200:3000/conversation/update';

    Map data = {"id": id, "isFavorite": favoriteValue};

    var body = json.encode(data);
    await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
  }

  if (archiveOption) {
    var url = 'http://34.90.131.200:3000/conversation/update';

    Map data = {"id": id, "isArchived": arciveValue};

    var body = json.encode(data);
    await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
  }
}

Future<void> deleteChat(id) async {
  var url = 'http://34.90.131.200:3000/conversation/delete';

  Map data = {"id": id};

  var body = json.encode(data);
  await http.post(url,
      headers: {"Content-Type": "application/json"}, body: body);
}

String formatDate(date) {
  date = date.split("T")[0];
  if (date.contains("-")) {
    var today = DateTime.now().toString().split(" ")[0];

    if (date.split("-")[0] == today.split("-")[0] &&
        date.split("-")[1] == today.split("-")[1]) {
      var todaysDate = int.parse(today.split("-")[2]);
      var incomingDate = int.parse(date.split("-")[2]);

      if (todaysDate - incomingDate >= 7) {
        return date.split("-")[2] +
            "." +
            date.split("-")[1] +
            "." +
            date.split("-")[0].substring(2, 4);
      } else {
        if (todaysDate - incomingDate == 1) {
          return "Yesterday";
        } else if (todaysDate - incomingDate == 2) {
          return getWeekday(DateTime.parse(date).weekday);
        } else if (todaysDate - incomingDate == 3) {
          return getWeekday(DateTime.parse(date).weekday);
        } else if (todaysDate - incomingDate == 4) {
          return getWeekday(DateTime.parse(date).weekday);
        } else if (todaysDate - incomingDate == 5) {
          return getWeekday(DateTime.parse(date).weekday);
        } else if (todaysDate - incomingDate == 6) {
          return getWeekday(DateTime.parse(date).weekday);
        }
      }
      return date.split("-")[2] +
          "." +
          date.split("-")[1] +
          "." +
          date.split("-")[0].substring(2, 4);
    }
  }
  return date;
}

String getWeekday(index) {
  if (index == 1) {
    return "Mon";
  } else if (index == 2) {
    return "Tue";
  } else if (index == 3) {
    return "Wed";
  } else if (index == 4) {
    return "Thu";
  } else if (index == 5) {
    return "Fri";
  } else if (index == 6) {
    return "Sat";
  } else {
    return "Sun";
  }
}
