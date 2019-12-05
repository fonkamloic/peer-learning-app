import 'package:flutter/material.dart';

class ChatForrum extends StatefulWidget {
  @override
  _ChatForrumState createState() => _ChatForrumState();
}

class _ChatForrumState extends State<ChatForrum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forrum"),
      ),
      body: Center(
        child: Text("chat area "),
      ),
    );
  }
}
