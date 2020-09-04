import 'package:flash_chat/screens/HomePage.dart';
import 'package:flash_chat/screens/Information.dart';
import 'package:flash_chat/screens/Page.dart';
import 'package:flash_chat/screens/Profile.dart';
import 'package:flash_chat/screens/otherProfile.dart';
import 'package:flash_chat/screens/searchScreen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/Information.dart';
void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  var _pages = [HomePage.id, ChatScreen.id, Profile.id];
  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      //home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        LoginScreen.id: (context) => LoginScreen(),
       ChatScreen.id: (context) => ChatScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        Information.id: (context) => Information(),
        Profile.id: (context) => Profile(),
        HomePage.id: (context) => HomePage(),
        Page.id: (context) => Page(),
        otherProfile.id:(context) => otherProfile(),
        // SearchScreen.id: (context) => SearchScreen(),
      },
    );
  }
}
