import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/database.dart';
import 'package:flash_chat/screens/Information.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'file:///D:/Flutter/project/flash-chat-flutter/lib/utilities/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';
  int age;

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  Map<String, String> userData = {
    'email': 'koko@gaamil.com',
    'gender': 'Female',
    'name': 'reyad'
  };
  final Formkey = GlobalKey<FormState>();
  final Formkey1 = GlobalKey<FormState>();
  final Formkey2 = GlobalKey<FormState>();
  FirebaseUser loggedInUSer;
  String emailError;
  String pwError = '';
  String email = '';
  String password;
  String password1;
  TextEditingController emailNameController;
  TextEditingController passwordNameController;
  TextEditingController passwordMatchController;
  bool showSpinner = false;
  signMeUp() {
    if (Formkey.currentState.validate()) {}
  }

  signMeUp1() {
    if (Formkey1.currentState.validate()) {}
  }

  signMeUp2() {
    if (Formkey2.currentState.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/Registeration1.jpg'),
          fit: BoxFit.cover,
        )),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 350.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),

                SizedBox(
                  height: 48.0,
                ),

                Column(
                  children: <Widget>[
                    Form(
                      key: Formkey,
                      child: TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : 'Please Provide Valid Email';
                        },
                        controller: emailNameController,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: 'Email Address',
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                          signMeUp();
                          //Do something with the user input.
                        },
                      ),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    Form(
                      key: Formkey1,
                      child: TextFormField(
                        validator: (val) {
                          return val.length > 6
                              ? null
                              : 'Please Provide Valid Password';
                        },
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          //Do something with the user input.
                          password = value;
                          signMeUp1();
                        },
                        // decoration: kTextFieldDecoration.copyWith(
                        //   hintText: 'Enter Your Password'),
                      ),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    Form(
                      key: Formkey2,
                      child: TextFormField(
                        validator: (val) {
                          return password == password1
                              ? null
                              : 'Password Don\'t Match';
                        },
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: 'Renter Your Password',
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          password1 = value;
                          signMeUp2();
                          //Do something with the user input.
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                RoundedButton(
                  'Register',
                  Colors.deepOrange,
                  () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      showSpinner = false;
                      AuthResult result =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      FirebaseUser user = result.user;
                      if (user != null) {
                        //pwError == 'null' && emailError == 'null'
                        Navigator.pushNamed(context, Information.id);
                      } else {}
                    } catch (e) {
                      print('ssssssssssssssss $e');
                      setState(() {
                        showSpinner = false;
                        createAlertDialog(context,
                            'Already Registered Email\n\n        Try Again');
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createAlertDialog(BuildContext context, String k) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(k),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5,
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RegistrationScreen.id);
                  })
            ],
          );
        });
  }
}
