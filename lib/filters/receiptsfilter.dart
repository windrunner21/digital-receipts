import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReceiptsFilterPage extends StatefulWidget {
  @override
  _ReceiptsFilterPageState createState() => _ReceiptsFilterPageState();
}

class _ReceiptsFilterPageState extends State<ReceiptsFilterPage> {
  var priceRangeMap = {"totalPrice": {}};
  var dateRangeMap = {
    "issueDate": {"\$gte": "", "\$lte": ""}
  };
  var paymentTypeMap = {"paymentTypeNote": ""};
  var categoryMap = {"category": {}};
  var query = [];

  Color transparent = Color(0x00000000);
  // state related variables
  bool dateSortPressed = true;
  bool priceSortPressed = false;
  bool dateOrderDescending = true;
  bool priceOrderDescending = true;
  bool paymentTypeCreditCard = false;
  bool paymentTypeCash = false;
  RangeValues selectedRange = RangeValues(0, 1000);
  String startDate = "Start Date";
  String endDate = "End Date";
  var _categoryChipSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Widget build(BuildContext context) {
    var _categories = [
      "Education",
      "Restaurants & Food",
      "Grocery",
      "Health",
      "Travel",
      "Sport",
      "Transport",
      "Music & Games",
      "Utilities"
    ];

    var _categoriesPhoto = [
      'assets/education.png',
      'assets/restaurants.png',
      'assets/grocery.png',
      'assets/health.png',
      'assets/travel.png',
      'assets/sport.png',
      'assets/transport.png',
      'assets/games.png',
      'assets/utilities.png'
    ];

    List<Color> _categoriesColors = [
      Colors.green[300],
      Colors.pink[100],
      Colors.blue[200],
      Colors.red[300],
      Colors.amber[300],
      Colors.purple[100],
      Colors.indigo[300],
      Colors.cyan[200],
      Colors.brown[300]
    ];

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
                title: Text("Filter Receipts"),
                automaticallyImplyLeading: false),
            body: Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text("Sort by",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))),
                    Divider(color: Colors.grey),
                    Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          children: <Widget>[
                            FlatButton.icon(
                                shape: Border(
                                    top: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    bottom: BorderSide(color: Colors.black)),
                                color: dateSortPressed
                                    ? Colors.deepPurple
                                    : transparent,
                                onPressed: () {
                                  setState(() {
                                    if (!dateSortPressed) {
                                      dateSortPressed = true;
                                      priceSortPressed = false;
                                    } else {
                                      dateOrderDescending =
                                          !dateOrderDescending;
                                    }
                                  });
                                },
                                icon: Text("Date",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: dateSortPressed
                                            ? Colors.white
                                            : Colors.black)),
                                label: dateSortPressed
                                    ? dateOrderDescending
                                        ? Icon(Icons.arrow_downward,
                                            color: dateSortPressed
                                                ? Colors.white
                                                : Colors.black)
                                        : Icon(Icons.arrow_upward,
                                            color: dateSortPressed
                                                ? Colors.white
                                                : Colors.black)
                                    : Icon(Icons.remove,
                                        color: dateSortPressed
                                            ? Colors.white
                                            : Colors.black)),
                            FlatButton.icon(
                                shape: Border.all(color: Colors.black),
                                color: priceSortPressed
                                    ? Colors.deepPurple
                                    : transparent,
                                onPressed: () {
                                  setState(() {
                                    if (!priceSortPressed) {
                                      dateSortPressed = false;
                                      priceSortPressed = true;
                                    } else {
                                      priceOrderDescending =
                                          !priceOrderDescending;
                                    }
                                  });
                                },
                                icon: Text("Price",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: priceSortPressed
                                            ? Colors.white
                                            : Colors.black)),
                                label: priceSortPressed
                                    ? priceOrderDescending
                                        ? Icon(Icons.arrow_downward,
                                            color: priceSortPressed
                                                ? Colors.white
                                                : Colors.black)
                                        : Icon(Icons.arrow_upward,
                                            color: priceSortPressed
                                                ? Colors.white
                                                : Colors.black)
                                    : Icon(Icons.remove,
                                        color: priceSortPressed
                                            ? Colors.white
                                            : Colors.black))
                          ],
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(
                                "To change the sorting order press the button again",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic)))),
                    Divider(color: Colors.grey),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Text("Filter by",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))),
                    Divider(color: Colors.grey),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: Text("Price Range",
                                style: TextStyle(fontSize: 18)))),
                    RangeSlider(
                        values: selectedRange,
                        onChanged: (RangeValues newRange) {
                          setState(() => selectedRange = newRange);

                          var gtelte = {
                            "\$gte": selectedRange.start.round(),
                            "\$lte": selectedRange.end.round()
                          };

                          priceRangeMap['totalPrice'] = gtelte;
                        },
                        min: 0,
                        max: 1000,
                        divisions: 1000,
                        labels: RangeLabels('${selectedRange.start.round()}',
                            '${selectedRange.end.round()}')),
                    Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("${selectedRange.start.round()} ₼",
                                style: TextStyle()),
                            Text("${selectedRange.end.round()} ₼",
                                style: TextStyle())
                          ],
                        )),
                    Divider(color: Colors.grey),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: Text("Date Range",
                                style: TextStyle(fontSize: 18)))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton(
                                shape: Border.all(color: Colors.black),
                                color: Colors.deepPurple,
                                onPressed: () async {
                                  var tempDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime.now(),
                                  );

                                  if (tempDate != null) {
                                    setState(() {
                                      startDate = formatDate(
                                          tempDate.toString().split(" ")[0]);

                                      dateRangeMap['issueDate']['\$gte'] =
                                          tempDate.toString().split(" ")[0];
                                    });
                                  }
                                },
                                child: Text("Start",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15))),
                            RaisedButton(
                                shape: Border.all(color: Colors.black),
                                color: Colors.deepPurple,
                                onPressed: () async {
                                  var tempDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime.now(),
                                  );

                                  if (tempDate != null) {
                                    setState(() {
                                      endDate = formatDate(
                                          tempDate.toString().split(" ")[0]);

                                      dateRangeMap['issueDate']['\$lte'] =
                                          tempDate.toString().split(" ")[0];
                                    });
                                  }
                                },
                                child: Text("End",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15))),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(startDate, style: TextStyle()),
                            Text(endDate, style: TextStyle())
                          ],
                        )),
                    Divider(color: Colors.grey),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: Text("Payment type",
                                style: TextStyle(fontSize: 18)))),
                    Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          children: <Widget>[
                            FlatButton.icon(
                                shape: Border(
                                    top: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    bottom: BorderSide(color: Colors.black)),
                                color: paymentTypeCreditCard
                                    ? Colors.deepPurple
                                    : transparent,
                                onPressed: () {
                                  setState(() {
                                    paymentTypeCash = false;
                                    paymentTypeCreditCard = true;
                                  });
                                },
                                label: Text("Credit Card",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: paymentTypeCreditCard
                                            ? Colors.white
                                            : Colors.black)),
                                icon: Icon(Icons.credit_card,
                                    color: paymentTypeCreditCard
                                        ? Colors.white
                                        : Colors.black)),
                            FlatButton.icon(
                                shape: Border.all(color: Colors.black),
                                color: paymentTypeCash
                                    ? Colors.deepPurple
                                    : transparent,
                                onPressed: () {
                                  setState(() {
                                    paymentTypeCash = true;
                                    paymentTypeCreditCard = false;
                                  });
                                },
                                label: Text("Cash Money",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: paymentTypeCash
                                            ? Colors.white
                                            : Colors.black)),
                                icon: Icon(Icons.attach_money,
                                    color: paymentTypeCash
                                        ? Colors.white
                                        : Colors.black))
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Divider(color: Colors.grey)),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 10),
                            child: Text("Category",
                                style: TextStyle(fontSize: 18)))),
                    Wrap(
                        children: _categories
                            .asMap()
                            .map((index, item) => MapEntry(
                                index,
                                Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                                    child: RawChip(
                                      onSelected: (bool value) {
                                        setState(() {
                                          _categoryChipSelected[index] = value;
                                        });
                                      },
                                      selected: _categoryChipSelected[index],
                                      selectedColor: Colors.deepPurple,
                                      backgroundColor:
                                          _categoryChipSelected[index]
                                              ? Colors.deepPurple
                                              : _categoriesColors[index],
                                      avatar: _categoryChipSelected[index]
                                          ? null
                                          : Image.asset(
                                              _categoriesPhoto[index],
                                            ),
                                      checkmarkColor: Colors.white,
                                      label: Text(
                                        item,
                                        style: TextStyle(
                                            color: _categoryChipSelected[index]
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ))))
                            .values
                            .toList()),
                    Divider(color: Colors.grey),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: RaisedButton(
                              child: Text('APPLY FILTERS'),
                              onPressed: () {
                                var filterNotApplied = {"filter": false};

                                // filter exists

                                var categoryArray = [];
                                for (int i = 0; i < _categories.length; i++) {
                                  if (_categoryChipSelected[i]) {
                                    categoryArray.add(_categories[i]);
                                  }
                                }

                                if (paymentTypeCash || paymentTypeCreditCard) {
                                  query.add(paymentTypeMap);
                                  paymentTypeMap['paymentTypeNote'] =
                                      paymentTypeCash ? "Nakit" : "Kredi Karti";
                                }

                                if (selectedRange != RangeValues(0, 1000)) {
                                  query.add(priceRangeMap);
                                }

                                if (categoryArray.length != 0) {
                                  categoryMap["category"] = {
                                    "\$in": categoryArray
                                  };
                                  query.add(categoryMap);
                                }

                                if (dateRangeMap['issueDate']['\$gte'] == "") {
                                  query.add({
                                    "issueDate": {
                                      "\$lte": dateRangeMap['issueDate']
                                                  ['\$lte'] ==
                                              ""
                                          ? null
                                          : dateRangeMap['issueDate']['\$lte']
                                    }
                                  });
                                } else if (dateRangeMap['issueDate']['\$lte'] ==
                                    "") {
                                  query.add({
                                    "issueDate": {
                                      "\$gte": dateRangeMap['issueDate']
                                                  ['\$gte'] ==
                                              ""
                                          ? null
                                          : dateRangeMap['issueDate']['\$gte']
                                    }
                                  });
                                } else {
                                  query.add({
                                    "issueDate": {
                                      "\$gte": dateRangeMap['issueDate']
                                                  ['\$gte'] ==
                                              ""
                                          ? null
                                          : dateRangeMap['issueDate']['\$gte'],
                                      "\$lte": dateRangeMap['issueDate']
                                                  ['\$lte'] ==
                                              ""
                                          ? null
                                          : dateRangeMap['issueDate']['\$lte']
                                    }
                                  });
                                }

                                var filterIsApplied = {
                                  "filter": true,
                                  "query": query,
                                  "filterVariable": dateSortPressed
                                      ? "issueDate"
                                      : "totalPrice",
                                  "filterOrder": dateSortPressed
                                      ? (dateOrderDescending ? "-1" : "1")
                                      : (priceOrderDescending ? "-1" : "1")
                                };

                                if (query.length == 0 &&
                                    dateSortPressed &&
                                    dateOrderDescending) {
                                  Navigator.pop(context, filterNotApplied);
                                } else {
                                  Navigator.pop(context, filterIsApplied);
                                }
                              },
                              elevation: 8.0,
                              color: Colors.deepPurple,
                              textColor: Colors.white,
                            ))),
                  ],
                ))));
  }

  Future<bool> _onWillPop() async {
    return false;
  }
}

String formatDate(date) {
  var dateArray = date.split('-');

  return dateArray[2] + "/" + dateArray[1] + '/' + dateArray[0];
}
