import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SinglChatScreen extends StatefulWidget {
  const SinglChatScreen({super.key, this.recieverid, this.recievername});
  final recieverid;
  final recievername;

  @override
  State<SinglChatScreen> createState() => _SinglChatScreenState();
}

class _SinglChatScreenState extends State<SinglChatScreen> {
  String getcombinID(String firstID, String secondID) {
    List<String> ids = [firstID, secondID];
    ids.sort();
    return ids.join("_");
  }

  TextEditingController messageController = TextEditingController();
  sendMessage() {
    print('send message');
    String combinId =
        getcombinID(widget.recieverid, FirebaseAuth.instance.currentUser!.uid);

    print("this is combin id $combinId");
    FirebaseFirestore.instance.collection('chat').doc(combinId).set({
      'senderid': FirebaseAuth.instance.currentUser!.uid,
      'recieverid': widget.recieverid,
      'combinid': combinId,
      'message': messageController.text.toString().trim(),
      'time': DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      print('message sent');
      messageController.clear();
    }).onError((error, stackTrace) {
      print('message not sent');
    });
    FirebaseFirestore.instance
        .collection('chat')
        .doc(combinId)
        .collection('conversation')
        .add({
      'senderid': FirebaseAuth.instance.currentUser!.uid,
      'recieverid': widget.recieverid,
      'message': messageController.text.toString().trim(),
      'time': DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      print('message sent');
      messageController.clear();
    }).onError((error, stackTrace) {
      print('message not sent');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recievername),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .doc(getcombinID(widget.recieverid,
                        FirebaseAuth.instance.currentUser!.uid))
                    .collection('conversation')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No message yet'),
                        );
                      } else {
                        return ListTile(
                          title: snapshot.data!.docs[index]['senderid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    BubbleSpecialThree(
                                      isSender: true,
                                      text: snapshot.data!.docs[index]
                                          ['message'],
                                      color: Colors.grey,
                                      tail: true,
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    BubbleSpecialThree(
                                      isSender: false,
                                      text: snapshot.data!.docs[index]
                                          ['message'],
                                      color: Color(0xFF1B97F3),
                                      tail: true,
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                        );
                      }
                    },
                  );
                }),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300.w,
                  height: 50.w,
                  child: TextField(
                    controller: messageController,
                    style: TextStyle(fontSize: 18.sp, color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Enter message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.teal,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
