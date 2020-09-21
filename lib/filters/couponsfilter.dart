import 'package:flutter/material.dart';

class CouponsFilterPage extends StatefulWidget {
  @override
  _CouponsFilterPageState createState() => _CouponsFilterPageState();
}

class _CouponsFilterPageState extends State<CouponsFilterPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Filter Coupons & Vouchers"),
          automaticallyImplyLeading: false),
    );
  }
}
