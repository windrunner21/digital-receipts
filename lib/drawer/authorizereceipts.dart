import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../classes/receiptShort.dart';
import '../classes/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthorizeReceiptsPage extends StatefulWidget {
  @override
  _AuthorizeReceiptsPageState createState() => _AuthorizeReceiptsPageState();
}

class _AuthorizeReceiptsPageState extends State<AuthorizeReceiptsPage> {
  var listOfNamesTemp = [
    'Imran Hajiyev',
    'Kanan Asadov',
    'Ali Orujaliyev',
    'Mina Silahtaroglu',
    'Bagdagul Badgadulova',
    'Shahriyar Atababayev',
    'Shahriyar Mammadil',
    'Qondon Sherstanoy',
    'Skye Meowscles',
    'Anakin Skywalker',
    'Darth Vader',
    'Deadpool',
    'Monica Belucci',
    'Maksim Qalkin',
    'Valeriy Marmeladze',
    'Filipp Kirkorovka',
    'Aslan Sirli',
    'Muhammed the Mountain',
    'Harvey Specter',
    'Bobby Axelrod',
    'Ahsoka Tano',
    'Rey Shluxa',
    'Koqo Ebet',
    'Cto Idetdalshe',
    'Nikoqo Neebet',
    'Idite Naxuy',
    'Vikto Takie',
    'Yavas Nezval'
  ];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Authorize Receipts")),
        body: FutureBuilder(
            future: getUserFromDatabase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return FutureBuilder(
                    future: getReceiptsShortInfo(snapshot.data.pin),
                    builder: (context, receiptsSnapshot) {
                      if (receiptsSnapshot.connectionState ==
                          ConnectionState.done) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: receiptsSnapshot.data.receipts.length,
                          padding: EdgeInsets.only(top: 6.0),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: [
                              Column(children: [
                                Divider(color: Colors.grey[600]),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            formatDate(
                                                getDate(receiptsSnapshot
                                                    .data.receipts[index].date),
                                                true),
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700])),
                                        Text(
                                            listOfNamesTemp[index] != null
                                                ? listOfNamesTemp[index]
                                                : "Name Surname",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700]))
                                      ],
                                    )),
                                Divider(color: Colors.grey[600])
                              ]),
                              Card(
                                elevation: 10.0,
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Colors.deepPurple[400],
                                              Colors.deepPurpleAccent
                                            ]),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ListTile(
                                        onTap: () {},
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        leading: Container(
                                          padding: EdgeInsets.only(right: 12.0),
                                          decoration: new BoxDecoration(
                                              border: new Border(
                                                  right: new BorderSide(
                                                      width: 1.0,
                                                      color: Colors.white24))),
                                          child: getIconByCategory(
                                              receiptsSnapshot.data
                                                  .receipts[index].category),
                                        ),
                                        title: Text(
                                          receiptsSnapshot
                                              .data.receipts[index].category,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                            receiptsSnapshot.data
                                                .receipts[index].companyName
                                                .toUpperCase(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                        trailing: Text(
                                            receiptsSnapshot.data.receipts[index].totalPrice.toStringAsFixed(2) +
                                                " ₼",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)))),
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      RaisedButton.icon(
                                        icon: Icon(Icons.check_circle,
                                            color: Colors.white),
                                        color: Colors.green,
                                        elevation: 8,
                                        label: Text(
                                          "Authorize",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          print("authorized");
                                        },
                                      ),
                                      Container(
                                        width: 1,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                35,
                                        color: Colors.grey,
                                      ),
                                      RaisedButton.icon(
                                        icon: Icon(Icons.cancel,
                                            color: Colors.white),
                                        color: Colors.red,
                                        elevation: 8,
                                        label: Text(
                                          "Decline",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          print("declined");
                                        },
                                      )
                                    ],
                                  )),
                              Divider(color: Colors.grey[600])
                            ]);
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<User> getUnapproved() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userid = user.uid;

    if (user != null) {
      var url = 'http://34.90.131.200:3000/getUnapproved';

      Map data = {
        "id": userid,
      };

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      Map userMap = jsonDecode(response.body);
      var userFromJson = User.fromJson(userMap);

      return userFromJson;
    }
    return null;
  }

  Future<int> acceptOrDecline(isAccepted) async {
    var url;

    if (isAccepted) {
      url = 'http://34.90.131.200:3000/receipt/approve';
    } else {
      url = 'http://34.90.131.200:3000/receipt/decline';
    }

    Map data = {};

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    return response.statusCode;
  }

  Future<ReceiptsShortList> getReceiptsShortInfo(pinCode) async {
    var url = 'http://34.90.131.200:3000/receipt/find';

    Map data = {
      "pin": pinCode,
    };

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    List<dynamic> receiptsMap = jsonDecode(response.body);
    var receipts = ReceiptsShortList.fromJson(receiptsMap);

    return receipts;
  }

  Future<User> getUserFromDatabase() async {
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
      var userFromJson = User.fromJson(userMap);

      return userFromJson;
    }
    return null;
  }

  Image getIconByCategory(category) {
    double width = 25;
    double height = 25;

    if (category == "Restaurants & Food") {
      return Image.asset("assets/food.png",
          width: width, height: height, color: Colors.white);
    } else if (category == "Health") {
      return Image.asset("assets/health.png",
          width: width, height: height, color: Colors.white);
    } else {
      return Image.asset("assets/grocery.png",
          width: width, height: height, color: Colors.white);
    }
  }

  String getDate(issueDate) {
    var issueArray = issueDate.split("T");
    var date = issueArray[0].split('-');

    return date[2] + "." + date[1] + "." + date[0];
  }

  String formatDate(date, dayOrMonth) {
    var dateArray = date.split('.');
    var month;

    if (dateArray[1] == '01') {
      month = " January";
    } else if (dateArray[1] == '02') {
      month = " February";
    } else if (dateArray[1] == '03') {
      month = " March";
    } else if (dateArray[1] == '04') {
      month = " April";
    } else if (dateArray[1] == '05') {
      month = " May";
    } else if (dateArray[1] == '06') {
      month = " June";
    } else if (dateArray[1] == '07') {
      month = " July";
    } else if (dateArray[1] == '08') {
      month = " August";
    } else if (dateArray[1] == '09') {
      month = " September";
    } else if (dateArray[1] == '10') {
      month = " October";
    } else if (dateArray[1] == '11') {
      month = " November";
    } else {
      month = " December";
    }

    if (dayOrMonth) {
      return dateArray[0] + month + ', ' + dateArray[2];
    } else {
      return month + ', ' + dateArray[2];
    }
  }
}
