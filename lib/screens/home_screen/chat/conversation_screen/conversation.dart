import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
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
                  var chatlist=  snapshot.data!.docs.where((element) {
                      String combinid = element['combinid'];
                      return combinid
                          .contains(FirebaseAuth.instance.currentUser!.uid);
                    }).toList();
                    return ListView.builder(
                      itemCount: chatlist.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:  Text(chatlist[index]['message']),
                          subtitle: const Text('Message'),
                          trailing: const Text('Time'),
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
