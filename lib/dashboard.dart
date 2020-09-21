import 'dart:convert';
import 'package:digital_receipts/drawer/coupons.dart';
import 'package:digital_receipts/receiptdetailed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'receiptdetailed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'classes/user.dart';
import 'classes/userDashboard.dart';
import 'classes/receiptShort.dart';
import 'filters/receiptsfilter.dart';
import 'drawer/campaigns.dart';
import 'drawer/settings.dart';
import 'drawer/chat.dart';
import 'drawer/addreceipts.dart';
import 'drawer/coupons.dart';
import 'drawer/statistics.dart';
import 'drawer/authorizereceipts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'expensecategory.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
// page state related variables
  bool isPersonal = true;

// state related variables
  bool printDate = false;
  bool dayOrMonth;
  var todaysDate = getDate(DateTime.now().toString().split(" ")[0]);
  bool printStats = false;
  var listOfExpenses = [];
  double totalExpense = 0.0;
  double avgReceipt = 0.0;

  String previousDate;
  bool filterApplied = false;
  var resultFromFilter;
  String qrcode = "";

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

    return DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: FutureBuilder(
                      future: getName(),
                      initialData: "Good " + greetings,
                      builder:
                          (BuildContext context, AsyncSnapshot<String> text) {
                        return Text(
                          'Good ' +
                              greetings +
                              ", " +
                              text.data.split(" ")[0] +
                              "!",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    // bottomLeft
                                    offset: Offset(0, 0),
                                    blurRadius: 3.0,
                                    color: Colors.black),
                                Shadow(
                                    // bottomRight
                                    offset: Offset(0, 0),
                                    blurRadius: 3.0,
                                    color: Colors.black),
                                Shadow(
                                    // topRight
                                    offset: Offset(0, 0),
                                    blurRadius: 3.0,
                                    color: Colors.black),
                                Shadow(
                                    // topLeft
                                    offset: Offset(0, 0),
                                    blurRadius: 3.0,
                                    color: Colors.black),
                              ]),
                        );
                      }),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      image: DecorationImage(
                          image: AssetImage("assets/" + greetings + ".jpg"),
                          fit: BoxFit.cover)),
                ),
                ListTile(
                  title: Text('Add Receipts'),
                  leading: Image.asset("assets/addreceipt.png",
                      width: 30, height: 30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddReceiptsPage()));
                  },
                ),
                Divider(),
                !isPersonal
                    ? ListTile(
                        title: Text('Authorize Receipts'),
                        leading: Image.asset("assets/authorize.png",
                            width: 30, height: 30),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AuthorizeReceiptsPage()));
                        },
                      )
                    : SizedBox.shrink(),
                !isPersonal ? Divider() : SizedBox.shrink(),
                ListTile(
                  title: Text('Campaigns'),
                  leading: Image.asset("assets/campaigns.png",
                      width: 30, height: 30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CampaignPage()));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Contact the Merchant'),
                  leading:
                      Image.asset("assets/contact.png", width: 30, height: 30),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatPage()));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Coupons & Vouchers'),
                  leading:
                      Image.asset("assets/coupons.png", width: 30, height: 30),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CouponsPage()));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Statistics & Analytics'),
                  leading: Image.asset("assets/statisticsanalytics.png",
                      width: 30, height: 30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StatisticsPage()));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Settings'),
                  leading:
                      Image.asset("assets/settings.png", width: 30, height: 30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                )
              ],
            ),
          ),
          appBar: AppBar(
            title: Text("Digital Receipts"),
            elevation: 0.0,
          ),
          body: FutureBuilder(
              future: getUserFromDatabase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return TabBarView(
                    children: [
                      Column(children: <Widget>[
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
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          hintText: "Search",
                                          isDense: true,
                                          prefixIcon: Icon(Icons.search,
                                              color: Colors.black38),
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
                                onPressed: () async {
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReceiptsFilterPage()));

                                  setState(() {
                                    resultFromFilter = result;
                                    filterApplied = result['filter'];
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                            future: getReceiptsShortInfo(
                                snapshot.data.pin, filterApplied),
                            builder: (context, receiptsSnapshot) {
                              if (receiptsSnapshot.connectionState ==
                                  ConnectionState.done) {
                                return Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        receiptsSnapshot.data.receipts.length,
                                    padding: EdgeInsets.only(top: 6.0),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // variables
                                      var incomingDate = getDate(
                                          receiptsSnapshot
                                              .data.receipts[index].date);

                                      if (index == 0) {
                                        listOfExpenses.clear();
                                        totalExpense = 0.0;
                                        avgReceipt = 0.0;
                                      } else {
                                        if (getDate(receiptsSnapshot.data
                                                    .receipts[index].date) !=
                                                getDate(receiptsSnapshot
                                                    .data
                                                    .receipts[index - 1]
                                                    .date) &&
                                            printStats == true) {
                                          listOfExpenses.clear();
                                          totalExpense = 0.0;
                                          avgReceipt = 0.0;
                                        }
                                      }

                                      if (index == 0) {
                                        // month check && date print
                                        if (todaysDate.split(".")[1] ==
                                            incomingDate.split(".")[1]) {
                                          dayOrMonth = true;

                                          // stats print
                                          if (getDate(receiptsSnapshot
                                                  .data.receipts[index].date) ==
                                              getDate(receiptsSnapshot.data
                                                  .receipts[index + 1].date)) {
                                            printStats = false;
                                            listOfExpenses.add(receiptsSnapshot
                                                .data
                                                .receipts[index]
                                                .totalPrice);
                                          } else {
                                            listOfExpenses.add(receiptsSnapshot
                                                .data
                                                .receipts[index]
                                                .totalPrice);

                                            for (int i = 0;
                                                i < listOfExpenses.length;
                                                i++) {
                                              totalExpense = totalExpense +
                                                  listOfExpenses[i];
                                            }

                                            avgReceipt = totalExpense /
                                                listOfExpenses.length;
                                            printStats = true;
                                          }
                                        } else {
                                          // stats print
                                          if (getDate(receiptsSnapshot.data
                                                      .receipts[index].date)
                                                  .split(".")[1] ==
                                              getDate(receiptsSnapshot.data
                                                      .receipts[index + 1].date)
                                                  .split(".")[1]) {
                                            listOfExpenses.add(receiptsSnapshot
                                                .data
                                                .receipts[index]
                                                .totalPrice);

                                            printStats = false;
                                          } else {
                                            listOfExpenses.add(receiptsSnapshot
                                                .data
                                                .receipts[index]
                                                .totalPrice);

                                            for (int i = 0;
                                                i < listOfExpenses.length;
                                                i++) {
                                              totalExpense = totalExpense +
                                                  listOfExpenses[i];
                                            }

                                            avgReceipt = totalExpense /
                                                listOfExpenses.length;
                                            printStats = true;
                                          }
                                          dayOrMonth = false;
                                        }
                                        printDate = true;
                                      } else {
                                        // month check
                                        if (todaysDate.split(".")[1] ==
                                            incomingDate.split(".")[1]) {
                                          // by day

                                          // date in the beginning
                                          if (getDate(receiptsSnapshot
                                                  .data.receipts[index].date) ==
                                              getDate(receiptsSnapshot.data
                                                  .receipts[index - 1].date)) {
                                            printDate = false;
                                          } else {
                                            printDate = true;
                                            dayOrMonth = true;
                                          }

                                          // stats in the end
                                          if (receiptsSnapshot
                                                  .data.receipts.length >
                                              index + 1) {
                                            if (getDate(receiptsSnapshot.data
                                                    .receipts[index].date) ==
                                                getDate(receiptsSnapshot
                                                    .data
                                                    .receipts[index + 1]
                                                    .date)) {
                                              listOfExpenses.add(
                                                  receiptsSnapshot
                                                      .data
                                                      .receipts[index]
                                                      .totalPrice);
                                              printStats = false;
                                            } else {
                                              listOfExpenses.add(
                                                  receiptsSnapshot
                                                      .data
                                                      .receipts[index]
                                                      .totalPrice);

                                              for (int i = 0;
                                                  i < listOfExpenses.length;
                                                  i++) {
                                                totalExpense = totalExpense +
                                                    listOfExpenses[i];
                                              }

                                              avgReceipt = totalExpense /
                                                  listOfExpenses.length;
                                              printStats = true;
                                            }
                                          } else {
                                            listOfExpenses.add(receiptsSnapshot
                                                .data
                                                .receipts[index]
                                                .totalPrice);

                                            for (int i = 0;
                                                i < listOfExpenses.length;
                                                i++) {
                                              totalExpense = totalExpense +
                                                  listOfExpenses[i];
                                            }

                                            avgReceipt = totalExpense /
                                                listOfExpenses.length;
                                            printStats = true;
                                          }
                                        }
                                        // by month
                                        else {
                                          // date in the beginning
                                          if (getDate(receiptsSnapshot.data
                                                      .receipts[index].date)
                                                  .split(".")[1] ==
                                              getDate(receiptsSnapshot.data
                                                      .receipts[index - 1].date)
                                                  .split(".")[1]) {
                                            printDate = false;
                                          } else {
                                            printDate = true;
                                            dayOrMonth = false;
                                          }

                                          // stats in the end
                                          if (receiptsSnapshot
                                                  .data.receipts.length >
                                              index + 1) {
                                            if (getDate(receiptsSnapshot.data
                                                        .receipts[index].date)
                                                    .split(".")[1] ==
                                                getDate(receiptsSnapshot
                                                        .data
                                                        .receipts[index + 1]
                                                        .date)
                                                    .split(".")[1]) {
                                              listOfExpenses.add(
                                                  receiptsSnapshot
                                                      .data
                                                      .receipts[index]
                                                      .totalPrice);
                                              printStats = false;
                                            } else {
                                              listOfExpenses.add(
                                                  receiptsSnapshot
                                                      .data
                                                      .receipts[index]
                                                      .totalPrice);

                                              for (int i = 0;
                                                  i < listOfExpenses.length;
                                                  i++) {
                                                totalExpense = totalExpense +
                                                    listOfExpenses[i];
                                              }

                                              avgReceipt = totalExpense /
                                                  listOfExpenses.length;
                                              printStats = true;
                                            }
                                          } else {
                                            listOfExpenses.add(receiptsSnapshot
                                                .data
                                                .receipts[index]
                                                .totalPrice);

                                            for (int i = 0;
                                                i < listOfExpenses.length;
                                                i++) {
                                              totalExpense = totalExpense +
                                                  listOfExpenses[i];
                                            }

                                            avgReceipt = totalExpense /
                                                listOfExpenses.length;
                                            printStats = true;
                                          }
                                        }
                                      }

                                      return Column(children: [
                                        printDate
                                            ? dayOrMonth
                                                ? Column(
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(15, 10,
                                                                  15, 10),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    formatDate(
                                                                        getDate(receiptsSnapshot
                                                                            .data
                                                                            .receipts[
                                                                                index]
                                                                            .date),
                                                                        dayOrMonth),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey[700])),
                                                                Text(
                                                                    getWeekday(DateTime.parse(receiptsSnapshot.data.receipts[index].date)
                                                                            .weekday)
                                                                        .toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey[700]))
                                                              ])),
                                                      Divider(
                                                          color:
                                                              Colors.grey[600])
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(15, 10,
                                                                  15, 10),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    formatDate(
                                                                        getDate(receiptsSnapshot
                                                                            .data
                                                                            .receipts[
                                                                                index]
                                                                            .date),
                                                                        dayOrMonth),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey[700])),
                                                                Text(
                                                                    getMonth(getDate(receiptsSnapshot.data.receipts[index].date).split(".")[
                                                                            1])
                                                                        .toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey[700]))
                                                              ])),
                                                      Divider(
                                                          color:
                                                              Colors.grey[600])
                                                    ],
                                                  )
                                            : SizedBox.shrink(),
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
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: ListTile(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ReceiptPage(
                                                                receiptDetails:
                                                                    receiptsSnapshot
                                                                        .data
                                                                        .receipts[
                                                                            index]
                                                                        .id),
                                                      ),
                                                    );
                                                  },
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20.0,
                                                          vertical: 10.0),
                                                  leading: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 12.0),
                                                    decoration: new BoxDecoration(
                                                        border: new Border(
                                                            right: new BorderSide(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .white24))),
                                                    child: getIconByCategory(
                                                        receiptsSnapshot
                                                            .data
                                                            .receipts[index]
                                                            .category),
                                                  ),
                                                  title: Text(
                                                    receiptsSnapshot
                                                        .data
                                                        .receipts[index]
                                                        .category,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                      receiptsSnapshot
                                                          .data
                                                          .receipts[index]
                                                          .companyName
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  trailing: Text(
                                                      receiptsSnapshot.data.receipts[index].totalPrice.toStringAsFixed(2) + " ₼",
                                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
                                        ),
                                        printStats
                                            ? Column(children: [
                                                Divider(
                                                    color: Colors.grey[600]),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  "Total Expense",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                              .grey[
                                                                          700])),
                                                              SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                  totalExpense
                                                                          .toStringAsFixed(
                                                                              2) +
                                                                      " ₼",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                            ]),
                                                        Container(
                                                          width: 1,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              35,
                                                          color: Colors.grey,
                                                        ),
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  "Average Receipt",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                              .grey[
                                                                          700])),
                                                              SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                  avgReceipt.toStringAsFixed(
                                                                          2) +
                                                                      " ₼",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                            ])
                                                      ],
                                                    )),
                                                Divider(color: Colors.grey[600])
                                              ])
                                            : SizedBox.shrink(),
                                      ]);
                                    },
                                  ),
                                );
                              } else {
                                return Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: CircularProgressIndicator());
                              }
                            })
                      ]),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(top: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 35,
                                      child: Image.asset(
                                        "assets/profile.png",
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          _settingModalBottomSheet(
                                              context,
                                              snapshot.data.firstName +
                                                  " " +
                                                  snapshot.data.lastName);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data.firstName +
                                                      " " +
                                                      snapshot.data.lastName,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    color: snapshot
                                                            .data.isCorporate
                                                        ? Colors.deepPurple
                                                        : Colors
                                                            .deepPurpleAccent,
                                                  ),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 5, 15, 5),
                                                  margin: EdgeInsets.all(10),
                                                  child: Text(
                                                    isPersonal
                                                        ? "Personal"
                                                        : "Corporate",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Icon(
                                                    Icons.keyboard_arrow_down))
                                          ],
                                        ))
                                  ],
                                )),
                            SizedBox(height: 10.0),
                            Divider(
                                indent: 15,
                                endIndent: 15,
                                height: 20,
                                color: Colors.black38),
                            Text("My expense tracker",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            Divider(
                                indent: 15,
                                endIndent: 15,
                                height: 20,
                                color: Colors.black38),
                            FutureBuilder(
                                future: getDashboardInfo(snapshot.data.pin),
                                builder: (context, dashboardSnapshot) {
                                  if (dashboardSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StatisticsPage()));
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            13,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        color: Colors.lightBlue,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .lightBlueAccent,
                                                            blurRadius: 5.0,
                                                          )
                                                        ]),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Text(
                                                          "Limit",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          snapshot.data.limit
                                                                  .toStringAsFixed(
                                                                      2) +
                                                              " ₼",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    )),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            13,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      color: Colors.cyan,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Colors.cyanAccent,
                                                          blurRadius: 5.0,
                                                        )
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Text(
                                                          "Spent",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          '${dashboardSnapshot.data.spent.toStringAsFixed(2)} ₼',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    )),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            13,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      color: Colors.blue,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Colors.blueAccent,
                                                          blurRadius: 5.0,
                                                        )
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Text(
                                                          "Avg Receipt",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          '${dashboardSnapshot.data.average.toStringAsFixed(2)} ₼',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            )));
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }),
                            Divider(
                                indent: 15,
                                endIndent: 15,
                                height: 20,
                                color: Colors.black38),
                            Text("Today's campaign",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            Divider(
                                indent: 15,
                                endIndent: 15,
                                height: 20,
                                color: Colors.black38),
                            FutureBuilder(
                                future: getTodaysCampaign(),
                                builder: (context, campaingSnapshot) {
                                  if (campaingSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Card(
                                      elevation: 10.0,
                                      margin: new EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  blurRadius: 5.0,
                                                )
                                              ],
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    Colors.deepPurple[400],
                                                    Colors.deepPurpleAccent
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: ListTile(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CampaignPage()));
                                              },
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10.0),
                                              leading: Container(
                                                padding: EdgeInsets.only(
                                                    right: 12.0),
                                                decoration: new BoxDecoration(
                                                    border: new Border(
                                                        right: new BorderSide(
                                                            width: 1.0,
                                                            color: Colors
                                                                .white24))),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                          getCampaingsDate(
                                                              '${campaingSnapshot.data['startDate']}'),
                                                          style: TextStyle(
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          formatCampaingsDate(
                                                              '${campaingSnapshot.data['startDate']}'),
                                                          style: TextStyle(
                                                              letterSpacing: 2,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ]),
                                              ),
                                              title: Text(
                                                '${campaingSnapshot.data['campaignName']}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                        '${campaingSnapshot.data['description']}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        child: Text(
                                                            '${campaingSnapshot.data['storeName']}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic)))
                                                  ]),
                                              trailing: Container(
                                                padding:
                                                    EdgeInsets.only(left: 12.0),
                                                decoration: new BoxDecoration(
                                                    border: new Border(
                                                        left: new BorderSide(
                                                            width: 1.0,
                                                            color: Colors
                                                                .white24))),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                          getCampaingsDate(
                                                              '${campaingSnapshot.data['endDate']}'),
                                                          style: TextStyle(
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          formatCampaingsDate(
                                                              '${campaingSnapshot.data['endDate']}'),
                                                          style: TextStyle(
                                                              letterSpacing: 2,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ]),
                                              ))),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }),
                            Divider(
                                indent: 15,
                                endIndent: 15,
                                height: 20,
                                color: Colors.black38),
                            Text("Expenses by Categories",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            Divider(
                                indent: 15,
                                endIndent: 15,
                                height: 20,
                                color: Colors.black38),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: _categories.length,
                                    gridDelegate:
                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return new GestureDetector(
                                          child: new Card(
                                            color: _categoriesColors[index],
                                            clipBehavior: Clip.antiAlias,
                                            elevation: 10.0,
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned(
                                                    top: 20,
                                                    left: 20,
                                                    right: 20,
                                                    child: Image.asset(
                                                      _categoriesPhoto[index],
                                                      width: 50,
                                                      height: 50,
                                                    )),
                                                Positioned(
                                                  bottom: 12,
                                                  left: 8,
                                                  right: 8,
                                                  child: Text(
                                                      _categories[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          letterSpacing: 1,
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ExpenseCategoryPage(
                                                  category: _categories[index],
                                                  pinCode: snapshot.data.pin,
                                                ),
                                              ),
                                            );
                                          });
                                    })),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                  "In order to get digital receipt please the scan QR Code from the Terminal",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center)),
                          Column(
                            children: <Widget>[
                              RaisedButton(
                                  color: Colors.deepPurple,
                                  textColor: Colors.white,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0)),
                                  onPressed: () {
                                    scan(snapshot.data.pin);
                                  },
                                  child: Text("Scan")),
                              Text(qrcode),
                            ],
                          )
                        ],
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          bottomNavigationBar: TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.receipt),
                text: "Receipts",
              ),
              Tab(
                icon: Icon(Icons.home),
                text: "Home",
              ),
              Tab(
                icon: Icon(LineAwesomeIcons.qrcode),
                text: "QR Code",
              ),
            ],
          ),
        ));
  }

  void _settingModalBottomSheet(context, name) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isPersonal = true;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                          color:
                              isPersonal ? Colors.deepPurple[50] : Colors.white,
                          child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    name,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    width: 125,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    child: Text(
                                      "Personal",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  )
                                ],
                              )))),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isPersonal = false;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                          color: !isPersonal
                              ? Colors.deepPurple[50]
                              : Colors.white,
                          child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      name,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Container(
                                      width: 125,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.deepPurple,
                                      ),
                                      padding:
                                          EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      child: Text(
                                        "Corporate",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    )
                                  ]))))
                ],
              )
            ],
          ));
        });
  }

  Future scan(pinCodeScan) async {
    try {
      String qrscanned = await BarcodeScanner.scan();
      setState(() => this.qrcode = "Scan successfull: " + qrscanned);

      var url = 'http://34.90.131.200:3000/test/simulation';

      Map data = {
        "pin": pinCodeScan,
      };

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.qrcode = 'You did not grant the camera permission!';
        });
      } else {
        setState(() => this.qrcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(
          () => this.qrcode = 'You returned back before scanning anything.');
    } catch (e) {
      setState(() => this.qrcode = 'Unknown error: $e');
    }
  }

  Future<ReceiptsShortList> getReceiptsShortInfo(pinCode, filter) async {
    if (!filter) {
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
    } else {
      var url = 'http://34.90.131.200:3000/receipt/dynamic-find';

      Map data = {
        "pin": pinCode,
        "query": resultFromFilter['query'].length == 0
            ? [{}]
            : resultFromFilter['query'],
        "filterVariable": resultFromFilter['filterVariable'],
        "filterOrder": resultFromFilter['filterOrder']
      };

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      List<dynamic> receiptsMap = jsonDecode(response.body);
      var receipts = ReceiptsShortList.fromJson(receiptsMap);

      return receipts;
    }
  }
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

