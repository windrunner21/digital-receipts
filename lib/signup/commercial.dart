import 'package:flutter/material.dart';
import 'package:digital_receipts/dashboard.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CommercialSignUpPage extends StatefulWidget {
  @override
  _CommercialSignUpPageState createState() => _CommercialSignUpPageState();
}

class _CommercialSignUpPageState extends State<CommercialSignUpPage> {
  _TrNumberTextInputFormatter _phoneNumberFormatter =
      _TrNumberTextInputFormatter();

  List<String> suggestions = [
    "Adana",
    "Ankara",
    "Bursa",
    "Gaziantep",
    "Istanbul",
    "Izmir",
    "Konya",
  ];

  //find and create list of matched strings
  List<String> _getSuggestions(String query) {
    List<String> matches = List();

    matches.addAll(suggestions);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  String _selectedCity;
  final TextEditingController _typeAheadController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Commercial Registration"),
        ),
        body: ListView(padding: const EdgeInsets.all(12), children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Text(
                  "Please submit required information below.",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    labelText: "VKN",
                    prefixIcon: Icon(Icons.account_balance)),
              ),
              Divider(),
              TextField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "Corporate Name",
                      prefixIcon: Icon(Icons.business_center))),
              Divider(),
              TextField(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    labelText: "First Name",
                    prefixIcon: Icon(Icons.person)),
              ),
              Divider(),
              TextField(
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "Last Name",
                      prefixIcon: Icon(Icons.person))),
              Divider(),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  labelText: "E-mail",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              Divider(),
              TextFormField(
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  _phoneNumberFormatter,
                ],
                keyboardType: TextInputType.phone,
                maxLength: 15,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    labelText: "Phone number",
                    counterText: "",
                    prefixIcon: Icon(Icons.phone),
                    prefixText: "+90 "),
              ),
              Divider(),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    labelText: "FAX",
                    prefixIcon: Icon(Icons.print)),
              ),
              Divider(),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                    controller: this._typeAheadController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "City",
                      prefixIcon: Icon(Icons.location_city),
                    )),
                suggestionsCallback: (pattern) {
                  return _getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  this._typeAheadController.text = suggestion;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your city';
                  }
                },
                onSaved: (value) => this._selectedCity = value,
              ),
              Divider(),
              TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "District",
                      prefixIcon: Icon(Icons.place))),
              Divider(),
              TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "Address Line 1",
                      prefixIcon: Icon(Icons.home),
                      hintText: "Street and Building Number")),
              Divider(),
              TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "Address Line 2",
                      prefixIcon: Icon(Icons.home),
                      hintText: "Other")),
              Divider(),
              TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    labelText: "Postal Code",
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: RaisedButton(
                  child: Text(
                    'SIGN UP',
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardPage()),
                    );
                  },
                  elevation: 8.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: Colors.deepPurpleAccent,
                  textColor: Colors.white,
                ),
              )
            ],
          )
        ]));
  }
}

class _TrNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + ' ');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 9) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 8) + ' ');
      if (newValue.selection.end >= 8) selectionIndex++;
    }

    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
