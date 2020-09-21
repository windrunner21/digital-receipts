import 'package:flutter/material.dart';
import '../filters/campaignsfilter.dart';
import '../classes/campaigns.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My campaigns"),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
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
                            builder: (context) => CampaignsFilterPage()));
                  },
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: getCampaigns(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.campaigns.length,
                      padding: EdgeInsets.only(top: 6.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
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
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              getDate(snapshot.data
                                                  .campaigns[index].startDate),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              formatDate(snapshot.data
                                                  .campaigns[index].startDate),
                                              style: TextStyle(
                                                  letterSpacing: 2,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold))
                                        ]),
                                  ),
                                  title: Text(
                                    snapshot.data.campaigns[index].campaignName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            snapshot.data.campaigns[index]
                                                .description,
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                                snapshot.data.campaigns[index]
                                                    .storeName,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic)))
                                      ]),
                                  trailing: Container(
                                    padding: EdgeInsets.only(left: 12.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            left: new BorderSide(
                                                width: 1.0,
                                                color: Colors.white24))),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              getDate(snapshot.data
                                                  .campaigns[index].endDate),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              formatDate(snapshot.data
                                                  .campaigns[index].endDate),
                                              style: TextStyle(
                                                  letterSpacing: 2,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold))
                                        ]),
                                  ))),
                        );
                      }),
                );
              } else {
                return Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }
}

Future<CampaignsList> getCampaigns() async {
  var url = 'http://34.90.131.200:3000/campaign';

  var response = await http.get(url);

  List<dynamic> campaignsMap = jsonDecode(response.body);
  var campaigns = CampaignsList.fromJson(campaignsMap);

  return campaigns;
}

String getDate(issueDate) {
  var issueArray = issueDate.split("T");
  var date = issueArray[0].split('-');

  return date[2];
}

String formatDate(date) {
  var dateArray = date.split('.')[0].split('-');
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