Future<UserDashboard> getDashboardInfo(pinCode) async {
  var url = 'http://34.90.131.200:3000/user/dashboard';

  Map data = {"pin": pinCode, "start": "2020-09-01", "end": "2020-09-30"};

  var body = json.encode(data);
  var response = await http.post(url,
      headers: {"Content-Type": "application/json"}, body: body);

  print(response.statusCode);

  Map dashboardMap = jsonDecode(response.body);
  var dashboard = UserDashboard.fromJson(dashboardMap);
  return dashboard;
}

Future<Map<String, dynamic>> getTodaysCampaign() async {
  var url = 'http://34.90.131.200:3000/campaign/getRecommendedCampaign';

  var response = await http.get(url);

  Map<String, dynamic> campaign = jsonDecode(response.body);

  return campaign;
}

Image getIconByCategory(category) {
  double width = 25;
  double height = 25;

  if (category == "Clothing") {
    return Image.asset("assets/clothing.png",
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

String getCampaingsDate(issueDate) {
  var issueArray = issueDate.split("T");
  var date = issueArray[0].split('-');

  return date[2];
}

String formatCampaingsDate(date) {
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

String getTime(issueDate) {
  var issueArray = issueDate.split("T");
  var time = issueArray[1].split(":");

  return time[0] + ":" + time[1];
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

String getWeekday(index) {
  if (index == 1) {
    return "Monday";
  } else if (index == 2) {
    return "Tuesday";
  } else if (index == 3) {
    return "Wednesday";
  } else if (index == 4) {
    return "Thursday";
  } else if (index == 5) {
    return "Friday";
  } else if (index == 6) {
    return "Saturday";
  } else {
    return "Sunday";
  }
}

String getMonth(date) {
  var month;

  if (date == '01') {
    month = " January";
  } else if (date == '02') {
    month = " February";
  } else if (date == '03') {
    month = " March";
  } else if (date == '04') {
    month = " April";
  } else if (date == '05') {
    month = " May";
  } else if (date == '06') {
    month = " June";
  } else if (date == '07') {
    month = " July";
  } else if (date == '08') {
    month = " August";
  } else if (date == '09') {
    month = " September";
  } else if (date == '10') {
    month = " October";
  } else if (date == '11') {
    month = " November";
  } else {
    month = " December";
  }

  return month;
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

    return name;
  }
  return null;
}
