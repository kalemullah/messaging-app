import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging/screens/auth/login_screen.dart';
import 'package:messaging/screens/home_screen/chat/single_chat_screen/single_chat_screen.dart';
import 'package:messaging/utils/popup.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Data'),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                auth.signOut().then((v) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                }).onError((Error, v) {
                  print(Error);
                  ToastPopUp()
                      .toast(Error.toString(), Colors.green, Colors.white);
                });
              },
              child: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: db,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('error');
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data!.docs[index]['name']),
                            trailing: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SinglChatScreen(
                                            recieverid: snapshot.data!.docs[index]
                                                ['uid'],
                                            recievername: snapshot.data!.docs[index]
                                                ['name'],
                                              )));
                                  print(snapshot.data!.docs[index]['uid']);
                                },
                                child: const Icon(
                                  Icons.message,
                                  color: Colors.teal,
                                )),
                          );
                        }),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
    );
  }
}
