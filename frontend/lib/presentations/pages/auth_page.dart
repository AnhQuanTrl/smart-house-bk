import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/exception/authentication_exception.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/providers/auth_provider.dart';
import 'package:smarthouse/providers/dialog_provider.dart';

import 'device_overview_page.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  static const String routeName = "/login";
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  final passwordController = new TextEditingController();
  final usernameController = new TextEditingController();
  bool _isLoading = false;
  Map<String, String> _authData = {'username': '', 'password': ''};
  void _switchPage() {
    usernameController.clear();
    passwordController.clear();
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
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
    DialogProvider provider =
        Provider.of<DialogProvider>(context, listen: false);
    try {
      if (_isLogin) {
        // Log user in
        await Provider.of<AuthProvider>(context, listen: false).login(
          _authData['username'],
          _authData['password'],
        );
        Navigator.of(context)
            .pushReplacementNamed(DeviceOverviewPage.routeName);
      } else {
        // Sign user up
        await Provider.of<AuthProvider>(context, listen: false).signup(
          _authData['username'],
          _authData['password'],
        );
        provider.showCustomDialog("Successful Signup", context,
            isSuccess: true);
      }
    } on AuthenticationException catch (error) {
      var errorMessage = error.toString();
      provider.showCustomDialog(errorMessage, context, isSuccess: false);
    } catch (error) {
      provider.showCustomDialog("Unknown error", context, isSuccess: false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.only(
                          top: 20, bottom: 5, right: 20, left: 20),
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Smart",
                                  style: TextStyle(
                                      color: Colors.cyan[800],
                                      fontFamily: "Righteous",
                                      fontSize: 25)),
                              Text("HOME",
                                  style: TextStyle(
                                      color: Colors.cyan[800],
                                      fontFamily: "Righteous",
                                      fontSize: 60)),
                              Align(
                                child: Text('Control your life!'),
                                alignment: Alignment.bottomRight,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: usernameController,
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
                              enabled: !_isLogin,
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password'),
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
                              color: Colors.orange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                _isLogin ? 'LOGIN' : 'SIGNUP',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 25.0,
                                vertical: 12.0,
                              ),
                              onPressed: _submit,
                            ),
                          FlatButton(
                            onPressed: _switchPage,
                            child: Text(
                                '${_isLogin ? 'SIGNUP' : 'LOGIN'} INSTEAD!'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
