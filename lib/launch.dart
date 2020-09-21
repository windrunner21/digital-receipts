import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';

class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    var greetings = "";
    int currentHour = new TimeOfDay.now().hour;

    if (currentHour >= 5 && currentHour <= 12) {
      greetings = "Morning";
    } else if (currentHour >= 13 && currentHour <= 17) {
      greetings = "Afternoon";
    } else if (currentHour >= 18 && currentHour <= 21) {
      greetings = "Evening";
    } else {
      greetings = "Night";
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/logo.png",
              height: 100,
              width: 100,
            ),
            Text(
              'Digital Receipts',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text(
                'Good ' + greetings,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
