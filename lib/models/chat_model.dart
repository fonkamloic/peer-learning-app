import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peer_learning/UI/chat_forrum.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatModel extends Model {
  final messageTextController = TextEditingController();
  String messageText;
  FirebaseAuth auth = FirebaseAuth.instance;

  static final firestore = Firestore.instance;

  static getFirebaseMessage() {
    dynamic snapshots = firestore.collection("messages").snapshots();

    print(snapshots);
    return snapshots;
  }

  static FirebaseUser loggedUser;

  getMessage(value) {
    messageText = value;
    notifyListeners();
  }

  static List<MessageBubble> _messageBubbleList = [];

  List<MessageBubble> get messageBubbleList => _messageBubbleList;

  updateMessageBubble(bubble) {
    _messageBubbleList.add(bubble);
    notifyListeners();
  }

  sendMessage(String text) {
    if (text != null && text != '') {
      messageTextController.clear();
      firestore.collection("messages").add({
        "text": text,
        "sender": loggedUser.email,
      });
      messageText = '';
    }
    notifyListeners();
  }
}
