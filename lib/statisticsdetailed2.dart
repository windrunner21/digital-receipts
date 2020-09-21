import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'classes/statistics2.dart';

class StatisticsDetailedPage2 extends StatefulWidget {
  @override
  _StatisticsDetailedPageState2 createState() =>
      _StatisticsDetailedPageState2();

  final int statisticsType;
  final int pinCode;

  StatisticsDetailedPage2({Key key, this.statisticsType, this.pinCode})
      : super(key: key);
}

class _StatisticsDetailedPageState2 extends State<StatisticsDetailedPage2> {
  bool dayPressed = false;
  bool weekPressed = false;
  bool monthPressed = true;
  bool yearPressed = false;
  var startDate;
  var endDate;

  Widget build(BuildContext context) {
    var appBarTitle = "";

    if (widget.statisticsType == 0) {
      appBarTitle = "My Favourite Item";
    } else if (widget.statisticsType == 1) {
      appBarTitle = "My Favourite Place";
    } else {
      appBarTitle = "Statistics";
    }

    var statisticsRange = "";
    var today = new Jiffy().dateTime;

    if (dayPressed) {
      statisticsRange = "Today";
      var tomorrow = Jiffy().add(hours: 24);

      // for query
      startDate = getDate(today.toString()).split(".")[2] +
          "-" +
          getDate(today.toString()).split(".")[1] +
          "-" +
          getDate(today.toString()).split(".")[0];

      endDate = getDate(tomorrow.toString()).split(".")[2] +
          "-" +
          getDate(tomorrow.toString()).split(".")[1] +
          "-" +
          getDate(tomorrow.toString()).split(".")[0];
    } else if (weekPressed) {
      var weekBefore = Jiffy().subtract(days: 7);
      // get day week before
      var dayWeekBefore = getDate(weekBefore.toString()).split(".")[0];
      // get todays day, month and year
      var dayWeekNow = getDate(today.toString()).split(".")[0];
      var monthWeekNow = getMonth(getDate(today.toString()).split(".")[1]);
      var yearWeekNow = getDate(today.toString()).split(".")[2];
      // result
      statisticsRange = dayWeekBefore +
          "-" +
          dayWeekNow +
          " " +
          monthWeekNow +
          " " +
          yearWeekNow;

      // for query
      startDate = getDate(weekBefore.toString()).split(".")[2] +
          "-" +
          getDate(weekBefore.toString()).split(".")[1] +
          "-" +
          dayWeekBefore;

      endDate = getDate(today.toString()).split(".")[2] +
          "-" +
          getDate(today.toString()).split(".")[1] +
          "-" +
          dayWeekNow;
    } else if (monthPressed) {
      var monthBefore = Jiffy().subtract(months: 1);
      // get day and month month before
      var dayMonthBefore = getDate(monthBefore.toString()).split(".")[0];
      var monthMonthBefore =
          getMonth(getDate(monthBefore.toString()).split(".")[1]);
      // get todays day, month and year
      var dayMonthNow = getDate(today.toString()).split(".")[0];
      var monthMonthNow = getMonth(getDate(today.toString()).split(".")[1]);
      var yearMonthNow = getDate(today.toString()).split(".")[2];
      // result
      statisticsRange = dayMonthBefore +
          " " +
          monthMonthBefore +
          "-" +
          dayMonthNow +
          " " +
          monthMonthNow +
          " " +
          yearMonthNow;

      // for query
      startDate = yearMonthNow +
          "-" +
          getDate(monthBefore.toString()).split(".")[1] +
          "-" +
          dayMonthBefore;

      endDate = yearMonthNow +
          "-" +
          getDate(today.toString()).split(".")[1] +
          "-" +
          dayMonthNow;
    } else {
      var yearBefore = Jiffy().subtract(years: 1);
      // get month and year year before
      var monthYearBefore =
          getMonth(getDate(yearBefore.toString()).split(".")[1]);
      var yearYearBefore = getDate(yearBefore.toString()).split(".")[2];
      // get todays month and year
      var monthYearNow = getMonth(getDate(today.toString()).split(".")[1]);
      var yearYearNow = getDate(today.toString()).split(".")[2];
      // result
      statisticsRange = monthYearBefore +
          " " +
          yearYearBefore +
          "-" +
          monthYearNow +
          " " +
          yearYearNow;

      // for query
      startDate = yearYearBefore +
          "-" +
          getDate(yearBefore.toString()).split(".")[1] +
          "-" +
          getDate(today.toString()).split(".")[0];

      endDate = yearYearNow +
          "-" +
          getDate(today.toString()).split(".")[1] +
          "-" +
          getDate(today.toString()).split(".")[0];
    }

    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(title: Text(appBarTitle), elevation: 0),
        body: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        dayPressed = true;
                        weekPressed = false;
                        monthPressed = false;
                        yearPressed = false;
                      });
                    },
                    child: Text("Day"),
                    color: dayPressed ? Colors.white : Colors.deepPurple,
                    textColor: dayPressed ? Colors.deepPurple : Colors.white,
                    elevation: dayPressed ? 8 : 0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        dayPressed = false;
                        weekPressed = true;
                        monthPressed = false;
                        yearPressed = false;
                      });
                    },
                    child: Text("Week"),
                    color: weekPressed ? Colors.white : Colors.deepPurple,
                    textColor: weekPressed ? Colors.deepPurple : Colors.white,
                    elevation: weekPressed ? 8 : 0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        dayPressed = false;
                        weekPressed = false;
                        monthPressed = true;
                        yearPressed = false;
                      });
                    },
                    child: Text("Month"),
                    color: monthPressed ? Colors.white : Colors.deepPurple,
                    textColor: monthPressed ? Colors.deepPurple : Colors.white,
                    elevation: monthPressed ? 8 : 0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        dayPressed = false;
                        weekPressed = false;
                        monthPressed = false;
                        yearPressed = true;
                      });
                    },
                    child: Text("Year"),
                    color: yearPressed ? Colors.white : Colors.deepPurple,
                    textColor: yearPressed ? Colors.deepPurple : Colors.white,
                    elevation: yearPressed ? 8 : 0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  ),
                ]),
            Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      statisticsRange,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ))),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: FutureBuilder(
                  future: getStatistics(widget.statisticsType),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        itemCount: snapshot.data.list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Card(
                                  child: ListTile(
                                      leading: Container(
                                          padding: EdgeInsets.only(right: 12.0),
                                          decoration: new BoxDecoration(
                                              border: new Border(
                                                  right: new BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black))),
                                          child: Text("#" + (index + 1).toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 28))),
                                      title: Text(snapshot.data.list[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1)),
                                      subtitle: Text(widget.statisticsType == 0
                                          ? "Purchased " +
                                              snapshot.data.list[index].times
                                                  .toString() +
                                              " times"
                                          : "Visited " +
                                              snapshot.data.list[index].times
                                                  .toString() +
                                              " times"),
                                      trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                                snapshot.data.list[index]
                                                        .expense
                                                        .toStringAsFixed(2) +
                                                    " ₼",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            Text("spent",
                                                style: TextStyle(
                                                    letterSpacing: 2,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ]))));
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            )
          ],
        ));
  }

  Future<Statistic2List> getStatistics(statisticsType) async {
    if (statisticsType == 0) {
      var url = 'http://34.90.131.200:3000/user/statistics/items';

      Map data = {"pin": widget.pinCode, "start": startDate, "end": endDate};

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      List<dynamic> statisticsMap = jsonDecode(response.body);
      var statisticsFromJson = Statistic2List.fromJson(statisticsMap);

      return statisticsFromJson;
    } else {
      var url = 'http://34.90.131.200:3000/user/statistics/place';

      Map data = {"pin": widget.pinCode, "start": startDate, "end": endDate};

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      List<dynamic> statisticsMap = jsonDecode(response.body);
      var statisticsFromJson = Statistic2List.fromJson(statisticsMap);

      return statisticsFromJson;
    }
  }
}

String getDate(issueDate) {
  var issueArray = issueDate.split(" ");
  var date = issueArray[0].split('-');

  return date[2] + "." + date[1] + "." + date[0];
}

String getMonth(monthNumber) {
  var month;

  if (monthNumber == '01') {
    month = " January";
  } else if (monthNumber == '02') {
    month = " February";
  } else if (monthNumber == '03') {
    month = " March";
  } else if (monthNumber == '04') {
    month = " April";
  } else if (monthNumber == '05') {
    month = " May";
  } else if (monthNumber == '06') {
    month = " June";
  } else if (monthNumber == '07') {
    month = " July";
  } else if (monthNumber == '08') {
    month = " August";
  } else if (monthNumber == '09') {
    month = " September";
  } else if (monthNumber == '10') {
    month = " October";
  } else if (monthNumber == '11') {
    month = " November";
  } else {
    month = " December";
  }

  return month;
}
