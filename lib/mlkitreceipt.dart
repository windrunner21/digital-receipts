import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dashboard.dart';
import 'drawer/addreceipts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'classes/user.dart';

class MLKITReceiptPage extends StatefulWidget {
  @override
  _MLKITReceiptPageState createState() => _MLKITReceiptPageState();

  final Map<String, Object> processedText;

  MLKITReceiptPage({Key key, this.processedText}) : super(key: key);
}

class _MLKITReceiptPageState extends State<MLKITReceiptPage> {
  Future<void> _launched;

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    const String toLaunch = 'https://www.google.com/';
    return Scaffold(
        appBar: AppBar(
          title: Text("Digital Receipt Result"),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                Colors.deepPurpleAccent,
                Colors.deepPurple[400]
              ]))),
          elevation: 0.0,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: IconButton(
                  onPressed: () => setState(() {
                    _launched = _launchInWebViewWithJavaScript(toLaunch);
                  }),
                  icon: Icon(Icons.devices),
                ))
          ],
        ),
        body: ListView(shrinkWrap: true, children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                    Colors.deepPurple[400],
                    Colors.deepPurpleAccent
                  ])),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: Column(children: <Widget>[
                    Container(
                        width: double.infinity,
                        child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              widget.processedText['companyName']
                                  .toString()
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold),
                            )),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 3,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(5))),
                    CustomPaint(
                      painter: MyPainter(),
                      child: Center(),
                    )
                  ]))),
          Padding(
              padding: EdgeInsets.fromLTRB(40, 10, 30, 10),
              child: Column(
                children: <Widget>[
                  // divider
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(color: Colors.grey)),
                  Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(
                                          width: 1.0, color: Colors.black))),
                              child: getIconByCategory("Restaurants & Food"),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 22.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        widget.processedText['city'].toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          getDate(widget
                                              .processedText['issueDate']
                                              .toString()),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 7.5),
                                            child: Text(
                                              getTime(widget
                                                  .processedText['issueDate']
                                                  .toString()),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ))
                                      ],
                                    )
                                  ],
                                ))
                          ])),
                  // divider
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(color: Colors.grey)),
                  Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Row(
                        children: <Widget>[
                          Text("Type: ", style: TextStyle(fontSize: 16)),
                          Text(widget.processedText['receiptType'].toString(),
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54))
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 12, top: 5, bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Text("Payment: ", style: TextStyle(fontSize: 16)),
                          Text(
                              widget.processedText['paymentTypeNote']
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54))
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Row(
                        children: <Widget>[
                          Text("ETTN: ", style: TextStyle(fontSize: 16)),
                          Expanded(
                              child: Text(
                                  widget.processedText['ettn'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54)))
                        ],
                      )),
                  // divider
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(color: Colors.grey)),
                  for (var item in widget.processedText['items'])
                    ListTile(
                        leading: Text(
                          "x" + item['amount'].toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        title: Text(
                          item['name'],
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Text(
                            item['priceWithoutTax'].toStringAsFixed(2) + " ₼",
                            style: TextStyle(
                              fontSize: 16,
                            ))),
                  // divider
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(color: Colors.grey)),
                  Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Total Tax [%8]",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                              widget.processedText['totalKDV'].toString() +
                                  " ₼",
                              style: TextStyle(fontSize: 18))
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Total Price",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                              double.parse(widget.processedText['totalPrice']
                                          .toString())
                                      .toStringAsFixed(2) +
                                  " ₼",
                              style: TextStyle(fontSize: 18))
                        ],
                      )),
                  // divider
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(color: Colors.grey)),
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text("Add resulted digital receipt?",
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton.icon(
                        icon: Icon(Icons.check_circle, color: Colors.white),
                        color: Colors.green,
                        elevation: 8,
                        label: Text(
                          "Approve",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          addMLKITReceipt();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardPage()),
                          );
                        },
                      ),
                      RaisedButton.icon(
                        icon: Icon(Icons.cancel, color: Colors.white),
                        color: Colors.red,
                        elevation: 8,
                        label: Text(
                          "Reject",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddReceiptsPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  // divider
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(color: Colors.grey)),
                  FutureBuilder<void>(
                      future: _launched, builder: _launchStatus),
                ],
              ))
        ]));
  }

  Future<int> addMLKITReceipt() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userid = user.uid;
    var pinCode = -1;

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

      pinCode = userFromJson.pin;
    }

    var url = 'http://34.90.131.200:3000/receipt/add-json';

    Map data = {"receipt": widget.processedText, "pin": pinCode};

    print(widget.processedText);

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    print(response.body);

    return response.statusCode;
  }
}

String getDate(issueDate) {
  var issueArray = issueDate.split("T");
  var date = issueArray[0].split('-');

  return date[2] + "." + date[1] + "." + date[0];
}

String getTime(issueDate) {
  var issueArray = issueDate.split("T");
  var time = issueArray[1].split(":");

  return time[0] + ":" + time[1];
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;

    final double length = size.width;
    final double spacing = length / (33 * 2.0);
    final Path path = Path()..moveTo(0, -7);
    for (int index = 0; index < 33; index += 1) {
      final double x = (index * 2.0 + 1.0) * spacing;
      final double y = 5 * ((index % 2.0) * 2.0 - 1.0);
      path.lineTo(x, y);
    }
    path.lineTo(length, -7);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

Image getIconByCategory(category) {
  double width = 30;
  double height = 30;

  if (category == "Restaurants & Food") {
    return Image.asset("assets/food.png", width: width, height: height);
  } else if (category == "Health") {
    return Image.asset("assets/health.png", width: width, height: height);
  } else if (category == "Restaurants & Food") {
    return Image.asset("assets/restaurants.png", width: width, height: height);
  } else {
    return Image.asset("assets/grocery.png", width: width, height: height);
  }
}
