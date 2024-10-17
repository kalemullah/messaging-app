import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging/custom_widget/custom_button.dart';

class AddImages extends StatefulWidget {
  const AddImages({super.key});

  @override
  State<AddImages> createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  String hintext = "male";
  XFile? image;
  File? imageFile;
  bool isdataadded = false;
  String url = '';
  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.camera);
    print('image path ${image!.path}');
    if (image == null) {
      return;
    } else {
      setState(() {
        imageFile = File(image!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6c8b4),
      appBar: AppBar(
        backgroundColor: Color(0xffe6c8b4),
        title: const Text(
          'Add Images',
          style: TextStyle(
            color: Color(0xff472121),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.only(left: 55.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select category',
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: const Color(0xff472121),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 50.h,
              width: 250.w,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Center(
                  child: DropdownButton(
                      underline: Container(),
                      isExpanded: true,
                      hint: Text(
                        hintext,
                        style: TextStyle(color: Colors.black),
                      ),
                      items: ['first', 'second'].map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          hintext = v.toString();
                        });
                      }),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            image != null
                ? Container(
                    height: 200,
                    width: 250.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        fit: BoxFit.cover,
                        File(image!.path),
                        height: 200.0,
                        width: 200.0,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () => pickImage(),
                    child: Container(
                      height: 200,
                      width: 250.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Add Images',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 40.h),
            CustomButton(
              text: 'Add Design',
              height: 50.h,
              width: 250.w,
              isloading: isdataadded,
              color: Color(0xff472121),
              onPressed: () async {
                setState(() {
                  isdataadded = true;
                });
                if (imageFile != null) {
                  String fileName =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  Reference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child('images/$fileName');
                  // firebaseStorageRef.putFile(imageFile!);
                  UploadTask uploadTask =
                      firebaseStorageRef.putFile(imageFile!);
                  await uploadTask;

                  url = await firebaseStorageRef.getDownloadURL();
                }
              
                String timestamp =
                    DateTime.now().millisecondsSinceEpoch.toString();
                FirebaseFirestore.instance
                    .collection('design')
                    .doc(timestamp)
                    .set({
                  'category': hintext,
                  'designid': timestamp,
                  'isApproved': false,
                  'createdBy': FirebaseAuth.instance.currentUser!.uid,
                  'designImage': url,
                  'Likeby': [],
                }).then((value) {
                  print('data added');
                  setState(() {
                    isdataadded = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
