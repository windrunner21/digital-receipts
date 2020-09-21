import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'classes/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  bool _obscureIcon = true;
  bool _obscureText2 = true;
  bool _obscureIcon2 = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  _TrNumberTextInputFormatter _phoneNumberFormatter =
      _TrNumberTextInputFormatter();

  String _selectedCity = "";
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
        appBar: AppBar(title: Text("Edit Profile")),
        body: Padding(
            padding: EdgeInsets.only(top: 20),
            child: FutureBuilder(
              future: getUserFromDatabase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 35,
                            child: Image.asset(
                              "assets/profile.png",
                              height: 100,
                              width: 100,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                  snapshot.data.firstName +
                                      " " +
                                      snapshot.data.lastName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20))),
                          Text(snapshot.data.email,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Divider(color: Colors.grey)),
                      ListTile(
                          leading: Icon(
                            Icons.account_circle,
                            color: Colors.deepPurple,
                          ),
                          title: Text('Profile Picture'),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {},
                          )),
                      Divider(color: Colors.grey),
                      ListTile(
                          leading: Icon(
                            Icons.lock,
                            color: Colors.deepPurple,
                          ),
                          title: Text('Password'),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _changePasswordDialog();
                            },
                          )),
                      Divider(color: Colors.grey),
                      ListTile(
                          leading: Icon(Icons.phone, color: Colors.deepPurple),
                          title: Text('Phone Number'),
                          subtitle: Text("0 " + snapshot.data.phoneNumber),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _changePhoneNumberDialog();
                            },
                          )),
                      Divider(color: Colors.grey),
                      ListTile(
                          leading: Icon(Icons.location_city,
                              color: Colors.deepPurple),
                          title: Text('City'),
                          subtitle: Text(snapshot.data.city),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _changeCityDialog();
                            },
                          )),
                      Divider(color: Colors.grey),
                      Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Divider(color: Colors.grey)),
                      ListTile(
                          leading:
                              Icon(Icons.assignment, color: Colors.deepPurple),
                          title: Text(
                              'End User License Agreement and Privacy Policy'),
                          trailing: Checkbox(
                            value: snapshot.data.agreement,
                            onChanged: (bool value) {
                              updateUser("hasAgreedToShareData",
                                      !snapshot.data.agreement)
                                  .then((value) =>
                                      value == 200 ? setState(() {}) : null);
                            },
                          )),
                      Divider(color: Colors.grey)
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )));
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

  Future<int> updateUser(name, value) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userid = user.uid;

    if (user != null) {
      var url = 'http://34.90.131.200:3000/user/update';

      Map data = {"id": userid, name: value};

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      return response.statusCode;
    }
    return 0;
  }

  void _changePassword(String password) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    user.updatePassword(password).then((_) {
      final snackBar = SnackBar(
        content: Text('Succesfully changed password',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    }).catchError((error) {
      final snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text('Password Change Failed',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
      print(error.toString());
    });
  }

  Future<void> _changePasswordDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Form(
                key: _formKey,
                child: AlertDialog(
                  title: Text('Change password'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          'Type in your new password:',
                          style: TextStyle(letterSpacing: 1),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 20),
                            child: TextFormField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter your new password';
                                }
                                return null;
                              },
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                hintText: "Password",
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
                            )),
                        Text('Confirm your new password:',
                            style: TextStyle(letterSpacing: 1)),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please confirm your new password';
                                } else if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              },
                              controller: _passwordConfirmController,
                              obscureText: _obscureText2,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureIcon2
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText2 = !_obscureText2;
                                      _obscureIcon2 = !_obscureIcon2;
                                    });
                                  },
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        _passwordController.clear();
                        _passwordConfirmController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Change'),
                      onPressed: () {
                        if (_formKey.currentState.validate() &&
                            _passwordController.text ==
                                _passwordConfirmController.text) {
                          _changePassword(_passwordController.text);
                          _passwordController.clear();
                          _passwordConfirmController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                    )
                  ],
                  elevation: 24,
                ));
          });
        });
  }

  Future<void> _changePhoneNumberDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Form(
                key: _formKey,
                child: AlertDialog(
                  title: Text('Change phone number'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          'Type in your new phone number:',
                          style: TextStyle(letterSpacing: 1),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 20),
                            child: TextFormField(
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
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  labelText: "Phone number",
                                  counterText: "",
                                  prefixIcon: Icon(Icons.phone),
                                  prefixText: "+90 "),
                            ))
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        _phoneNumberController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Change'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          updateUser(
                              "phoneNumber", _phoneNumberController.text);
                          _phoneNumberController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                    )
                  ],
                  elevation: 24,
                ));
          });
        });
  }

  Future<void> _changeCityDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Form(
                key: _formKey,
                child: AlertDialog(
                  title: Text('Change city'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          'Type in your new city:',
                          style: TextStyle(letterSpacing: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: this._typeAheadController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
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
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (suggestion) {
                              this._typeAheadController.text = suggestion;
                              this._selectedCity =
                                  this._typeAheadController.text;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your city';
                              }
                              return null;
                            },
                            onSaved: (value) => this._selectedCity = value,
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Change'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          updateUser("city", _selectedCity);
                          Navigator.of(context).pop();
                        }
                      },
                    )
                  ],
                  elevation: 24,
                ));
          });
        });
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
