import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/screens/Page.dart';
import 'package:flash_chat/utilities/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/components/constants.dart';
import 'package:flash_chat/components/reusable_card.dart';
import 'package:flash_chat/components/icon_content.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'Profile.dart';

enum Gender {
  male,
  female,
}

class Information extends StatefulWidget {
  static const String id = 'Information';
  @override
  _InformationState createState() => _InformationState();
}

String purl = 'null';
FirebaseUser loggedInUSer;
final _auth = FirebaseAuth.instance;

class _InformationState extends State<Information> {
  String name;
  Gender selectedGender;
  int height = 180;
  int weight = 60;
  double age = 0;
  var selectedYear;
  DateTime dt;
  void initState() {
    // TODO: implement initState
    getCurrentUSer();
    super.initState();
  }

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
    setState(() {});
  }

  DateTime _showPicker() {
    showDatePicker(
            context: context,
            firstDate: DateTime(1920),
            initialDate: DateTime.now(),
            lastDate: DateTime.now())
        .then((dt) {
      selectedYear = dt.year;
      //  calculateAge();
      print(
          'lllllllllllllllllllllllllllllllllllllllllllllllllllll                              $dt');
      return dt;
    });
  }

  void calculateAge() {
    setState(() {
      age = (DateTime.now().year - selectedYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('INFO'),
      ),
      body: ListView(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: FlatButton(
              onPressed: () async {
                  purl = await getImage();
                  print('sssssssssssssssssssssss   $purl');
                setState(() {});
              },
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                backgroundImage:
//                    purl=='null'?
//                    AssetImage('images/logo.jpg')
//                        :
                    NetworkImage(purl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: TextFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Display Name',
                  labelStyle: TextStyle(fontSize: 22, color: Colors.white)),
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
                //Do something with the user input.
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ReusableCard(
                  onPress: () {
                    setState(() {
                      selectedGender = Gender.male;
                    });
                  },
                  colour: selectedGender == Gender.male
                      ? kActiveCardColour
                      : kInactiveCardColour,
                  cardChild: IconContent(
                    icon: FontAwesomeIcons.mars,
                    label: 'MALE',
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  onPress: () {
                    setState(() {
                      selectedGender = Gender.female;
                    });
                  },
                  colour: selectedGender == Gender.female
                      ? kActiveCardColour
                      : kInactiveCardColour,
                  cardChild: IconContent(
                    icon: FontAwesomeIcons.venus,
                    label: 'FEMALE',
                  ),
                ),
              ),
            ],
          ),
//        FlatButton(
//        ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: RoundedButton(
              'Enter your Age',
              Colors.redAccent,
              () async {
                setState(() async {
                  dt = await _showPicker();
                  print('kokooooooooooooooooooooooooooooooooo   $dt');
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: RoundedButton('Register', Colors.deepOrange, () async {
              String ggg='Female';
              selectedGender==Gender.male?ggg='male':ggg;
              print(
                  'ssssssssssssssssssssssssssssssss   www $dt $name $ggg  ');
              setState(() {
                showSpinner = true;
              });
              print('beyewsaalaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
              try {
            await Firestore.instance
                    .collection('users')
                    .document(loggedInUSer.email)
                    .setData({'name': name,'gender': ggg,'profilePicture.url': purl,}) ;
                print('doneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
              setState(() {
                  showSpinner = false;
                });
              } catch (error) {
                showSpinner = false;
                print('reyaddddddddddddddddddddddddddddd $error');
                setState(() {
                  showSpinner = false;
                });
              }
              setState(() {
                showSpinner = false;
              });
              //Go to login screen.
             Navigator.pushReplacementNamed(context, Page.id);
            }),
          ),

        ],
      ),
    );
  }
}

Future<String> getImage() async {
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

  return _uploadImageToFirebase(cropped);
}

Future<String> _uploadImageToFirebase(File image) async {
  try {
    // Make random image name.
//File cropedfile=await ImageCropper

    String imageLocation = 'ProfileImages/image${loggedInUSer.email}.jpg';

    // Upload image to firebase.

    final StorageReference storageReference =
        FirebaseStorage().ref().child(imageLocation);

    final StorageUploadTask uploadTask = storageReference.putFile(image);

    await uploadTask.onComplete;

    return _addPathToDatabase(imageLocation);
  } catch (e) {
    print(e.message);
  }
}

Future<String> _addPathToDatabase(String text) async {
  try {
    // Get image URL from firebase

    final ref = FirebaseStorage().ref().child(text);

    var imageString = await ref.getDownloadURL();
    purl=imageString.toString();
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$purl');
    // Add location and url to database
    return imageString;
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
