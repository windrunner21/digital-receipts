import 'package:flutter/material.dart';
import '../filters/couponsfilter.dart';
import '../classes/coupons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CouponsPage extends StatefulWidget {
  @override
  _CouponsPageState createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Coupons & Vouchers"),
          elevation: 0,
        ),
        body: Column(children: <Widget>[
          Container(
            color: Colors.deepPurple,
            child: Row(
              children: <Widget>[
                Expanded(
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
                            prefixIcon:
                                Icon(Icons.search, color: Colors.black38),
                          ),
                        ))),
                FlatButton(
                  child: Text(
                    "Filter",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CouponsFilterPage()));
                  },
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: getCoupons(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.coupons.length,
                        padding: EdgeInsets.only(top: 6.0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Container(
                                child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(30, 10, 30, 10),
                                    child: Column(children: <Widget>[
                                      Container(
                                          width: double.infinity,
                                          child: Padding(
                                              padding: EdgeInsets.all(12),
                                              child: Text(
                                                snapshot.data.coupons[index]
                                                    .storeName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    letterSpacing: 2,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                left: BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                right: BorderSide(
                                                    color: Colors.black,
                                                    width: 2)),
                                          )),
                                      CustomPaint(
                                        painter: MyPainter(),
                                        child: Center(),
                                      ),
                                      Container(
                                          width: double.infinity,
                                          child: Padding(
                                              padding: EdgeInsets.all(25),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    RichText(
                                                        text: TextSpan(
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      children: [
                                                        TextSpan(
                                                            text: snapshot
                                                                        .data
                                                                        .coupons[
                                                                            index]
                                                                        .price >
                                                                    0
                                                                ? snapshot
                                                                        .data
                                                                        .coupons[
                                                                            index]
                                                                        .price
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    " ₼"
                                                                : "FREE",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 24)),
                                                        TextSpan(
                                                            text: snapshot
                                                                        .data
                                                                        .coupons[
                                                                            index]
                                                                        .price >
                                                                    0
                                                                ? " OFF"
                                                                : "",
                                                            style: TextStyle(
                                                                fontSize: 16))
                                                      ],
                                                    )),
                                                    Text(snapshot
                                                        .data
                                                        .coupons[index]
                                                        .description
                                                        .toUpperCase())
                                                  ])),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                left: BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                right: BorderSide(
                                                    color: Colors.black,
                                                    width: 2)),
                                          )),
                                      CustomPaint(
                                        painter: MyPainter(),
                                        child: Center(),
                                      ),
                                      Container(
                                          width: double.infinity,
                                          child: Padding(
                                              padding: EdgeInsets.all(12),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    RichText(
                                                        text: TextSpan(
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black),
                                                            children: [
                                                          TextSpan(
                                                              text:
                                                                  "Active Period: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          TextSpan(
                                                              text: getDate(
                                                                      snapshot
                                                                          .data
                                                                          .coupons[
                                                                              index]
                                                                          .startDate) +
                                                                  formatDate(snapshot
                                                                      .data
                                                                      .coupons[
                                                                          index]
                                                                      .startDate) +
                                                                  "., " +
                                                                  getTime(snapshot
                                                                      .data
                                                                      .coupons[
                                                                          index]
                                                                      .startDate) +
                                                                  " - " +
                                                                  getDate(snapshot
                                                                      .data
                                                                      .coupons[
                                                                          index]
                                                                      .endDate) +
                                                                  formatDate(snapshot
                                                                      .data
                                                                      .coupons[
                                                                          index]
                                                                      .endDate) +
                                                                  "., " +
                                                                  getTime(snapshot
                                                                      .data
                                                                      .coupons[
                                                                          index]
                                                                      .endDate))
                                                        ])),
                                                    RichText(
                                                        text: TextSpan(
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black),
                                                            children: [
                                                          TextSpan(
                                                              text:
                                                                  "Condition: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          TextSpan(
                                                              text: snapshot
                                                                  .data
                                                                  .coupons[
                                                                      index]
                                                                  .condition)
                                                        ]))
                                                  ])),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                left: BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                right: BorderSide(
                                                    color: Colors.black,
                                                    width: 2)),
                                          )),
                                    ])));
                          } else {
                            return Column(children: <Widget>[
                              Divider(color: Colors.grey),
                              Container(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 10),
                                      child: Column(children: <Widget>[
                                        Container(
                                            width: double.infinity,
                                            child: Padding(
                                                padding: EdgeInsets.all(12),
                                                child: Text(
                                                  snapshot.data.coupons[index]
                                                      .storeName,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      letterSpacing: 2,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  left: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  right: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
                                            )),
                                        CustomPaint(
                                          painter: MyPainter(),
                                          child: Center(),
                                        ),
                                        Container(
                                            width: double.infinity,
                                            child: Padding(
                                                padding: EdgeInsets.all(25),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      RichText(
                                                          text: TextSpan(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        children: [
                                                          TextSpan(
                                                              text: snapshot
                                                                          .data
                                                                          .coupons[
                                                                              index]
                                                                          .price >
                                                                      0
                                                                  ? snapshot
                                                                          .data
                                                                          .coupons[
                                                                              index]
                                                                          .price
                                                                          .toStringAsFixed(
                                                                              2) +
                                                                      " ₼"
                                                                  : "FREE",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      24)),
                                                          TextSpan(
                                                              text: snapshot
                                                                          .data
                                                                          .coupons[
                                                                              index]
                                                                          .price >
                                                                      0
                                                                  ? " OFF"
                                                                  : "",
                                                              style: TextStyle(
                                                                  fontSize: 16))
                                                        ],
                                                      )),
                                                      Text(snapshot
                                                          .data
                                                          .coupons[index]
                                                          .description
                                                          .toUpperCase())
                                                    ])),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  left: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  right: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
                                            )),
                                        CustomPaint(
                                          painter: MyPainter(),
                                          child: Center(),
                                        ),
                                        Container(
                                            width: double.infinity,
                                            child: Padding(
                                                padding: EdgeInsets.all(12),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      RichText(
                                                          text: TextSpan(
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                              children: [
                                                            TextSpan(
                                                                text:
                                                                    "Active Period: ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                            TextSpan(
                                                                text: getDate(
                                                                        snapshot
                                                                            .data
                                                                            .coupons[
                                                                                index]
                                                                            .startDate) +
                                                                    formatDate(snapshot
                                                                        .data
                                                                        .coupons[
                                                                            index]
                                                                        .startDate) +
                                                                    "., " +
                                                                    getTime(snapshot
                                                                        .data
                                                                        .coupons[
                                                                            index]
                                                                        .startDate) +
                                                                    " - " +
                                                                    getDate(snapshot
                                                                        .data
                                                                        .coupons[
                                                                            index]
                                                                        .endDate) +
                                                                    formatDate(snapshot
                                                                        .data
                                                                        .coupons[
                                                                            index]
                                                                        .endDate) +
                                                                    "., " +
                                                                    getTime(snapshot
                                                                        .data
                                                                        .coupons[
                                                                            index]
                                                                        .endDate))
                                                          ])),
                                                      RichText(
                                                          text: TextSpan(
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                              children: [
                                                            TextSpan(
                                                                text:
                                                                    "Condition: ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                            TextSpan(
                                                                text: snapshot
                                                                    .data
                                                                    .coupons[
                                                                        index]
                                                                    .condition)
                                                          ]))
                                                    ])),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  left: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  right: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
                                            )),
                                      ])))
                            ]);
                          }
                        }));
              } else {
                return Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator());
              }
            },
          )
        ]));
  }
}

