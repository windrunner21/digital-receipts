import 'package:digital_receipts/classes/expensecategoryDetailed.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'classes/expensecategory.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpenseCategoryPage extends StatefulWidget {
  @override
  _ExpenseCategoryPageState createState() => _ExpenseCategoryPageState();

  final String category;
  final int pinCode;

  ExpenseCategoryPage({Key key, this.category, this.pinCode}) : super(key: key);
}

class _ExpenseCategoryPageState extends State<ExpenseCategoryPage> {
  bool dayPressed = false;
  bool weekPressed = false;
  bool monthPressed = true;
  bool yearPressed = false;
  var startDate;
  var endDate;
  var query;

  Color transparent = Color(0x00000000);

  Widget build(BuildContext context) {
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
            title: Text("My " + widget.category + " Expenses"), elevation: 0),
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
              child: FutureBuilder(
            future: getStatistics(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<CategoryExpense> categoryData =
                    new List<CategoryExpense>();
                if (snapshot.data.details != null) {
                  if (yearPressed) {
                    for (int i = 0;
                        i < snapshot.data.details.detailsList.length;
                        i++) {
                      categoryData.add(CategoryExpense(
                          formatDate(snapshot.data.details.detailsList[i].year,
                              snapshot.data.details.detailsList[i].month),
                          snapshot.data.details.detailsList[i].expense));
                    }
                  } else if (dayPressed) {
                    for (int i = 0;
                        i < snapshot.data.details.detailsList.length;
                        i++) {
                      categoryData.add(CategoryExpense(
                          formatDate(snapshot.data.details.detailsList[i].day,
                              snapshot.data.details.detailsList[i].hour),
                          snapshot.data.details.detailsList[i].expense));
                    }
                  } else if (weekPressed) {
                    for (int i = 0;
                        i < snapshot.data.details.detailsList.length;
                        i++) {
                      categoryData.add(CategoryExpense(
                          formatDate(snapshot.data.details.detailsList[i].day,
                              snapshot.data.details.detailsList[i].month),
                          snapshot.data.details.detailsList[i].expense));
                    }
                  } else {
                    for (int i = 0;
                        i < snapshot.data.details.detailsList.length;
                        i++) {
                      categoryData.add(CategoryExpense(
                          formatDate(snapshot.data.details.detailsList[i].day,
                              snapshot.data.details.detailsList[i].month),
                          snapshot.data.details.detailsList[i].expense));
                    }
                  }
                }

                return ListView(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 30),
                      child: Card(
                          child: Container(
                              padding: EdgeInsets.all(5),
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: snapshot.data.details != null
                                  ? charts.BarChart(
                                      [
                                        charts.Series<CategoryExpense, String>(
                                            id: 'CategoryData',
                                            colorFn: (_, __) => charts.Color(
                                                r: Colors.deepPurple.red,
                                                g: Colors.deepPurple.green,
                                                b: Colors.deepPurple.blue,
                                                a: Colors.deepPurple.alpha),
                                            domainFn:
                                                (CategoryExpense catdata, _) =>
                                                    catdata.time,
                                            measureFn:
                                                (CategoryExpense catdata, _) =>
                                                    catdata.expenses,
                                            data: categoryData)
                                      ],
                                      animate: true,
                                      vertical: false,
                                    )
                                  : Center(
                                      child: Text("No data to display",
                                          style: TextStyle(
                                              fontSize: 20,
                                              letterSpacing: 2,
                                              fontWeight: FontWeight.bold)))))),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40)),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Details",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.deepPurple),
                                ),
                                SizedBox(height: 15),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/totalExpenses.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  title: Text("Total Expense",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  subtitle: LinearProgressIndicator(
                                    value: relativeBar(
                                        double.parse(snapshot.data.totalExpense
                                            .toStringAsFixed(2)),
                                        double.parse(snapshot.data.totalExpense
                                            .toStringAsFixed(2))),
                                    backgroundColor: transparent,
                                  ),
                                  trailing: Text(
                                      snapshot.data.totalExpense
                                              .toStringAsFixed(2) +
                                          " ₼",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Divider(
                                    color: Colors.grey,
                                    indent: 70,
                                    endIndent: 15),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/cash.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  title: Text("Cash Expense",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  subtitle: LinearProgressIndicator(
                                    value: relativeBar(
                                        double.parse(snapshot.data.cash
                                            .toStringAsFixed(2)),
                                        double.parse(snapshot.data.totalExpense
                                            .toStringAsFixed(2))),
                                    backgroundColor: transparent,
                                  ),
                                  trailing: Text(
                                      snapshot.data.cash.toStringAsFixed(2) +
                                          " ₼",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Divider(
                                    color: Colors.grey,
                                    indent: 70,
                                    endIndent: 15),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/creditcard.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  title: Text("Credit Card Expense",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  subtitle: LinearProgressIndicator(
                                    value: relativeBar(
                                        double.parse(snapshot.data.creditCard
                                            .toStringAsFixed(2)),
                                        double.parse(snapshot.data.totalExpense
                                            .toStringAsFixed(2))),
                                    backgroundColor: transparent,
                                  ),
                                  trailing: Text(
                                      snapshot.data.creditCard
                                              .toStringAsFixed(2) +
                                          " ₼",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Divider(
                                    color: Colors.grey,
                                    indent: 70,
                                    endIndent: 15),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/cashback.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  title: Text("Cashback",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  subtitle: LinearProgressIndicator(
                                    value: relativeBar(
                                        double.parse(snapshot.data.cashback
                                            .toStringAsFixed(2)),
                                        double.parse(snapshot.data.totalExpense
                                            .toStringAsFixed(2))),
                                    backgroundColor: transparent,
                                  ),
                                  trailing: Text(
                                      snapshot.data.cashback
                                              .toStringAsFixed(2) +
                                          " ₼",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Divider(
                                    color: Colors.grey,
                                    indent: 70,
                                    endIndent: 15),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/average.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  title: Text("Average Receipt Price",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  subtitle: LinearProgressIndicator(
                                    value: relativeBar(
                                        double.parse(snapshot.data.average
                                            .toStringAsFixed(2)),
                                        double.parse(snapshot.data.totalExpense
                                            .toStringAsFixed(2))),
                                    backgroundColor: transparent,
                                  ),
                                  trailing: Text(
                                      snapshot.data.average.toStringAsFixed(2) +
                                          " ₼",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Divider(
                                    color: Colors.grey,
                                    indent: 70,
                                    endIndent: 15),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/expensive.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  title: Text("Most Expensive Expense",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  subtitle: LinearProgressIndicator(
                                    value: relativeBar(
                                        double.parse(snapshot.data.expensive
                                            .toStringAsFixed(2)),
                                        double.parse(snapshot.data.totalExpense
                                            .toStringAsFixed(2))),
                                    backgroundColor: transparent,
                                  ),
                                  trailing: Text(
                                      snapshot.data.expensive
                                              .toStringAsFixed(2) +
                                          " ₼",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Divider(
                                    color: Colors.grey,
                                    indent: 70,
                                    endIndent: 15),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/cheap.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  title: Text("Most Cheap Expense",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  subtitle: LinearProgressIndicator(
                                    value: relativeBar(
                                        double.parse(snapshot.data.cheap
                                            .toStringAsFixed(2)),
                                        double.parse(snapshot.data.totalExpense
                                            .toStringAsFixed(2))),
                                    backgroundColor: transparent,
                                  ),
                                  trailing: Text(
                                      snapshot.data.cheap.toStringAsFixed(2) +
                                          " ₼",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Divider(
                                    color: Colors.grey,
                                    indent: 70,
                                    endIndent: 15),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/totalReceipts.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  title: Text("Total Receipts",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  trailing: Text(
                                      snapshot.data.totalReceipts
                                              .toStringAsFixed(0) +
                                          " qty",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Divider(
                                    color: Colors.grey,
                                    indent: 70,
                                    endIndent: 15),
                              ])),
                    ),
                  ),
                ]);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ))
        ]));
  }

  Future<ExpenseCategoryStatistics> getStatistics() async {
    var url = 'http://34.90.131.200:3000/user/statistics/category';

    Map data = {
      "pin": widget.pinCode,
      "category": widget.category,
      "start": startDate,
      "end": endDate,
      "query": query
    };

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    var statisticsFromJson =
        new ExpenseCategoryStatistics(0, 0, 0, 0, 0, 0, 0, 0, null);

    if (response.body != "") {
      Map statisticsMap = jsonDecode(response.body);
      statisticsFromJson = ExpenseCategoryStatistics.fromJson(statisticsMap);
    }

    return statisticsFromJson;
  }
}

double relativeBar(current, total) {
  if (current == 0 && total == 0) {
    return 0;
  }
  var result = (current * 1.0) / total;
  return double.parse((result).toStringAsFixed(2));
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

String formatDate(x, y) {
  var result = x.toString() + "/" + y.toString();

  return result;
}

class CategoryExpense {
  final String time;
  final double expenses;

  CategoryExpense(this.time, this.expenses);
}
