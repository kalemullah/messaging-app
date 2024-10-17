import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging/screens/auth/sign_up_screen.dart';
import 'package:messaging/screens/home_screen/show_all_user.dart';

class SplashService {
  void islogin(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      FirebaseAuth auth = FirebaseAuth.instance;
      final user = auth.currentUser;

      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ShowData()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
      }
    });
  }
}
