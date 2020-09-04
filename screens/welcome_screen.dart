import 'dart:async';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  void delay(){
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    });
  }
  //Tickerproviderstate
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    delay();
    controller = AnimationController(
        duration: Duration(seconds: 4), //3sec
        vsync: this,
        upperBound: 1);
    //  animation=CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    //controller.reverse(from: 1);
//   animation.addStatusListener((status) {
//   if(status==AnimationStatus.completed){
//     controller.reverse(from: 1);
//   }
//   else if(status==AnimationStatus.dismissed){
//     controller.forward();
//   }
//   });
    animation =
        ColorTween(begin: Colors.black26, end: Colors.deepOrange).animate(controller);
    controller.addListener(() {
      setState(() {});
      //    print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      //.withOpacity(controller.value),
      body: Container(
//        decoration: BoxDecoration(
//            image: DecorationImage(
//              image: AssetImage('images/image.png'),
//              fit: BoxFit.cover,
//            )),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    TypewriterAnimatedTextKit(
                      text: ['Mood Book'],
                      //  '${controller.value.toInt()}%',
                      textStyle: TextStyle(
                        color:Colors.white,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('images/envelope.png'),
                        //   height: animation.value*100,
                        height: 140,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 48.0,
              ),

//              RoundedButton('Login In', Color(0xFFEB1555), () {
//                //Go to login screen.
//                Navigator.pushNamed(context, LoginScreen.id);
//              }),
//              RoundedButton('Register', Colors.blueAccent, () {
//                //Go to registration screen.
//                Navigator.pushNamed(context, RegistrationScreen.id);
//              }),
            ],
          ),
        ),
      ),
    );
  }
}
