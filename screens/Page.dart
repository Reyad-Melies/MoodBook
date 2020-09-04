import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flash_chat/screens/otherProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'Profile.dart';
import 'chat_screen.dart';

var _pages = [ HomePage(),Profile(),ChatScreen(),otherProfile()];
int _seletedItem =0;

class Page extends StatefulWidget {
  static const String id = 'Page';
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  var _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        color: Colors.deepOrange,
        backgroundColor: Color(0xFF1D1E33),
        buttonBackgroundColor: Colors.white,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.account_circle,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.chat,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.notifications,
            size: 30,
            color: Colors.black,
          ),
        ],
        animationDuration: Duration(
          microseconds: 200,
        ),
        index: _seletedItem,
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          setState(() {

            _seletedItem = index;

            _pageController.animateToPage(_seletedItem,

                duration: Duration(milliseconds: 200), curve: Curves.linear);

          });
//          if (index == 1)
//            Navigator.pushNamed(context, HomePage.id);
//          else if (index == 2) Navigator.pushNamed(context, Profile.id);

        },
      ),
      body: PageView(
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _seletedItem = index;
          });
        },
        controller: _pageController,
      ),
    );
  }
}
