import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({super.key, required this.category});
  final String category;

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6c8b4).withOpacity(.8),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        backgroundColor: Color(0xffe6c8b4).withOpacity(.8),
        title: Text(
          '${widget.category} Details',
          style: TextStyle(
            color: Color(0xff472121),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('design')
                    .where('category', isEqualTo: widget.category)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No Image yet'),
                    );
                  }
                  return Expanded(
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
                                    borderRadius: BorderRadius.circular(10.r),
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
                                child: snapshot.data!.docs[index]['Likeby']
                                        .contains(FirebaseAuth
                                            .instance.currentUser!.uid)
                                    ? IconButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('design')
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .update({
                                            'Likeby': FieldValue.arrayRemove([
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
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
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .update({
                                            'Likeby': FieldValue.arrayUnion([
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
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
        ),
      ),
    );
  }
}
