import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peer_learning/components/constants.dart';
import 'package:peer_learning/models/chat_model.dart';
import 'package:scoped_model/scoped_model.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedUser;

class ChatForrum extends StatefulWidget {
  @override
  _ChatForrumState createState() => _ChatForrumState();
}

class _ChatForrumState extends State<ChatForrum> {
  final _auth = FirebaseAuth.instance;

  final messageTextController = TextEditingController();
  String messageText;

  @override
  void initState() {
    super.initState();
    getRegisterUser();
  }

  void getRegisterUser() async {
    try {
      final newUser = await _auth.currentUser();
      if (newUser != null) {
        loggedUser = newUser;
        print(loggedUser.email);
      }
    } catch (e) {
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
                //      getMessageStream();
              }),
        ],
        title: Text('♨Community'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (messageText != null && messageText != '') {
                        messageTextController.clear();
                        _firestore.collection("messages").add({
                          "text": messageText,
                          "sender": loggedUser.email,
                        });
                        messageText = '';
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.lightBlueAccent,
                    ),
//                    child: Text(
//                      'Send',
//                      style: kSendButtonTextStyle,
//                    ),
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

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        List<MessageBubble> messageBubbleList = [];
        for (var message in messages) {
          String messageText = message.data['text'];
          String messageSender = message.data['sender'];

          final currentUser = loggedUser.email;

          if (currentUser == messageSender) {
            //
          }
          dynamic messageBubble = MessageBubble(
            message: messageText,
            sender: messageSender,
            isMe: messageSender == currentUser,
          );
          messageBubbleList.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbleList,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.message, this.sender, this.isMe});
  final String message, sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 7.0),
                child: Text(
                  message,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: isMe ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
