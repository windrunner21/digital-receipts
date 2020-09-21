import 'package:flutter/material.dart';
import '../statisticsdetailed.dart';
import '../statisticsdetailed2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../classes/user.dart';
import '../classes/statisticsShort.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int myLimit = 2000;
  TextEditingController controller = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Facts & Figures")),
      body: Padding(
          padding: EdgeInsets.all(12),
          child: FutureBuilder(
            future: getShortStatistics(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(children: <Widget>[
                  Divider(color: Colors.grey),
                  Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                      child: Text("Expense Limit",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                  Divider(color: Colors.grey),
                  Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: ListTile(
                          leading: Image.asset("assets/limit.png"),
                          title: Text("Current Limit",
                              style: TextStyle(color: Colors.grey[600])),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FutureBuilder(
                                    future: getLimit(),
                                    initialData: "Loading",
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> text) {
                                      return Text(text.data + " ₼",
                                          style: TextStyle(
                                              letterSpacing: 1,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25));
                                    }),
                                Text("For this month",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        letterSpacing: 1)),
                              ]),
                          trailing: Icon(Icons.edit, color: Colors.black),
                          onTap: () {
                            _settingModalBottomSheet(context);
                          }),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[350]),
                          borderRadius: BorderRadius.circular(5))),
                  Divider(color: Colors.grey),
                  Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                      child: Text("Statistics",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                  Divider(color: Colors.grey),
                  Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: ListTile(
                          leading: Image.asset("assets/totalExpenses.png"),
                          title: Text("Total Expenses",
                              style: TextStyle(color: Colors.grey[600])),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    snapshot.data.totalExpenses
                                            .toStringAsFixed(2) +
                                        " ₼",
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                                Text("For this month",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        letterSpacing: 1)),
                              ]),
                          trailing:
                              Icon(Icons.navigate_next, color: Colors.black),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StatisticsDetailedPage(
                                  statisticsType: 0,
                                  pinCode: snapshot.data.pinCode,
                                ),
                              ),
                            );
                          }),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[350]),
                          borderRadius: BorderRadius.circular(5))),
                  Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: ListTile(
                          leading: Image.asset("assets/totalReceipts.png"),
                          title: Text("Total Receipts",
                              style: TextStyle(color: Colors.grey[600])),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(snapshot.data.receiptNumber.toString(),
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                                Text("For this month",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        letterSpacing: 1)),
                              ]),
                          trailing:
                              Icon(Icons.navigate_next, color: Colors.black),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StatisticsDetailedPage(
                                  statisticsType: 1,
                                  pinCode: snapshot.data.pinCode,
                                ),
                              ),
                            );
                          }),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[350]),
                          borderRadius: BorderRadius.circular(5))),
                  Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: ListTile(
                          leading: Image.asset("assets/item.png"),
                          title: Text("My favourite item",
                              style: TextStyle(color: Colors.grey[600])),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(snapshot.data.item,
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                                Text("For this month",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        letterSpacing: 1)),
                              ]),
                          trailing:
                              Icon(Icons.navigate_next, color: Colors.black),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StatisticsDetailedPage2(
                                  statisticsType: 0,
                                  pinCode: snapshot.data.pinCode,
                                ),
                              ),
                            );
                          }),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[350]),
                          borderRadius: BorderRadius.circular(5))),
                  Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      child: ListTile(
                          leading: Image.asset("assets/place.png"),
                          title: Text("My favourite place",
                              style: TextStyle(color: Colors.grey[600])),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(snapshot.data.companyName,
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                                Text("For this month",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        letterSpacing: 1)),
                              ]),
                          trailing:
                              Icon(Icons.navigate_next, color: Colors.black),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StatisticsDetailedPage2(
                                  statisticsType: 1,
                                  pinCode: snapshot.data.pinCode,
                                ),
                              ),
                            );
                          }),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[350]),
                          borderRadius: BorderRadius.circular(5))),
                  Divider(color: Colors.grey),
                  Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                      child: Text("Analytics",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                  Divider(color: Colors.grey)
                ]);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.only(top: 20, left: 50, right: 50),
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      hintText: "Set a new expense limit",
                      suffix: Text("₼"),
                      isDense: true),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: RaisedButton(
                    color: Colors.deepPurple,
                    child: Text(
                      "ACCEPT",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        myLimit = int.parse(controller.text);
                      });
                      updateUser(int.parse(controller.text));
                      controller.clear();
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<String> getLimit() async {
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
      String name = User.fromJson(userMap).limit.toStringAsFixed(2);

      return name;
    }
    return null;
  }

  Future<int> updateUser(value) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userid = user.uid;

    if (user != null) {
      var url = 'http://34.90.131.200:3000/user/update';

      Map data = {"id": userid, "expenseLimit": value};

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      return response.statusCode;
    }
    return 0;
  }

  Future<StatisticsShort> getShortStatistics() async {
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
      int pin = User.fromJson(userMap).pin;

      var url2 = 'http://34.90.131.200:3000/user/statistics';

      Map data2 = {
        "pin": pin,
      };

      var body2 = json.encode(data2);
      var response2 = await http.post(url2,
          headers: {"Content-Type": "application/json"}, body: body2);

      Map statisticsShortMap = jsonDecode(response2.body);

      statisticsShortMap.putIfAbsent("pin", () => pin);

      var statisticsShortfromJson =
          StatisticsShort.fromJson(statisticsShortMap);

      return statisticsShortfromJson;
    }
    return null;
  }
}
