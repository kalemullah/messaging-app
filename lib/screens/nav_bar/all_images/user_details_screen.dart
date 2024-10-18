import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/screens/nav_bar/chat/single_chat_screen/single_chat_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, this.userid});
  final userid;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6c8b4).withOpacity(.8),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Color(0xffe6c8b4).withOpacity(.8),
        title: const Text(
          'Details',
          style: TextStyle(
            color: Color(0xff472121),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  return Column(
                    children: [
                      const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/logo_for_chat.avif')),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: 300.w,
                        height: 40.h,
                        child: Card(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data!['name'],
                                    style: TextStyle(
                                        color: Color(0xff472121),
                                        fontSize: 20.sp),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => SinglChatScreen(
                                                      recieverid: widget.userid,
                                                      recievername: snapshot
                                                          .data!['name'],
                                                    )));
                                        // SinglChatScreen()
                                      },
                                      child: Icon(Icons.chat))
                                ],
                              ),
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 35.w),
                          child: Text(
                            'All Design',
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff472121)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('design')
                              .where('createdBy',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Error');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('No Image yet'),
                              );
                            }
                            return SizedBox(
                              height: 345.h,
                              child: GridView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        Center(
                                          child: Card(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              child: Image.network(
                                                  fit: BoxFit.cover,
                                                  snapshot.data!.docs[index]
                                                      ['designImage']),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 20.w,
                                          bottom: 0,
                                          child: snapshot
                                                  .data!.docs[index]['Likeby']
                                                  .contains(FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              ? IconButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('design')
                                                        .doc(snapshot.data!
                                                            .docs[index].id)
                                                        .update({
                                                      'Likeby': FieldValue
                                                          .arrayRemove([
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                      ])
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  ))
                                              : IconButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('design')
                                                        .doc(snapshot.data!
                                                            .docs[index].id)
                                                        .update({
                                                      'Likeby': FieldValue
                                                          .arrayUnion([
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                      ])
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.red,
                                                  )),
                                        ),
                                      ],
                                    );
                                  }),
                            );
                          })
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
