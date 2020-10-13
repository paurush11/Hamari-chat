import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore  = Firestore.instance;
User loggedinuser;

class ChatScreen extends StatefulWidget {
  static const  String id = "Chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagecontroller =  TextEditingController();
  String message;
  final _auth = FirebaseAuth.instance;


  @override
  void initState() {
    getdata();

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
                      controller: messagecontroller,
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
                        'sender': loggedinuser.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      messagecontroller.clear();
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
  MessageBubble({this.Sender,this.TextMsg,this.isMe});
  final TextMsg;
  final Sender;
  bool isMe;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text("$Sender" , style: TextStyle(
            color: Colors.black87,
            fontSize: 12
          ),),
          Material(
            borderRadius: isMe?BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30)
            ):BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30)
            ),
            elevation: 10,
            color: isMe? Colors.blueAccent:Colors.greenAccent,
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
        stream: _firestore.collection('messages').orderBy('timestamp', descending: false).snapshots(),
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
              final currentuser = loggedinuser.email;
              bool val;
              if(currentuser!=messageSender)
                  val = false;
              else
                  val = true;
              final messageBubbler = MessageBubble(Sender: messageSender,TextMsg: messageText,isMe: val,);
              messagewidgets.add(messageBubbler);
            }
            return Expanded(
                child: ListView(
                  reverse: true,
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
