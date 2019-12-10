import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:peer_learning/UI/find_mentor.dart';
import 'package:peer_learning/models/SignUpModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dashboard.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  dynamic customAlert;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    signUpModel.animate(controller);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  final SignUpModel signUpModel = SignUpModel();
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return ScopedModel<SignUpModel>(
      model: signUpModel,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Sign Up",
            style: TextStyle(fontSize: 30.0),
          ),
        ),
        backgroundColor: Colors.white,
        body: ScopedModelDescendant<SignUpModel>(
          builder: (context, child, model) => ModalProgressHUD(
            inAsyncCall: model.loadingVisible,
            child: Container(
              child: SafeArea(
                child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Hero(
                              tag: 'logo',
                              child: Image.asset('assets/images/logo.png')),
                          height: _width < _height
                              ? (_width / 4) * controller.value
                              : (_height / 4) * controller.value,
                          width: 200 * controller.value,
                        ),
                        SizedBox(
                          height: _width < _height ? _width / 20 : _height / 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, top: 16, bottom: 8),
                          child: TextFormField(
                            autofocus: false,
                            controller: model.userName,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              labelText: 'Username',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, top: 16, bottom: 8),
                          child: Form(
                            key: model.formKey,
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
                        ), //textArea for email
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, top: 16, bottom: 8),
                          child: TextFormField(
                            autofocus: false,
                            controller: model.password,
//                        validator: Validator.validatePassword,
                            obscureText: true,
                            style: TextStyle(fontSize: 18),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
//                      onChanged: getPassword(myController.text),
                          ),
                        ), //
                        // textArea for password
                        DropdownButton<String>(
                          hint: Text(model.currentValue),
                          items: <String>[
                            "Mentor",
                            'Mentee',
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              model.currentValue = value;
                            });
                          },
                        ),
                        DropdownButton<String>(
                          hint: Text(model.currentProg),
                          items: <String>[
                            "C",
                            'C++',
                            "Dart",
                            'Kotlin',
                            "Python",
                            "JavaScript",
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              model.currentProg = value;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("male"),
                            Switch(
                              value: model.isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  model.isSwitched = value;
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              //activeColor: Colors.green,
                            ),
                            Text('female'),
                          ],
                        ),
                        SizedBox(
                          height: _width < _height ? _width / 20 : _height / 20,
                        ),
                        RaisedButton(
                          onPressed: () async {
                            setState(() {
                              model.changeLoadingVisible();
                            });
                            await model.signUp(
                                context //Context require to generate alert if failure
                                );
                            setState(() {
                              model.changeLoadingVisible();
                            });
                            if (model.newUser != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FindMentor(),
                                ),
                              );
                            }
                          }, // upon login we navigate to the dashboard
                          child: Text("Sign Up"),
                        ),
                        SizedBox(
                          height: _width < _height ? _width / 20 : _height / 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
