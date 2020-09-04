import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
FirebaseUser loggedInUSer;
var dodo;
List<String> list = new List<String>();
final _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  static const String id = 'HomePagee';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
        //    print(loggedInUSer.email);
      }
    } catch (e) {}
    try {
    dodo= await Firestore.instance
        .collection('storage')
        .orderBy('timestamp', descending: true)
        .getDocuments();
        for (var message in dodo.documents){
          print('sssssssssssssss ${message.data['url']}\n');
        }}catch(e){
      print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee   $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        Scaffold(
          backgroundColor: Color(0xFF1D1E33),
          appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            leading: IconButton(
              icon: Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                // Navigator.maybePop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamed(context, Profile.id);
                },
              ),
            ],
          ),
          body: Center(
            child: Column(children: <Widget>[
              working()
            ]),
          ),
       ),
      ],
    );
  }
}

class working extends StatefulWidget {
  @override
  _workingState createState() => _workingState();
}

class _workingState extends State<working> {
//  Widget _ll(){
//    String profileUrl;
//    String name;
//    final dodo= Firestore.instance
//        .collection('storage')
//        .orderBy('timestamp', descending: true)
//        .getDocuments();
//    try{
//      Firestore.instance.collection('users').document(dodo.data['email']).get().then((DocumentSnapshot ds) {
//        name = ds.data['name'];
//        profileUrl=ds.data['profilePicture.url'];
//        print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaccc $name   $profileUrl');
//        setState(() {});
//      });}
//    catch(e){
//      print('ssssssssssssssssssssssssss  $e');
//    }
//    if (dodo!=null) {
//      return LinearProgressIndicator();
//    }
//    else
//      return Expanded(
//        child: ListView(
//
//          final record = Record.fromSnapshot(data);
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(2, 10, 2, 15),
//      child: Column(
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.fromLTRB(15, 0, 3, 5),
//                child: CircleAvatar(
//                    radius: 20,
//                    backgroundImage:
//                    profileUrl == null
//                        ? AssetImage('images/login.jpg')
//                        :
//                    NetworkImage(profileUrl)
//                  //   'assets/images/lake.jpg
//                ),
//
//              ),
//              Padding(
//                padding: const EdgeInsets.only(left: 10.0),
//                child: Text(name==null?'kkkkkkkkk':name,
//                    style: TextStyle(
//                      fontSize: 20,
//                      color: Colors.white,
//                      fontStyle: FontStyle.italic,
//                    )),
//              )
//            ],
//          ),
//          Container(
//            decoration: new BoxDecoration(
//              color: Color(0xFF1D1E33),
//            ),
//            child: ClipRect(
//              child: Image.network(record.url),
//            ),
//          ),
//          Row(
//
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(left:3.0),
//                child: IconButton(
//                  iconSize: 40,
//                  color: Colors.white,
//                  icon: Icon(Icons.favorite_border,),
//                  onPressed: (){
//                    //       print('a88888888888888888888888888888888a');
//                    //colour=Colors.red;
//                    setState(() {
//                      color: Colors.red;
//                    }
//                    );
//                  },
//                ),
//              ),
//            ],
//          )
//        ],
//      ),
//    );
//
//
//
//
//
//        ),
//      );
//      //todo
//  }
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
        Firestore.instance
        .collection('storage')
            .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child:CircularProgressIndicator());
        }
print('sssssssssssssss');
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Expanded(
      child: ListView(
          children:
              snapshot.map((data) => _buildListItem(context, data)).toList()),
    );
  }
  Map<Colors, int> colour = {};
  int i=-1;
  String profileUrl;
  String name;
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    i++;
    Color colour1=Colors.green;
    //colour[]=i;
    //String kk=data.data['email'];
try{
    Firestore.instance.collection('users').document(data.data['email']).get().then((DocumentSnapshot ds) {
    name = ds.data['name'];
    profileUrl=ds.data['profilePicture.url'];
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaccc $name   $profileUrl');
    setState(() {});
    });}
    catch(e){
  print('ssssssssssssssssssssssssss  $e');
    }
    final record = Record.fromSnapshot(data);
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 10, 2, 15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 3, 5),
                child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                    profileUrl == null
                            ? AssetImage('images/login.jpg')
                            :
                    NetworkImage(profileUrl)
                    //   'assets/images/lake.jpg
                    ),

              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(name==null?'kkkkkkkkk':name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    )),
              )
            ],
          ),
          Container(
            decoration: new BoxDecoration(
              color: Color(0xFF1D1E33),
            ),
            child: ClipRect(
              child: Image.network(record.url),
            ),
          ),
          Row(

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:3.0),
                child: IconButton(
                  iconSize: 40,
                  color: Colors.white,
                  icon: Icon(Icons.favorite_border,),
                  onPressed: (){
             //       print('a88888888888888888888888888888888a');
                    //colour=Colors.red;
                        setState(() {
                          color: Colors.red;
                        }
                        );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}

class Record {
  final String location;
  final String url;
  final DocumentReference reference;
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['location'] != null),
        assert(map['url'] != null),
        location = map['location'],
        url = map['url'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$location:$url>";
}
