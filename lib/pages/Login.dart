import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_gnfs/pages/Dashboard.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formstate = GlobalKey();
  bool hidepassword = true;
  String? _email;
  String? _password;
  void CheckType() async {
    var res = await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: _email)
        .where('Type', isEqualTo: 'FireStation')
        .get();

    if (res.size == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You do not have permission to use this app')));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    } else {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.toString(), password: _password.toString());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()));
    }

    print(res.size);
  }

  void login() async {
    FocusScope.of(context).unfocus();
    FormState? cform = _formstate.currentState;
    if (cform!.validate()) {
      cform.save();
      try {
        CheckType();
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFAB07), Color(0xFFFF5C00)])),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Text(
              'Sign in as a Fire department',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Form(
              key: _formstate,
              child: Column(
                children: [
                  Container(
                    width: 330,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                      ),
                      validator: (input) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(input.toString());
                        if (emailValid) {
                        } else {
                          return 'Please enter a valid email';
                        }
                      },
                      onSaved: (input) {
                        _email = input;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 330,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (hidepassword) {
                                  hidepassword = false;
                                } else {
                                  hidepassword = true;
                                }
                              });
                            },
                          )),
                      obscureText: hidepassword,
                      validator: (input) {
                        if (input!.length < 6) {
                          return 'Please enter a valid password';
                        }
                      },
                      onSaved: (input) {
                        _password = input;
                      },
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: login,
            child: Container(
              width: 330,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.white),
              child: Center(
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Color(0xFFFF5C00)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
        ]),
      ),
    );
  }
}
