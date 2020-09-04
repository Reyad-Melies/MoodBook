import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flash_chat/screens/HomePage.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Profile.dart';
import 'file:///D:/Flutter/project/flash-chat-flutter/lib/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = Firestore.instance;
FirebaseUser loggedInUSer;
class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {



  final _auth = FirebaseAuth.instance;
  final messageTextController=TextEditingController();
  String messageText;
  @override
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUSer();
    super.initState();
  }

//  void getMassages() async {
//    final messages = await _firestore.collection('massages').getDocuments();
//    for (var message in messages.documents) {
//      print(message.data);
//    }
//  }

  void getCurrentUSer() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUSer = user;
        //    print(loggedInUSer.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          back(auth: _auth),
        ],
        //⚡
        title: Text('Chat'),
        backgroundColor: Colors.deepOrange,
      ),

//      bottomNavigationBar: CurvedNavigationBar(
//        height: 60,
//        color: Colors.deepOrange,
//        backgroundColor: Color(0xFF1D1E33),
//        buttonBackgroundColor: Colors.white,
//        items: <Widget>[
//          Icon(
//            Icons.chat,
//            size: 30,
//            color: Colors.black,
//          ),
//          Icon(
//            Icons.home,
//            size: 30,
//            color: Colors.black,
//          ),
//          Icon(
//            Icons.account_circle,
//            size: 30,
//            color: Colors.black,
//          ),
//          Icon(
//            Icons.notifications,
//            size: 30,
//            color: Colors.black,
//          ),
//        ],
//        animationDuration: Duration(
//          microseconds: 200,
//        ),
//        index: 0,
//        animationCurve: Curves.bounceInOut,
//        onTap: (index) {
//          if (index==1)
//            Navigator.pushNamed(context, HomePage.id);
//          else if(index==2)
//            Navigator.pushNamed(context, Profile.id);
//        },
//      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/image.png'),
              fit: BoxFit.cover,
            )),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MassagesStream(),
                  Container(
                    decoration: kMessageContainerDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageTextController,
                            onChanged: (value) {
                              //Do something with the user input.
                              messageText = value;
                            },
                            decoration: kMessageTextFieldDecoration,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            messageTextController.clear();
                          // TODO

                            //  _firestore.collection('users').document(loggedInUSer.email).setData({'name':'male'});
                         //   _firestore.collection("users").document(loggedInUSer.email).updateData({'name':'reyad'});
                         //   _firestore.collection('users').document('noSTQ6qVxvplUCsAAVOu').collection('friendsEmailLists').add({'email':'reyad@k.com'});
                            //   _firestore.collection('users').document('noSTQ6qVxvplUCsAAVOu').collection('friendsEmailLists').add({'email':'reyad@k.com'});.document('noSTQ6qVxvplUCsAAVOu').collection('friendsEmailLists').add({'email':'reyad@k.com'});
                           // Map details = new Map();
                           // details['email'] = 'qqqqqqq@gmail.com';
//                            try {
//                              _firestore.collection('users').add({
//                                'name':'koko',
//                                'gender':'male',
//                              });
//                              _firestore.collection('users').add({
//                                'friendlist': details
//                              });
//                            }catch(e){
//                              print(e);
//                            }
                            _firestore.collection('massages').add({
                              'text': messageText,
                              'sender': loggedInUSer.email,
                            });
                          },
                          child: Text(
                            'Send',
                            style: kSendButtonTextStyle.copyWith( color: Colors.deepOrange),

                          ),
                        ),
                      ],
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

class back extends StatelessWidget {
  const back({
    Key key,
    @required FirebaseAuth auth,})
      : _auth = auth, super(key: key);

  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          _auth.signOut();
          Navigator.pushNamed(context, LoginScreen.id);
          //Implement logout functionality
        });
  }
}
class MassagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('massages').snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.deepOrange,
            ),
          );
        }
        final massages = snapshot.data.documents.reversed;
        List<MassagesBubble> massagesBubble = [];
        for (var massage in massages) {
          final massageText = massage.data['text'];
          final massagesSender = massage.data['sender'];
          final currentUser=loggedInUSer.email;
          final messageBubble = MassagesBubble(
              massagesSender,
              massageText,
              massagesSender==currentUser);
              massagesBubble.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: massagesBubble,
          ),
        );
      },
    );
  }
}


class MassagesBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:isMe?CrossAxisAlignment.start:CrossAxisAlignment.end,
        children: <Widget>[
          Text(sender,
          style: TextStyle(
            fontSize: 12,
                color:Colors.white,
          ),),
          Material(
            borderRadius:isMe? BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)
            ):BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight:
          Radius.circular(30)),
            elevation: 5,
           color:isMe?Colors.green:Colors.deepOrange,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Text(
                  text,
              style: TextStyle(
                  color:Colors.white,
                  fontSize: 15,
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  MassagesBubble(this.sender, this.text, this.isMe);
}
