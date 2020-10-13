import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const  String id = "Chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String message;
  final _auth = FirebaseAuth.instance;
  final _firestore  = Firestore.instance;
  User loggedinuser;
  @override
  void initState() {
    // TODO: implement initState
    getdata();
    //getmessages();
    getrealtimemsg();
    super.initState();
  }
  void getdata() async {
    try{
      final user = await _auth.currentUser;
      if(user!=null)
      {
        loggedinuser = user;
        print(loggedinuser.email);
      }
    }catch(e)
    {
      print(e);
    }
  }
  // void getmessages() async {
  //   try{
  //     final messages = await _firestore.collection("messages").get();
  //     for(var msg in messages.docs)
  //       {
  //         print(msg.data());
  //       }
  //   }catch(e){
  //     print(e);
  //   }
  // }
  void getrealtimemsg() async{
    try{
      await for(var snapshot in _firestore.collection("messages").snapshots())
        {
          for(var msg in snapshot.docs)
          {
            print(msg.data());
          }

        }
    }catch(e)
    {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  if(snapshot.hasData)
                    {
                      final messages = snapshot.data.docs;
                      List<Text> messagewidgets=[];
                      for(var message in messages)
                        {
                          final messageText = message.data()['text'];
                          final messageSender = message.data()['sender'];
                          final messagewidget = Text('$messageText is sent from $messageSender');
                          messagewidgets.add(messagewidget);
                        }
                      return Column(
                          children: messagewidgets
                      );

                    }
                }
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'text': message,
                        'sender': loggedinuser.email
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
