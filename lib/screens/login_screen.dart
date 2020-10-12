import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "Login_id";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool spin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spin,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Hero(
                      tag: "logo",
                      child: Container(
                        height: 200.0,
                        child: Image.asset('images/animation.png'),
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
                        decoration: Kdecorationforinput
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: Kdecorationforinput.copyWith(hintText: "enter your password")
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              spin = true;
                            });
                            try{
                              final loggedinuser = _auth.signInWithEmailAndPassword(email: email, password: password);
                              if(loggedinuser!=null)
                                {
                                  Navigator.pushNamed(context, ChatScreen.id);
                                }
                              setState(() {
                                spin = false;
                              });
                            }catch(e)
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
                            'Log In',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
          ),
        ),
      ),
    );
  }
}
