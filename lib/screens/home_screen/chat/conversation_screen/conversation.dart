import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:messaging/screens/home_screen/chat/single_chat_screen/single_chat_screen.dart';

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
      appBar: AppBar(
        title: const Text('Conversation'),
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
                            child: ListTile(
                              tileColor: Colors.grey[200],
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
                              title: Text(chatlist[index]['recievername']),
                              subtitle: Text(chatlist[index]['message']),
                              trailing: Text(getTime(chatlist[index]['time'])),
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