Future<CouponsList> getCoupons() async {
  var url = 'http://34.90.131.200:3000/voucher';

  var response = await http.get(url);

  List<dynamic> campaignsMap = jsonDecode(response.body);
  var campaigns = CouponsList.fromJson(campaignsMap);

  return campaigns;
}

String getDate(issueDate) {
  var issueArray = issueDate.split("T");
  var date = issueArray[0].split('-');

  return date[2];
}

String getTime(issueDate) {
  var issueArray = issueDate.split("T");
  var time = issueArray[1].split(":");

  return time[0] + ":" + time[1];
}

String formatDate(date) {
  var dateArray = date.split('.');
  var month;

  if (dateArray[1] == '01') {
    month = " Jan";
  } else if (dateArray[1] == '02') {
    month = " Feb";
  } else if (dateArray[1] == '03') {
    month = " Mar";
  } else if (dateArray[1] == '04') {
    month = " Apr";
  } else if (dateArray[1] == '05') {
    month = " May";
  } else if (dateArray[1] == '06') {
    month = " June";
  } else if (dateArray[1] == '07') {
    month = " July";
  } else if (dateArray[1] == '08') {
    month = " Aug";
  } else if (dateArray[1] == '09') {
    month = " Sep";
  } else if (dateArray[1] == '10') {
    month = " Oct";
  } else if (dateArray[1] == '11') {
    month = " Nov";
  } else {
    month = " Dec";
  }

  return month;
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 15, dashSpace = 9, startX = 0;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
