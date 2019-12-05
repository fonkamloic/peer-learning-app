import 'package:flutter/material.dart';
import 'package:peer_learning/UI/LoadingScreen.dart';
import 'package:peer_learning/models/AppModel.dart';
import 'package:peer_learning/services/service_locator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'UI/signup.dart';
import 'UI/signin.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScopedModel<AppModel>(
        model: AppModel(),
        child: LoadingScreen(),
      ),
    );
  }
}
