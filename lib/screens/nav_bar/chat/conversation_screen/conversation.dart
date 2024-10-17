import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:messaging/screens/nav_bar/chat/single_chat_screen/single_chat_screen.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  getTime(timestampMs) {
    // Convert milliseconds to seconds
    int timestampSec = (timestampMs / 1000).round();

    // Convert to DateTime
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestampSec * 1000, isUtc: true);

    // Extract hour and minute
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6c8b4).withOpacity(.8),
      appBar: AppBar(
        backgroundColor: Color(0xffe6c8b4).withOpacity(.8),
        title: Text(
          'Conversation',
          style: TextStyle(
            color: Color(0xff472121),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('chat').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var chatlist = snapshot.data!.docs.where((element) {
                      String combinid = element['combinid'];
                      return combinid
                          .contains(FirebaseAuth.instance.currentUser!.uid);
                    }).toList();
                    return ListView.builder(
                      itemCount: chatlist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Color(0xff472121),
                            child: ListTile(
                              // tileColor: Colors.grey[200],
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SinglChatScreen(
                                              recieverid: chatlist[index]
                                                  ['recieverid'],
                                              recievername: chatlist[index]
                                                  ['recievername'],
                                            )));
                              },
                              title: Text(
                                chatlist[index]['recievername'],
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Color(0xffe6c8b4),
                                ),
                              ),
                              subtitle: Text(
                                chatlist[index]['message'],
                                style: TextStyle(
                                  color: Color(0xffe6c8b4),
                                ),
                              ),
                              trailing: Text(
                                getTime(
                                  chatlist[index]['time'],
                                ),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xffe6c8b4),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No message yet'),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
