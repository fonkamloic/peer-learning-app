import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpModel extends Model {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  dynamic newUser;
  dynamic myController = TextEditingController();
  bool isSwitched = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  Animation animation;

  animate(controller) {
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();

    controller.addListener(() {
      notifyListeners();
    });
  }

  bool _autoValidate = false;
  bool _loadingVisible = false;
  String currentValue = "Mentor or Mentee";

  String currentProg = "Programming Language";

  String status = "Not Authenticated";

  bool get loadingVisible => _loadingVisible;

  bool get autoValidate => _autoValidate;

  Future<void> changeLoadingVisible() async {
    _loadingVisible = !_loadingVisible;
  }

  Future<void> signUp(context) async {
    try {
      newUser = await auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
    } catch (e) {
      print(e);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign up failed!"),
            content:
                Text("Username already taken or You already got an account."),
          );
        },
      );
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
