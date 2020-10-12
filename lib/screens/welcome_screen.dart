import 'dart:math';

import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/loginbutton.dart';
class WelcomeScreen extends StatefulWidget {
   static const String id = "WelcomeScreen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin{

  AnimationController background, logosymbol;
  Animation animation;
  Animation bganimation;
  @override
  void initState() {
    super.initState();
    background = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    bganimation = ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(background);
    background.forward();
    background.addListener(() {
      setState(() {
      });
    });
    logosymbol = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(parent: logosymbol,curve: Curves.bounceOut);
    // animation.addStatusListener((status) {
    //   if(status == AnimationStatus.completed)
    //     {
    //       logosymbol.reverse(from: 0.8);
    //     }
    //   else if(status == AnimationStatus.dismissed)
    //     {
    //       logosymbol.forward();
    //     }
    // });
    logosymbol.forward();
    logosymbol.addListener(() {
      setState(() {

      });
    });
  }
  @override
  void dispose() {
    logosymbol.dispose();
    background.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bganimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset("images/animation.png"),
                    height: animation.value * 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text:[' Hamari Chat'],
                  textStyle: TextStyle(
                    fontSize: 39.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                      fontFamily: "Horizon"
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Logintypebutton(
              colour:Colors.lightBlueAccent ,
              onpress: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
              value: 'Log In',
            ),
            Logintypebutton(colour: Colors.blueAccent, onpress:() {
              Navigator.pushNamed(context, RegistrationScreen.id);
            },
                value:'Register' ,
                )

          ],
        ),
      ),
    );
  }
}

