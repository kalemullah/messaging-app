import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging/screens/nav_bar/all_images/user_details_screen.dart';

class AllImages extends StatefulWidget {
  const AllImages({super.key});

  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('design')
                .where('createdBy',
                    isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No Image yet'),
                );
              }
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Center(
                          child: Card(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                  fit: BoxFit.cover,
                                  snapshot.data!.docs[index]['designImage']),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 13.h,
                            left: 26.w,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserDetailsScreen(
                                              userid: snapshot.data!.docs[index]
                                                  ['createdBy'],
                                            )));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(17)),
                                  child: Icon(Icons.person)),
                            )),
                        Positioned(
                            right: 20.w,
                            bottom: 0,
                            child: snapshot.data!.docs[index]['Likeby']
                                    .contains(
                                        FirebaseAuth.instance.currentUser!.uid)
                                ? IconButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('design')
                                          .doc(snapshot.data!.docs[index].id)
                                          .update({
                                        'Likeby': FieldValue.arrayRemove([
                                          FirebaseAuth.instance.currentUser!.uid
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
                                          .doc(snapshot.data!.docs[index].id)
                                          .update({
                                        'Likeby': FieldValue.arrayUnion([
                                          FirebaseAuth.instance.currentUser!.uid
                                        ])
                                      });
                                    },
                                    icon: const Icon(Icons.favorite_border)))
                      ],
                    );
                  });
            }));
  }
}
