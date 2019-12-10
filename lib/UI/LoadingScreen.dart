import 'package:splashscreen/splashscreen.dart';

import 'package:flutter/material.dart';
import 'package:peer_learning/UI/signin.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => new _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "logo",
      child: SplashScreen(
        seconds: 2,
        navigateAfterSeconds: SigninPage(),
        title: Text(
          'Welcome to Peer Learning',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25.0 * controller.value),
        ),
        image: Image.asset(
          'assets/images/logo.png',
        ),
        gradientBackground: new LinearGradient(
            colors: [Colors.cyan, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 70.0 * controller.value,
        onClick: () => {},
        loaderColor: Colors.grey,
      ),
    );
  }
}
