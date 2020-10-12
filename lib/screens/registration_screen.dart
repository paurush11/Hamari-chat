import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool spin = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spin,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
             children: [Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: <Widget>[

                 Hero(
                   tag: "logo",
                   child: Container(
                     height: 200.0,
                     child: Image.asset("images/animation.png"),
                   ),
                 ),
                 SizedBox(
                   height: 48.0,
                 ),
                 TextField(
                     textAlign: TextAlign.center,
                     keyboardType: TextInputType.emailAddress,
                     cursorColor: CupertinoColors.black,
                     onChanged: (value) {
                      email = value;
                     },
                     decoration: Kdecorationforinput.copyWith(hintText: "Enter your email")
                 ),
                 SizedBox(
                   height: 8.0,
                 ),
                 TextField(
                     textAlign: TextAlign.center,
                     keyboardType: TextInputType.visiblePassword,
                     cursorColor: CupertinoColors.black,
                     obscureText: true,
                     onChanged: (value) {
                       //Do something with the user input.
                       password = value;
                     },

                     decoration: Kdecorationforinput.copyWith(hintText: "Enter your password")
                 ),
                 SizedBox(
                   height: 24.0,
                 ),
                 Padding(
                   padding: EdgeInsets.symmetric(vertical: 16.0),
                   child: Material(
                     color: Colors.blueAccent,
                     borderRadius: BorderRadius.all(Radius.circular(30.0)),
                     elevation: 5.0,
                     child: MaterialButton(
                       onPressed: () async{
                         setState(() {
                           spin = true;
                         });
                         try{
                           final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                           if(newUser!=null)
                             {
                               Navigator.pushNamed(context, ChatScreen.id);
                             }
                           setState(() {
                             spin = false;
                           });
                         }
                         catch(e)
                         {
                           print(e);
                           setState(() {
                             spin = false;
                           });
                         }

                       },
                       minWidth: 200.0,
                       height: 42.0,
                       child: Text(
                         'Register',
                         style: TextStyle(color: Colors.white),
                       ),
                     ),
                   ),
                 ),
               ],
             ),],
          ),
        ),
      ),
    );
  }
}
