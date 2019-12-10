import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peer_learning/UI/chat_forrum.dart';
import 'package:peer_learning/UI/dashboard.dart';
import 'package:peer_learning/UI/signup.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:peer_learning/models/LoginModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/animation.dart';

class SigninPage extends StatefulWidget {
  static String tag = 'login';

  @override
  State<StatefulWidget> createState() {
    return _SigninPageState();
  }
}

class _SigninPageState extends State<SigninPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  dynamic customAlert;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    loginModel.animate(controller);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  final LoginModel loginModel = LoginModel();

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return ScopedModel<LoginModel>(
      model: loginModel,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.blue,
            title: Text(
              'Sign In',
              style: TextStyle(fontSize: 30.0),
            ),
          ),
          body: ScopedModelDescendant<LoginModel>(
            builder: (context, child, model) => ModalProgressHUD(
              inAsyncCall: model.loadingVisible,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: Form(
                    key: model.formKey,
                    autovalidate: model.autoValidate,
                    child: ListView(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: Hero(
                                  tag: 'logo',
                                  child: Image.asset('assets/images/logo.png')),
                              height: _width < _height
                                  ? (_width / 4) * controller.value
                                  : (_height / 4) * controller.value,
                              width: 150 * controller.value,
                            ),
                            SizedBox(
                              height:
                                  _width < _height ? _width / 20 : _height / 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 22, right: 22, top: 16, bottom: 8),
                              child: TextFormField(
                                autofocus: false,
                                controller: model.email,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 22, right: 22, top: 8, bottom: 8),
                              child: TextFormField(
                                autofocus: false,
                                controller: model.password,
                                obscureText: true,
                                style: TextStyle(fontSize: 18),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  _width < _height ? _width / 20 : _height / 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 22, right: 22, top: 16, bottom: 8),
                              child: Container(
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: FlatButton(
                                  shape: new RoundedRectangleBorder(),
                                  onPressed: () async {
                                    setState(() {
                                      model.changeLoadingVisible();
                                    });
                                    await model.login(context
                                        //context required to create alert if failure
                                        );
                                    setState(() {
                                      model.changeLoadingVisible();
                                    });
                                    if (model.user != null) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Dashboard(),
                                        ),
                                      );
                                    }
                                    /* Anonymous signIn
                                    try {
                                      _signInAnon();

                                      if (_status == "Signed in Anonymously") {}
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Dashboard()));
                                    } catch (e) {
                                      print(e);
                                    }

                                     */
                                  },
                                  color: Colors.blue,
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Raleway',
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text("Create an account:"),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()));
                              },
                              child: Text("sign up"),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
