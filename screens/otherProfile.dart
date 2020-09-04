import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/screens/HomePage.dart';
import 'package:flash_chat/utilities/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:math';
import 'chat_screen.dart';

String SearchUserEmail = 'reyad12367@gmail.com';
String follow='Follow' ;
int numberOfPosts;
int followers;
int following;
FirebaseUser loggedInUSer;
final _auth = FirebaseAuth.instance;
bool showSpinner = false;
String email;
String name;
String url;

// ignore: camel_case_types
class otherProfile extends StatefulWidget {
  static const String id = 'otherProfile';
  @override
  _otherProfileState createState() => _otherProfileState();
}

class _otherProfileState extends State<otherProfile> {
  void initState() {
    super.initState();
    // TODO: implement initState
    getCurrentUSer();
  }

  void getCurrentUSer() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUSer = user;
      }
    } catch (e) {
      print(e);
    }
    DocumentReference searchuser =
        Firestore.instance.collection('users').document(SearchUserEmail);
    if (searchuser != null)
      print('tamaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaam');
    else
      print('moosssssssssssssssssssh mawgoood');

    DocumentReference searchuser1 =
     Firestore.instance.collection('users').document(loggedInUSer.email).collection('following').document(SearchUserEmail);
    if (searchuser1 != null)
      follow='Follow';
    else
      follow='UnFollow';
    try {
      QuerySnapshot _myDoc = await Firestore.instance
          .collection('storage').where('email',isEqualTo:SearchUserEmail )
          .getDocuments();
      List<DocumentSnapshot> _myDocCount = _myDoc.documents;
      numberOfPosts = _myDocCount.length;
      _myDoc = await Firestore.instance
          .collection('users')
          .document(SearchUserEmail)
          .collection('followers')
          .getDocuments();
      _myDocCount = _myDoc.documents;
      followers = _myDocCount.length;
      _myDoc = await Firestore.instance
          .collection('users')
          .document(SearchUserEmail)
          .collection('followers')
          .getDocuments();
      _myDocCount = _myDoc.documents;
      following = _myDocCount.length;
      await Firestore.instance
          .collection('users')
          .document(SearchUserEmail)
          .get()
          .then((DocumentSnapshot ds) {
        name = ds.data['name'];
      });
      await Firestore.instance
          .collection('users')
          .document(SearchUserEmail)
          .get()
          .then((DocumentSnapshot ds) {
        url = ds.data['profilePicture.url'];
      });
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1E29),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, HomePage.id);
          },
        ),
        title: Center(child: Text('Profile')),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.chat_bubble),
            onPressed: () {
              Navigator.pushNamed(context, ChatScreen.id);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                          radius: 50,
                          backgroundImage: url == null
                              ? AssetImage('images/logo.png')
                              : NetworkImage(url)
                          //   'assets/images/lake.jpg
                          ),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepOrange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              numberOfPosts.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              followers.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Followers',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              following.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Following',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    RoundedButton(follow, Colors.deepOrange, () async{
                      if (follow == 'Follow') {
                        follow = 'Following';
                        await Firestore.instance.collection('users').document(
                            loggedInUSer.email)
                            .collection('following')
                            .document(SearchUserEmail).setData({'email':loggedInUSer.email});

                      }else {
                        follow = 'Follow';
                        await Firestore.instance.collection('users').document(
                            loggedInUSer.email)
                            .collection('following')
                            .document(SearchUserEmail)
                            .delete();
                      }
                      setState(() {});
                    }
                      ),

                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Divider(thickness: 2, color: Colors.deepOrange),
            ),
            Flexible(
              child: working(),
            ),
          ],
        ),
      ),
    );
  }
}

class working extends StatelessWidget {
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('storage').where('email',isEqualTo:SearchUserEmail )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('nodataaaaaaaaaaaaaaaaaaaaaaa');
          return LinearProgressIndicator();
        }
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
        crossAxisCount: 3,
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList());
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRect(
        child: Image.network(record.url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
