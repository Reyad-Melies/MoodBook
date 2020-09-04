import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Page.dart';
import 'file:///D:/Flutter/project/flash-chat-flutter/lib/utilities/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                    //   Navigator.pushNamed(context, LoginScreen.id);
                  })
            ],
          );
        });
  }

  TextEditingController emailNameController;
  TextEditingController passwordNameController;
  //TextEditingController userNameController;
  String email;
  String password;
  FirebaseUser user;
  String errorMassage;
  final _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;
  FirebaseUser _currentUser;
  bool showSpinner = false;
  final formkey = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrntUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _listener.cancel();
    super.dispose();
  }

  signMeUp() {
    if (formkey.currentState.validate()) {}
  }

  signMeUp1() {
    if (formkey1.currentState.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  //    backgroundColor: Color(0xFF1D1E33),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/login2.jpg'),
          fit: BoxFit.cover,
        )),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: <Widget>[
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Hero(
                      tag: 'logo',
                      child: Container(
                        height: 200.0,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Form(
                          key: formkey,
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
                              signMeUp();
                              //Do something with the user input.
                              email = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 18.0,
                        ),
                        Form(
                          key: formkey1,
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
                              signMeUp1();
                              //Do something with the user input.
                              password = value;
                            },
                            // decoration: kTextFieldDecoration.copyWith(
                            //   hintText: 'Enter Your Password'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 5),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot your password?',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'SFUIDisplay',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    RoundedButton('Log In', Colors.deepOrange, () async {
                      setState(() {
                        showSpinner = true;
                        signMeUp();
                      });
                      try {
                        AuthResult result =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        user = result.user;
                        if (user != null) {
                          Navigator.pushReplacementNamed(context, Page.id);
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } catch (error) {
                        showSpinner = false;
                        setState(() {
                          showSpinner = false;
                          if (user == null) {
                            createAlertDialog(context, "Wrong email or password");

                          }
                        });
                      }

                      //Go to login screen.
                    }),
                    MaterialButton(
                      onPressed: () async {
                        setState() async {
                          user = await signUpWithFacebook();
                          Navigator.pushNamed(context, Page.id);
                        }
                      },
                      child: FlatButton(
                        onPressed: () async {
                          setState(() async {
                            try {
                              user = await signUpWithFacebook();
                              Navigator.pushReplacementNamed(
                                  context, Page.id);
                            } catch (error) {
                              print(error);
                            }
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.facebookSquare,
                                color: Colors.blueAccent),
                            Text(
                              'Sign In with facebook',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 15,
                                  fontFamily: 'SFUIDisplay'),
                            )
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                      elevation: 0,
                      minWidth: 350,
                      height: 60,
                      textColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.blueAccent)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: MaterialButton(
                        child: FlatButton(
                          onPressed: () async {
                            setState(() async {
                              try {
                                user = await _googleSignUp();
                                Navigator.pushNamed(context, Page.id);
                              } catch (error) {
                                print(error);
                              }
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.googlePlusSquare,
                                  color: Colors.deepOrange),
                              Text(
                                'Sign In with Google',
                                style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 15,
                                    fontFamily: 'SFUIDisplay'),
                              )
                            ],
                          ),
                        ),
                        color: Colors.transparent,
                        elevation: 0,
                        minWidth: 350,
                        height: 60,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.deepOrange)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Center(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Don't have an account?",
                                style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                          ]),
                        ),
                      ),
                    ),
                    RoundedButton('SIGN UP', Colors.deepOrange, () {
                      setState(() {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      });
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkCurrntUser() async {
    _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);
    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      _currentUser = user;
    });
  }

  Future<FirebaseUser> _googleSignUp() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    final FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    try {
      await Firestore.instance
          .collection('users')
          .document(user.email)
          .setData(
          {'name': user.displayName, 'profilePicture.url': user.photoUrl,});
    }
    catch(e){
      print('sssssssssssssssssss $e');
    }
    return user;
  }

  Future<FirebaseUser> signUpWithFacebook() async {
    try {
      var facebookLogin = new FacebookLogin();

      var result = await facebookLogin.logIn(['email']);

      if (result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );

        final FirebaseUser user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        print('signed in ' + user.displayName);
        await Firestore.instance
            .collection('users')
            .document(user.email)
            .updateData({'name': user.displayName,'profilePicture.url':user.photoUrl,}) ;
        return user;
      }
    } catch (e) {
      print(e.message);
    }
  }
}
