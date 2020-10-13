import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore  = Firestore.instance;

class ChatScreen extends StatefulWidget {
  static const  String id = "Chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String message;
  final _auth = FirebaseAuth.instance;

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[
            Messagestream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(

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

class MessageBubble extends StatelessWidget {
  MessageBubble({this.Sender,this.TextMsg});
  final TextMsg;
  final Sender;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("$Sender" , style: TextStyle(
            color: Colors.black87,
            fontSize: 12
          ),),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 10,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text('$TextMsg' ,style: TextStyle(
                fontSize: 15
              ),),
            ),

          ),
        ],
      ),
    );
  }
}

class Messagestream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          if(!snapshot.hasData)
          {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          else
          {
            final messages = snapshot.data.docs;
            List<MessageBubble>messagewidgets=[];
            for(var message in messages)
            {
              final messageText = message.data()['text'];
              final messageSender = message.data()['sender'];
              final messageBubbler = MessageBubble(Sender: messageSender,TextMsg: messageText,);
              messagewidgets.add(messageBubbler);
            }
            return Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: messagewidgets
                    ),],
                )

            );
          }
        }
    );
  }
}
