import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6c8b4).withOpacity(.8),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 70.h),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  return Column(
                    children: [
                      CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/logo_for_chat.avif')),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: 100.w,
                        height: 40.h,
                        child: Card(
                          child: Center(
                            child: Text(
                              snapshot.data!['name'],
                              style: TextStyle(
                                  color: Color(0xff472121), fontSize: 20.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 150.w,
                        height: 40.h,
                        child: Card(
                          child: Center(
                            child: Text(
                              snapshot.data!['email'],
                              style: const TextStyle(color: Color(0xff472121)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 150.w,
                        height: 40.h,
                        child: Card(
                          child: Center(
                            child: Text(
                              'Favorite Design',
                              style: const TextStyle(color: Color(0xff472121)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      GestureDetector(
                        onTap: () {
                          FirebaseAuth.instance.signOut().then((v) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
                          }).onError((error, stackTrace) {
                            print(error);
                          });
                        },
                        child: SizedBox(
                          width: 150.w,
                          height: 40.h,
                          child: Card(
                            child: Center(
                              child: Text(
                                'Logout',
                                style:
                                    const TextStyle(color: Color(0xff472121)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
