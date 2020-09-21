import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'launch.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Digital Receipts',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('tr', ''), // Turkish, no country code
          const Locale('az', ''), // Azerbaijani, no country code
          const Locale('ru', '') // Russian, no country code
        ],
        home: LaunchPage());
  }
}
