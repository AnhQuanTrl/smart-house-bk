import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/providers/auth_provider.dart';

import 'device_overview_page.dart';

class AuthPage extends StatefulWidget {
  static const String routeName = "/login";
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  final passwordController = new TextEditingController();
  bool _isLoading = false;
  Map<String, String> _authData = {'username': '', 'password': ''};
  void switchPage() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_isLogin) {
        // Log user in
        await Provider.of<AuthProvider>(context, listen: false).attempLogin(
          _authData['username'],
          _authData['password'],
        );
        Navigator.of(context)
            .pushReplacementNamed(DeviceOverviewPage.routeName);
      }
      // else {
      //   // Sign user up
      //   await Provider.of<AuthProvider>(context, listen: false).signup(
      //     _authData['email'],
      //     _authData['password'],
      //   );
      // }
    } //on HttpException
    catch (error) {
      var errorMessage = 'Authentication failed';
      print(error.toString());
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          _isLogin ? "Login" : "Signup",
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Empty username";
                        }
                      },
                      onSaved: (value) => _authData['username'] = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Empty password";
                        }
                      },
                      onSaved: (value) => _authData['password'] = value,
                    ),
                    if (!_isLogin)
                      TextFormField(
                        enabled: _isLogin,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Mismatch Password';
                          }
                        },
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      RaisedButton(
                        child: _isLogin ? Text('LOGIN') : Text('SIGNUP'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 8.0,
                        ),
                        onPressed: _submit,
                      ),
                    FlatButton(
                      onPressed: () {},
                      child: Text('${_isLogin ? 'SIGNUP' : 'LOGIN'} INSTEAD!'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
