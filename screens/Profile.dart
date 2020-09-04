import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/screens/HomePage.dart';
import 'package:flash_chat/screens/otherProfile.dart';
import 'package:flash_chat/utilities/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:math';
import 'chat_screen.dart';

int numberOfPosts;
int followers;
int following;
FirebaseUser loggedInUSer;
final _auth = FirebaseAuth.instance;
bool showSpinner = false;
String email;
String photourl;

class Profile extends StatefulWidget {
  static const String id = 'MyHomePage';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
//    Firestore.instance
//        .collection('users')
//        .document(loggedInUSer.email)
//        .collection('following')
//        .add({'email':'r@g.com'});
//    // setState(() {});
//    print('a7aaaaaaaaaaaaaaaaaaaa');
    try {
      QuerySnapshot _myDoc = await Firestore.instance
          .collection('storage')
          .where('email', isEqualTo: loggedInUSer.email)
          .getDocuments();
      List<DocumentSnapshot> _myDocCount = _myDoc.documents;
      numberOfPosts = _myDocCount.length;

      _myDoc = await Firestore.instance
          .collection('users')
          .document(loggedInUSer.email)
          .collection('followers')
          .getDocuments();
      _myDocCount = _myDoc.documents;
      followers = _myDocCount.length;

      _myDoc = await Firestore.instance
          .collection('users')
          .document(loggedInUSer.email)
          .collection('following')
          .getDocuments();
      _myDocCount = _myDoc.documents;
      following = _myDocCount.length;
      print(_myDocCount.length);
    } catch (e) {

      print('ssssssssssssssssssssssssssssssssssssssss$e');
    }
    await Firestore.instance
        .collection('users')
        .document(loggedInUSer.email)
        .get()
        .then((DocumentSnapshot ds) {
      photourl = ds.data['profilePicture.url'];
    });
    await Firestore.instance
        .collection('users')
        .document(loggedInUSer.email)
        .get()
        .then((DocumentSnapshot ds) {
      name = ds.data['name'];
    });
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
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom:8.0),
                        child: CircleAvatar(
                            radius: 50,
                            backgroundImage: photourl == null
                                ? AssetImage('images/logo.png')
                                : NetworkImage(photourl),
                            //   'assets/images/lake.jpg
                            ),
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
                    RoundedButton('Edit Profile', Colors.deepOrange, () {
                      setState(() {
                        //     Navigator.pushNamed(context, RegistrationScreen.id);
                      });
                    }),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Divider(thickness: 2, color: Colors.deepOrange),
            ),
//            Flexible(
//              child: working(),
//            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getImage(),
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

Future getImage() async {
  // Get image from gallery.

  // ignore: deprecated_member_use
  var image = await ImagePicker.pickImage(source: ImageSource.gallery);

  File cropped = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
      maxWidth: 700,
      maxHeight: 700,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.deepOrange,
        toolbarTitle: "RPS Cropper",
        statusBarColor: Colors.deepOrange.shade900,
        backgroundColor: Colors.white,
      ));
  _uploadImageToFirebase(cropped);
}

Future<void> _uploadImageToFirebase(File image) async {
  try {
    // Make random image name.
//File cropedfile=await ImageCropper
    int randomNumber = Random().nextInt(100000);

    String imageLocation = 'images/image${randomNumber}.jpg';

    // Upload image to firebase.

    final StorageReference storageReference =
        FirebaseStorage().ref().child(imageLocation);

    final StorageUploadTask uploadTask = storageReference.putFile(image);

    await uploadTask.onComplete;

    _addPathToDatabase(imageLocation);
  } catch (e) {
    print(e.message);
  }
}
Future<void> _addPathToDatabase(String text) async {
  try {
    // Get image URL from firebase

    final ref = FirebaseStorage().ref().child(text);

    var imageString = await ref.getDownloadURL();

    // Add location and url to database
    await Firestore.instance.collection('storage').add({
      'email': loggedInUSer.email,
      'url': imageString,
      'location': text,
      'timestamp': DateTime.now()
    });
  } catch (e) {
    print(e.message);

    showDialog(builder: (context) {
      return AlertDialog(
        content: Text(e.message),
      );
    });
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

class working extends StatelessWidget {
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('storage')
          .where('email', isEqualTo: loggedInUSer.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: Container(
              color: Colors.black,
            ),
          );
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
