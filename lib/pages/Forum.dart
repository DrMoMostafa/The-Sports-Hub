import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';

class Forum extends StatefulWidget {

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Forum'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('forum')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];

                      return
                        ChatBubble(
                        clipper: ChatBubbleClipper4(
                            type:
                            (message['sent by'] == FirebaseAuth.instance.currentUser!.email)?
                            BubbleType.sendBubble:
                                BubbleType.receiverBubble
                        ),
                        alignment:
                        (message['sent by'] == FirebaseAuth.instance.currentUser!.email)?
                       Alignment.topRight:
                            Alignment.topLeft,
                        margin: EdgeInsets.only(top: 20),
                        backGroundColor:
                        (message['sent by'] == FirebaseAuth.instance.currentUser!.email)?
                        Colors.blue:
                            Colors.teal,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child:Column(
                            children: [
                              Text(message['sent by']),
                              Text(message['text'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                          Text(
                                          message['timestamp'].toDate().toString())
                            ],
                          ),
                        ),
                      );
                    }
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: null,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.attachment),
                  onPressed: () {
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('forum').add({
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'sent by' : FirebaseAuth.instance.currentUser?.email?..split('@')[0],
        });
        _textEditingController.clear();
      } catch (e) {
        print('Error sending message: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to send message. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

}