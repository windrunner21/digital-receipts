import 'package:flutter/material.dart';
import 'signup/personal.dart';
import 'signup/commercial.dart';
import 'dashboard.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordReset = TextEditingController();
  bool _obscureText = true;
  bool _obscureIcon = true;
  int index = 0;

  final controller = PageController(initialPage: 0);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Digital Receipts"),
        ),
        body: Stack(
          children: <Widget>[
            PageView(
              controller: controller,
              onPageChanged: _onPageViewChange,
              children: <Widget>[
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/logo.png",
                              height: 100,
                              width: 100,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: TextFormField(
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your e-mail';
                                  }
                                  return null;
                                },
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  labelText: "E-mail",
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                            ),
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FlatButton(
                                child: Text(
                                  "Forgot Password",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                onPressed: () {
                                  _settingModalBottomSheet(context);
                                },
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: RaisedButton(
                                  child: Text('LOGIN'),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      _signInWithEmailAndPassword();
                                    }
                                  },
                                  elevation: 8.0,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  color: Colors.deepPurple,
                                  textColor: Colors.white,
                                )),
                            FlatButton(
                              child: Text(
                                "Do not have an account?",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                              onPressed: () {
                                controller.animateToPage(
                                  1,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.linear,
                                );
                              },
                            ),
                          ],
                        ),
                      )),
                )),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/login.png",
                        height: 100,
                        width: 100,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Text(
                          "New User",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 24),
                        ),
                      ),
                      Text("Register a new account",
                          style: TextStyle(fontSize: 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: 50, minWidth: 150),
                                child: RaisedButton(
                                  child: Text(
                                    'PERSONAL',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PersonalSignUpPage()),
                                    );
                                  },
                                  elevation: 8.0,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  color: Colors.deepPurpleAccent,
                                  textColor: Colors.white,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: 50, minWidth: 150),
                                child: RaisedButton(
                                  child: Text(
                                    'CORPORATE',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CommercialSignUpPage()),
                                    );
                                  },
                                  elevation: 8.0,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  color: Colors.deepPurple,
                                  textColor: Colors.white,
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Align(
                child: Padding(
                  child: DotsIndicator(
                    dotsCount: 2,
                    position: index.toDouble(),
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeColor: Colors.deepPurple,
                      activeSize: const Size(18.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                ),
                alignment: Alignment.bottomCenter)
          ],
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.only(top: 20, left: 50, right: 50),
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _passwordReset,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      hintText: "Enter your email",
                      isDense: true),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: RaisedButton(
                    color: Colors.deepPurple,
                    child: Text(
                      "RESET PASSWORD",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      resetPassword(_passwordReset.text);
                      _passwordReset.clear();
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  _onPageViewChange(int page) {
    setState(() {
      index = page;
    });
  }

  void _signInWithEmailAndPassword() async {
    try {
      final AuthResult user = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (user.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Login Failed',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
