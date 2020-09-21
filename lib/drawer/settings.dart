import 'package:flutter/material.dart';
import '../usersettings.dart';
import 'dart:convert';
import '../classes/user.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool language = true;
  bool darkMode = false;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Padding(
            padding: EdgeInsets.only(top: 20),
            child: ListView(
              children: <Widget>[
                Divider(color: Colors.grey),
                ListTile(
                  leading: CircleAvatar(
                    radius: 35,
                    child: Image.asset(
                      "assets/profile.png",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  title: FutureBuilder(
                      future: getName(),
                      initialData: "Loading",
                      builder:
                          (BuildContext context, AsyncSnapshot<String> text) {
                        return Text(text.data,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20));
                      }),
                  subtitle: Text("Edit profile"),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSettingsPage(),
                      ),
                    );
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Divider(color: Colors.grey)),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Divider(color: Colors.grey)),
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Colors.deepPurple,
                  ),
                  title: Text('Language'),
                  onTap: () {
                    setState(() {
                      language = !language;
                    });
                  },
                  trailing: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text: "EN",
                            style: TextStyle(
                                fontWeight: language
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        TextSpan(text: " / "),
                        TextSpan(
                            text: "TR",
                            style: TextStyle(
                                fontWeight: language
                                    ? FontWeight.normal
                                    : FontWeight.bold))
                      ])),
                ),
                Divider(color: Colors.grey),
                ListTile(
                  leading: Icon(Icons.invert_colors, color: Colors.deepPurple),
                  title: Text('Dark Mode'),
                  trailing: Switch(
                    value: darkMode,
                    onChanged: (value) {
                      setState(() {
                        darkMode = !darkMode;
                      });
                    },
                  ),
                ),
                Divider(color: Colors.grey)
              ],
            )));
  }
}

Future<String> getName() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  final userid = user.uid;

  if (user != null) {
    var url = 'http://34.90.131.200:3000/user/findById';

    Map data = {
      "id": userid,
    };

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    Map userMap = jsonDecode(response.body);
    String name = User.fromJson(userMap).firstName;
    String surname = User.fromJson(userMap).lastName;

    return name + " " + surname;
  }
  return null;
}
