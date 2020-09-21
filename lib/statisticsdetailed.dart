import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'classes/statistics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatisticsDetailedPage extends StatefulWidget {
  @override
  _StatisticsDetailedPageState createState() => _StatisticsDetailedPageState();

  final int statisticsType;
  final int pinCode;

  StatisticsDetailedPage({Key key, this.statisticsType, this.pinCode})
      : super(key: key);
}

class _StatisticsDetailedPageState extends State<StatisticsDetailedPage> {
  bool dayPressed = false;
  bool weekPressed = false;
  bool monthPressed = true;
  bool yearPressed = false;
  var startDate;
  var endDate;
  var query;

  Widget build(BuildContext context) {
    var appBarTitle = "";

    if (widget.statisticsType == 0) {
      appBarTitle = "My Total Expenses";
    } else if (widget.statisticsType == 1) {
      appBarTitle = "My Receipt Statistics";
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

      query = {
        "year": {"\$year": "\$rest.issueDate"},
        "month": {"\$month": "\$rest.issueDate"},
        "day": {"\$dayOfMonth": "\$rest.issueDate"},
        "hour": {"\$hour": "\$rest.issueDate"}
      };
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

      query = {
        "year": {"\$year": "\$rest.issueDate"},
        "month": {"\$month": "\$rest.issueDate"},
        "day": {"\$dayOfMonth": "\$rest.issueDate"}
      };
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

      query = {
        "year": {"\$year": "\$rest.issueDate"},
        "month": {"\$month": "\$rest.issueDate"},
        "day": {"\$dayOfMonth": "\$rest.issueDate"}
      };
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

      query = {
        "year": {"\$year": "\$rest.issueDate"},
        "month": {"\$month": "\$rest.issueDate"}
      };
    }

    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
            title: Text(appBarTitle,
                style: TextStyle(fontWeight: FontWeight.bold)),
            elevation: 0),
        body: Column(children: <Widget>[
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
                          // expense data graph
                          List<TotalExpense> expenseData =
                              new List<TotalExpense>();

                          // receipt data graph
                          List<TotalReceipts> receiptData =
                              new List<TotalReceipts>();

                          // expense data graph population
                          if (widget.statisticsType == 0) {
                            if (yearPressed) {
                              for (int i = 0;
                                  i < snapshot.data.details.detailsList.length;
                                  i++) {
                                expenseData.add(TotalExpense(
                                    DateTime(
                                      snapshot.data.details.detailsList[i].year,
                                      snapshot
                                          .data.details.detailsList[i].month,
                                      int.tryParse(getDate(today.toString())
                                          .split(".")[0]),
                                    ),
                                    snapshot
                                        .data.details.detailsList[i].yAxis));
                              }
                            } else if (dayPressed) {
                              if (snapshot.data.details != null) {
                                for (int i = 0;
                                    i <
                                        snapshot
                                            .data.details.detailsList.length;
                                    i++) {
                                  expenseData.add(TotalExpense(
                                      DateTime(
                                          snapshot
                                              .data.details.detailsList[i].year,
                                          snapshot.data.details.detailsList[i]
                                              .month,
                                          snapshot
                                              .data.details.detailsList[i].day,
                                          snapshot.data.details.detailsList[i]
                                              .hour),
                                      snapshot
                                          .data.details.detailsList[i].yAxis));
                                }
                              }
                            } else {
                              for (int i = 0;
                                  i < snapshot.data.details.detailsList.length;
                                  i++) {
                                expenseData.add(TotalExpense(
                                    DateTime(
                                      snapshot.data.details.detailsList[i].year,
                                      snapshot
                                          .data.details.detailsList[i].month,
                                      snapshot.data.details.detailsList[i].day,
                                    ),
                                    snapshot
                                        .data.details.detailsList[i].yAxis));
                              }
                            }
                          }
                          // receipt data graph population
                          else {
                            if (yearPressed) {
                              for (int i = 0;
                                  i < snapshot.data.details.detailsList.length;
                                  i++) {
                                receiptData.add(TotalReceipts(
                                    DateTime(
                                      snapshot.data.details.detailsList[i].year,
                                      snapshot
                                          .data.details.detailsList[i].month,
                                      int.tryParse(getDate(today.toString())
                                          .split(".")[0]),
                                    ),
                                    snapshot
                                        .data.details.detailsList[i].yAxis));
                              }
                            } else if (dayPressed) {
                              if (snapshot.data.details != null) {
                                for (int i = 0;
                                    i <
                                        snapshot
                                            .data.details.detailsList.length;
                                    i++) {
                                  receiptData.add(TotalReceipts(
                                      DateTime(
                                          snapshot
                                              .data.details.detailsList[i].year,
                                          snapshot.data.details.detailsList[i]
                                              .month,
                                          snapshot
                                              .data.details.detailsList[i].day,
                                          snapshot.data.details.detailsList[i]
                                              .hour),
                                      snapshot
                                          .data.details.detailsList[i].yAxis));
                                }
                              }
                            } else {
                              for (int i = 0;
                                  i < snapshot.data.details.detailsList.length;
                                  i++) {
                                receiptData.add(TotalReceipts(
                                    DateTime(
                                      snapshot.data.details.detailsList[i].year,
                                      snapshot
                                          .data.details.detailsList[i].month,
                                      snapshot.data.details.detailsList[i].day,
                                    ),
                                    snapshot
                                        .data.details.detailsList[i].yAxis));
                              }
                            }
                          }

                          return ListView(
                            children: <Widget>[
                              // graph
                              Card(
                                  child: Container(
                                padding: EdgeInsets.all(5),
                                width: double.infinity,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: widget.statisticsType == 0
                                    ? snapshot.data.details != null
                                        ? charts.TimeSeriesChart(
                                            [
                                              charts.Series<TotalExpense,
                                                  DateTime>(
                                                id: 'Expenses',
                                                colorFn: (_, __) =>
                                                    charts.Color(
                                                        r: Colors
                                                            .deepPurple.red,
                                                        g: Colors
                                                            .deepPurple.green,
                                                        b: Colors
                                                            .deepPurple.blue,
                                                        a: Colors
                                                            .deepPurple.alpha),
                                                domainFn:
                                                    (TotalExpense expenses,
                                                            _) =>
                                                        expenses.time,
                                                measureFn:
                                                    (TotalExpense expenses,
                                                            _) =>
                                                        expenses.expenses,
                                                data: expenseData,
                                              )
                                            ],
                                            animate: true,
                                            defaultRenderer: new charts
                                                .BarRendererConfig<DateTime>(),
                                          )
                                        : Center(
                                            child: Text("No data to display",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    letterSpacing: 2,
                                                    fontWeight:
                                                        FontWeight.bold)))
                                    : snapshot.data.details != null
                                        ? charts.TimeSeriesChart([
                                            charts.Series<TotalReceipts,
                                                DateTime>(
                                              id: 'Receipts',
                                              colorFn: (_, __) => charts.Color(
                                                  r: Colors.deepPurple.red,
                                                  g: Colors.deepPurple.green,
                                                  b: Colors.deepPurple.blue,
                                                  a: Colors.deepPurple.alpha),
                                              domainFn:
                                                  (TotalReceipts receipts, _) =>
                                                      receipts.time,
                                              measureFn:
                                                  (TotalReceipts receipts, _) =>
                                                      receipts.receipts,
                                              data: receiptData,
                                            )
                                          ], animate: true)
                                        : Center(
                                            child: Text("No data to display",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    letterSpacing: 2,
                                                    fontWeight:
                                                        FontWeight.bold))),
                              )),
                              Padding(
                                  padding: EdgeInsets.only(top: 25, bottom: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        widget.statisticsType == 0
                                            ? Card(
                                                child: Container(
                                                    padding: EdgeInsets.all(20),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.3,
                                                    child: Column(children: <
                                                        Widget>[
                                                      Text("Total Expense",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  bottom: 10),
                                                          child: Image.asset(
                                                            "assets/totalExpenses.png",
                                                            width: 50,
                                                            height: 50,
                                                          )),
                                                      Text(
                                                          snapshot.data.card1
                                                                  .toStringAsFixed(
                                                                      2) +
                                                              " ₼",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20))
                                                    ])))
                                            : Card(
                                                child: Container(
                                                    padding: EdgeInsets.all(20),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.3,
                                                    child: Column(children: <
                                                        Widget>[
                                                      Text("Total Receipts",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  bottom: 10),
                                                          child: Image.asset(
                                                            "assets/totalReceipts.png",
                                                            width: 50,
                                                            height: 50,
                                                          )),
                                                      Text(
                                                          snapshot.data.card1
                                                                  .toStringAsFixed(
                                                                      0) +
                                                              " qty",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20))
                                                    ]))),
                                        widget.statisticsType == 0
                                            ? Card(
                                                child: Container(
                                                    padding: EdgeInsets.all(20),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.3,
                                                    child: Column(children: <
                                                        Widget>[
                                                      Text("Cash",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  bottom: 10),
                                                          child: Image.asset(
                                                            "assets/cash.png",
                                                            width: 50,
                                                            height: 50,
                                                          )),
                                                      Text(
                                                          snapshot.data.card2
                                                                  .toStringAsFixed(
                                                                      2) +
                                                              " ₼",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20))
                                                    ])))
                                            : Card(
                                                child: Container(
                                                    padding: EdgeInsets.all(20),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.3,
                                                    child: Column(children: <
                                                        Widget>[
                                                      Text("Average Receipt",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  bottom: 10),
                                                          child: Image.asset(
                                                            "assets/average.png",
                                                            width: 50,
                                                            height: 50,
                                                          )),
                                                      Text(
                                                          snapshot.data.card2
                                                                  .toStringAsFixed(
                                                                      2) +
                                                              " ₼",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20))
                                                    ]))),
                                      ])),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    widget.statisticsType == 0
                                        ? Card(
                                            child: Container(
                                                padding: EdgeInsets.all(20),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                child:
                                                    Column(children: <Widget>[
                                                  Text("Credit Card",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15, bottom: 10),
                                                      child: Image.asset(
                                                        "assets/creditcard.png",
                                                        width: 50,
                                                        height: 50,
                                                      )),
                                                  Text(
                                                      snapshot.data.card3
                                                              .toStringAsFixed(
                                                                  2) +
                                                          " ₼",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20))
                                                ])))
                                        : Card(
                                            child: Container(
                                                padding: EdgeInsets.all(20),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                child:
                                                    Column(children: <Widget>[
                                                  Text("Most Expensive",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15, bottom: 10),
                                                      child: Image.asset(
                                                        "assets/expensive.png",
                                                        width: 50,
                                                        height: 50,
                                                      )),
                                                  Text(
                                                      snapshot.data.card3
                                                              .toStringAsFixed(
                                                                  2) +
                                                          " ₼",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20))
                                                ]))),
                                    widget.statisticsType == 0
                                        ? Card(
                                            child: Container(
                                                padding: EdgeInsets.all(20),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                child:
                                                    Column(children: <Widget>[
                                                  Text("Total Cashback",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15, bottom: 10),
                                                      child: Image.asset(
                                                        "assets/cashback.png",
                                                        width: 50,
                                                        height: 50,
                                                      )),
                                                  Text(
                                                      snapshot.data.card4
                                                              .toStringAsFixed(
                                                                  2) +
                                                          " ₼",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20))
                                                ])))
                                        : Card(
                                            child: Container(
                                                padding: EdgeInsets.all(20),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                child:
                                                    Column(children: <Widget>[
                                                  Text("Most Cheap",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15, bottom: 10),
                                                      child: Image.asset(
                                                        "assets/cheap.png",
                                                        width: 50,
                                                        height: 50,
                                                      )),
                                                  Text(
                                                      snapshot.data.card4
                                                              .toStringAsFixed(
                                                                  2) +
                                                          " ₼",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20))
                                                ]))),
                                  ])
                            ],
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      })))
        ]));
  }

  Future<Statistics> getStatistics(statisticsType) async {
    if (statisticsType == 0) {
      var url = 'http://34.90.131.200:3000/user/statistics/expense';

      Map data = {
        "pin": widget.pinCode,
        "start": startDate,
        "end": endDate,
        "query": query
      };

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      var statisticsFromJson = new Statistics(0, 0, 0, 0, null);

      if (response.body != "") {
        Map statisticsMap = jsonDecode(response.body);
        statisticsFromJson = Statistics.fromJson(statisticsMap);
      }

      return statisticsFromJson;
    } else {
      var url = 'http://34.90.131.200:3000/user/statistics/orderDetails';

      Map data = {
        "pin": widget.pinCode,
        "start": startDate,
        "end": endDate,
        "query": query
      };

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      var statisticsFromJson = new Statistics(0, 0, 0, 0, null);

      if (response.body != "") {
        Map statisticsMap = jsonDecode(response.body);
        statisticsFromJson = Statistics.fromJson(statisticsMap);
      }

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

class TotalExpense {
  final DateTime time;
  final double expenses;

  TotalExpense(this.time, this.expenses);
}

class TotalReceipts {
  final DateTime time;
  final double receipts;

  TotalReceipts(this.time, this.receipts);
}
