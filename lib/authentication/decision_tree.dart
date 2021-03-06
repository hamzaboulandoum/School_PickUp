import 'package:e_shcool_bus/home_page.dart';
import 'package:flutter/material.dart';
import 'package:e_shcool_bus/authentication/sign_up_page.dart';
import 'package:e_shcool_bus/authentication/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class DecisionTree extends StatefulWidget {
  const DecisionTree({Key? key}) : super(key: key);

  //bool login = true; // we have added this variable login
  @override
  _DecisionTreeState createState() => _DecisionTreeState();
}

class _DecisionTreeState extends State<DecisionTree> {
  bool login = true;
  User? user;
  String schoolId = "";

  @override //polymorphism which means changing a fucntion
  void initState() {
    super.initState(); //inherits the constructor of super class
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred) {
    setState(() {
      user = userCred; // it only sets the state by changing variable everywhere
      // so that the changes could happen.
    });
  }

  onIdChanged(schoolSignUpId) {
    setState(() {
      schoolId =
          schoolSignUpId; // it only sets the state by changing variable everywhere
      // so that the changes could happen.
    });
  }

  onLogInChanged(loginresult) {
    setState(() {
      login = loginresult;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      if (login == true) {
        return LoginPage(
          onSignIn: (userCred) => onRefresh(userCred),
          loginchanged: (loginresult) => onLogInChanged(loginresult),
        );
      } else {
        return SignUpPage(
            onSignUp: (userCred) => onRefresh(userCred),
            loginchanged: (loginresult) => onLogInChanged(loginresult),
            schoolId: (schoolSignUpId) => onIdChanged(schoolSignUpId));
      }
    }
    return HomePage(
      onSignOut: (userCred) => onRefresh(userCred),
      schoolID: schoolId,
    );
  }
}
