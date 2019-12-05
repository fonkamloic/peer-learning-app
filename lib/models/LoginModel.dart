import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginModel extends Model {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  dynamic user;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  bool _autoValidate = false;
  bool _loadingVisible = false;
  Animation animation;

  animate(controller) {
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();

    controller.addListener(() {
      notifyListeners();
    });
  }

  String status = "Not Authenticated";

  bool get loadingVisible => _loadingVisible;

  bool get autoValidate => _autoValidate;

  Future<void> changeLoadingVisible() async {
    _loadingVisible = !_loadingVisible;
  }

  Future<void> login(context) async {
    try {
      user = await auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
    } catch (e) {
      print(e);
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Sign in failed!"),
              content: Text(
                  "Your email/username is incorrect. Please check again and retry."),
            );
          });
    }
  }

  void signInAnon() async {
    FirebaseUser user = (await auth.signInAnonymously()).user;
    if (user != null && user.isAnonymous == true) {
      status = "Signed in Anonymously";
    } else {
      status = "Sign in failed";
    }
    notifyListeners();
  }

  void signOut() async {
    await auth.signOut();

    status = "Signed Out";
    //no need to call notifyListener since we will pop page
  }
}
