import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/custom_widget/custom_button.dart';
import 'package:messaging/screens/auth/sign_up_screen.dart';
import 'package:messaging/screens/home_screen/show_all_user.dart';
import 'package:messaging/utils/popup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  void login() {
    setState(() {
      isloading = true;
    });
    auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString().trim(),
            password: passwordController.text.toString().trim())
        .then((v) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ShowData()));
      setState(() {
        isloading = false;
      });
      ToastPopUp().toast('Sign In successful', Colors.green, Colors.white);
    }).onError((Error, v) {
      ToastPopUp().toast(Error.toString(), Colors.red, Colors.white);
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: const Text('SIgn In'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'Sign In',
                  height: 50.h,
                  width: 200.w,
                  isloading: isloading,
                  color: Colors.teal,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'Sign Up',
                  height: 50.h,
                  width: 200.w,
                  isloading: isloading,
                  color: Colors.teal.withOpacity(.6),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignUpScreen();
                    }));
                  },
                )
              ],
            ),
          ),
        ));
  }
}
