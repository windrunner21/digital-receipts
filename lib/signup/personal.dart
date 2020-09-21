import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:digital_receipts/dashboard.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;

class PersonalSignUpPage extends StatefulWidget {
  @override
  _PersonalSignUpPageState createState() => _PersonalSignUpPageState();
}

class _PersonalSignUpPageState extends State<PersonalSignUpPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // auth
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tcknController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String _selectedCity = "";
  final TextEditingController _districtController = TextEditingController();

  bool _obscureText = true;
  bool _obscureIcon = true;

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

  // find and create list of matched strings
  List<String> _getSuggestions(String query) {
    List<String> matches = List();

    matches.addAll(suggestions);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  final TextEditingController _typeAheadController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Personal Registration"),
        ),
        body: Form(
            key: _formKey,
            child:
                ListView(padding: const EdgeInsets.all(12), children: <Widget>[
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
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your TCKN';
                      }
                      return null;
                    },
                    controller: _tcknController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        labelText: "TCKN",
                        prefixIcon: Icon(Icons.account_box)),
                  ),
                  Divider(),
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    controller: _firstNameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        labelText: "First Name",
                        prefixIcon: Icon(Icons.person)),
                  ),
                  Divider(),
                  TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      controller: _lastNameController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          labelText: "Last Name",
                          prefixIcon: Icon(Icons.person))),
                  Divider(),
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    controller: _emailController,
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
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureIcon
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                            _obscureIcon = !_obscureIcon;
                          });
                        },
                      ),
                    ),
                  ),
                  Divider(),
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    controller: _phoneNumberController,
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
                      this._selectedCity = this._typeAheadController.text;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your city';
                      }
                      return null;
                    },
                    onSaved: (value) => this._selectedCity = value,
                  ),
                  // Divider(),
                  // TextFormField(
                  //     validator: (String value) {
                  //       if (value.isEmpty) {
                  //         return 'Please enter your district';
                  //       }
                  //       return null;
                  //     },
                  //     controller: _districtController,
                  //     keyboardType: TextInputType.text,
                  //     decoration: InputDecoration(
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(25.0)),
                  //         labelText: "District",
                  //         prefixIcon: Icon(Icons.place))),
                  // Divider(),
                  // TextField(
                  //     keyboardType: TextInputType.text,
                  //     decoration: InputDecoration(
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(25.0)),
                  //         labelText: "Address Line 1",
                  //         prefixIcon: Icon(Icons.home),
                  //         hintText: "Street and Building Number")),
                  // Divider(),
                  // TextField(
                  //     keyboardType: TextInputType.text,
                  //     decoration: InputDecoration(
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(25.0)),
                  //         labelText: "Address Line 2",
                  //         prefixIcon: Icon(Icons.home),
                  //         hintText: "Other")),
                  // Divider(),
                  // TextField(
                  //     keyboardType: TextInputType.text,
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(25.0)),
                  //       labelText: "Postal Code",
                  //     )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: RaisedButton(
                      child: Text(
                        'SIGN UP',
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _register();
                        }
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
            ])));
  }

  @override
  void dispose() {
    _tcknController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  void _register() async {
    try {
      final AuthResult user = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (user != null) {
        var url = 'http://34.90.131.200:3000/user/add';

        Map data = {
          "_id": user.user.uid,
          "isCorporate": false,
          "TCNumber": _tcknController.text,
          "firstName": _firstNameController.text,
          "lastName": _lastNameController.text,
          "email": _emailController.text,
          "phoneNumber": _phoneNumberController.text,
          "city": _selectedCity,
          // "district": _districtController.text
        };

        //encode Map to JSON
        var body = json.encode(data);
        print(body);
        var response = await http.post(url,
            headers: {"Content-Type": "application/json"}, body: body);
        print("${response.statusCode}");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Something went wrong. Sign Up Failed',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
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
