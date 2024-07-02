import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'joiners.dart';

class EventPost extends StatefulWidget {
  final String date;
  final String location;
  final String sports;
  final String user;
  final String postId;
  final String time;
  final String from;
  final String cost;
  final String to;
  final List<String> joiners;
  const EventPost({
    super.key,
    required this.sports,
    required this.user,
    required this.postId,
    required this.joiners,
    required this.time,
    required this.location,
    required this.date,
    required this.from,
    required this.to,
    required this.cost,
  });

  @override
  State<EventPost> createState() => _EventPostState();
}

class _EventPostState extends State<EventPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isJoined = true;
  @override
  void initState() {
    super.initState();
    isJoined = widget.joiners.contains(currentUser.email);
  }

  void toggleJoin() {
    setState(() {
      isJoined = !isJoined;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Events').doc(widget.postId);
    if (isJoined) {
      postRef.update({
        'joiners': FieldValue.arrayUnion([currentUser.email])
      });
      FirebaseFirestore.instance
          .collection('Events')
          .doc(widget.postId)
          .collection('Participants')
          .doc(currentUser.email.toString())
          .set({
        'CommentedBy': currentUser.email?.split('@')[0],
        'CommentTime': Timestamp.now()
      });
    } else {
      postRef.update({
        'joiners': FieldValue.arrayRemove([currentUser.email])
      });
      FirebaseFirestore.instance
          .collection('Events')
          .doc(widget.postId)
          .collection('Participants')
          .doc(currentUser.email.toString())
          .delete();
    }
  }

  void leave(String commentText) {
    FirebaseFirestore.instance
        .collection('Events')
        .doc(widget.postId)
        .collection('Participants')
        .doc(currentUser.email.toString())
        .delete();
    FirebaseFirestore.instance.collection('Events').doc(widget.postId).update({
      'joiners': FieldValue.arrayRemove([currentUser.email])
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpandChild(
      collapsedVisibilityFactor: 0.8,
      child: Card(
        color: Colors.white60,
             child:  ListTile(
            title: Container(
              child: (Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.sports,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.date,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on),
                          Text(
                            widget.location,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text('From',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.underline)),
                                  Icon(Icons.timelapse),
                                ],
                              ),
                              Text(
                                widget.from,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text('To',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.underline)),
                                  Icon(Icons.timelapse),
                                ],
                              ),
                              Text(
                                widget.to,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.cost,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('EGP')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: isJoined
                                    ? Colors.red
                                    : Colors.green // background color
                                ),
                            child: Text(
                              isJoined ? 'Leave' : 'Join',
                            ),
                            onPressed: toggleJoin,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people),
                          SizedBox(
                            width: 10,
                          ),
                          Text(widget.joiners.length.toString()),
                          SizedBox(height: 10,),

                        ],
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Events')
                              .doc(widget.postId)
                              .collection('Participants')
                              .orderBy('CommentTime', descending: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: snapshot.data!.docs.map((doc) {
                                  final commentData = doc.data() as Map<String, dynamic>;
                                  return ListTile(
                                    title: Participants(
                                        user: commentData['CommentedBy'],
                                        time: DateTime.timestamp().toString()),
                                  );
                                  // formatDate(
                                  //     commentData['CommentTime']));
                                }).toList());
                          }),
                    ],
                  ),
                ],
              )),
            ),
          ),

      ),
    );
  }
}
