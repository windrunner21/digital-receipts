import 'package:flutter/material.dart';

class CampaignsFilterPage extends StatefulWidget {
  @override
  _CampaignsFilterPageState createState() => _CampaignsFilterPageState();
}

class _CampaignsFilterPageState extends State<CampaignsFilterPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Filter Campaigns"), automaticallyImplyLeading: false),
    );
  }
}
