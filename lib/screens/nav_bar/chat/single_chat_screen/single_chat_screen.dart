// import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class SinglChatScreen extends StatefulWidget {
//   const SinglChatScreen({super.key, this.recieverid, this.recievername});
//   final recieverid;
//   final recievername;

//   @override
//   State<SinglChatScreen> createState() => _SinglChatScreenState();
// }

// class _SinglChatScreenState extends State<SinglChatScreen> {
//   final ScrollController _scrollController = ScrollController();
//   String getcombinID(String firstID, String secondID) {
//     List<String> ids = [firstID, secondID];
//     ids.sort();
//     return ids.join("_");
//   }

//   TextEditingController messageController = TextEditingController();
//   sendMessage() {
//     print('send message');
//     String combinId =
//         getcombinID(widget.recieverid, FirebaseAuth.instance.currentUser!.uid);

//     print("this is combin id $combinId");
//     FirebaseFirestore.instance.collection('chat').doc(combinId).set({
//       'senderid': FirebaseAuth.instance.currentUser!.uid,
//       'recieverid': widget.recieverid,
//       'combinid': combinId,
//       'sendername': FirebaseAuth.instance.currentUser!.displayName,
//       'recievername': widget.recievername,
//       'message': messageController.text.toString().trim(),
//       'time': DateTime.now().millisecondsSinceEpoch
//     }).then((value) {
//       print('message sent');
//       messageController.clear();
//     }).onError((error, stackTrace) {
//       print('message not sent');
//     });
//     FirebaseFirestore.instance
//         .collection('chat')
//         .doc(combinId)
//         .collection('conversation')
//         .add({
//       'senderid': FirebaseAuth.instance.currentUser!.uid,
//       'recieverid': widget.recieverid,
//       'message': messageController.text.toString().trim(),
//       'time': DateTime.now().millisecondsSinceEpoch
//     }).then((value) {
//       print('message sent');
//       _scrollToBottom();
//       // messageController.clear();s
//     }).onError((error, stackTrace) {
//       print('message not sent');
//     });
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToBottom();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.recievername),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('chat')
//                     .doc(getcombinID(widget.recieverid,
//                         FirebaseAuth.instance.currentUser!.uid))
//                     .collection('conversation')
//                     .orderBy('time', descending: false)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return const Text('error');
//                   } else if (!snapshot.hasData) {
//                     return const Center(
//                       child: Text('No message yet'),
//                     );
//                   } else if (snapshot.data!.docs.isEmpty) {
//                     return const Center(
//                       child: Text('No message yet'),
//                     );
//                   }
//                   return ListView.builder(
//                     controller: _scrollController,
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       if (snapshot.data!.docs.isEmpty) {
//                         return const Center(
//                           child: Text('No message yet'),
//                         );
//                       } else if (snapshot.hasData) {
//                         return ListTile(
//                           title: snapshot.data!.docs[index]['senderid'] ==
//                                   FirebaseAuth.instance.currentUser!.uid
//                               ? Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     BubbleSpecialThree(
//                                       isSender: true,
//                                       text: snapshot.data!.docs[index]
//                                           ['message'],
//                                       color: Colors.grey,
//                                       tail: true,
//                                       textStyle: TextStyle(
//                                           color: Colors.white, fontSize: 16),
//                                     ),
//                                   ],
//                                 )
//                               : Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     BubbleSpecialThree(
//                                       isSender: false,
//                                       text: snapshot.data!.docs[index]
//                                           ['message'],
//                                       color: Color(0xFF1B97F3),
//                                       tail: true,
//                                       textStyle: TextStyle(
//                                           color: Colors.white, fontSize: 16),
//                                     ),
//                                   ],
//                                 ),
//                         );
//                       }
//                     },
//                   );
//                 }),
//           ),
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(10)),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: 300.w,
//                   height: 50.w,
//                   child: TextField(
//                     controller: messageController,
//                     style: TextStyle(fontSize: 18.sp, color: Colors.black),
//                     decoration: const InputDecoration(
//                       hintText: 'Enter message',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 IconButton(
//                   onPressed: () {
//                     sendMessage();
//                   },
//                   icon: const Icon(
//                     Icons.send,
//                     color: Colors.teal,
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
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
  final ScrollController _scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Scroll to bottom when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  String getcombinID(String firstID, String secondID) {
    List<String> ids = [firstID, secondID];
    ids.sort();
    return ids.join("_");
  }

  void sendMessage() {
    String combinId =
        getcombinID(widget.recieverid, FirebaseAuth.instance.currentUser!.uid);

    FirebaseFirestore.instance.collection('chat').doc(combinId).set({
      'senderid': FirebaseAuth.instance.currentUser!.uid,
      'recieverid': widget.recieverid,
      'combinid': combinId,
      'sendername': FirebaseAuth.instance.currentUser!.displayName,
      'recievername': widget.recievername,
      'message': messageController.text.trim(),
      'time': DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      messageController.clear();
    }).onError((error, stackTrace) {
      print('Message not sent');
    });

    FirebaseFirestore.instance
        .collection('chat')
        .doc(combinId)
        .collection('conversation')
        .add({
      'senderid': FirebaseAuth.instance.currentUser!.uid,
      'recieverid': widget.recieverid,
      'message': messageController.text.trim(),
      'time': DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      _scrollToBottom();
    }).onError((error, stackTrace) {
      print('Message not sent');
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No messages yet'),
                  );
                }
                // Automatically scroll to the bottom when new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final messageData = snapshot.data!.docs[index];
                    final isSender = messageData['senderid'] ==
                        FirebaseAuth.instance.currentUser!.uid;

                    return Align(
                      alignment: isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: BubbleSpecialThree(
                        isSender: isSender,
                        text: messageData['message'],
                        color: isSender ? Colors.grey : const Color(0xFF1B97F3),
                        tail: true,
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  },
                );
              },
            ),
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
          ),
        ],
      ),
    );
  }
}
