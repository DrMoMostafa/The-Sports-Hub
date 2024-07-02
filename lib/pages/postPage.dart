import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/event_post.dart';
import 'new_event_post.dart';

class postPage extends StatefulWidget {
  const postPage({
    super.key,
  });

  @override
  State<postPage> createState() => _postPageState();
}

class _postPageState extends State<postPage> {
  final textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  FirebaseStorage storage = FirebaseStorage.instance;
  final Timestamp timestamp = Timestamp.now();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text('Hi! ${currentUser?.email?.split('@')[0].toUpperCase()}'),
          centerTitle: true,
          titleSpacing: 00.0,
          toolbarHeight: 70.2,
          toolbarOpacity: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          elevation: 3.00,
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        // reverse: true,
                        // shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return EventPost(
                            cost: post['cost'],
                            from: post['From'],
                            to: post['to'],
                            date: post['date'],
                            location: post['location'],
                            sports: post['sports'],
                            time: DateTime.now().toString(),
                            // formatDate(post['TimeStamp']),
                            user: post['UserEmail'],
                            postId: post.id,
                            joiners: List<String>.from(post['joiners'] ?? []),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error:${snapshot.error}'));
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                stream: FirebaseFirestore.instance
                    .collection('Events')
                    .orderBy('TimeStamp', descending: true)
                    .snapshots(),
              )),
            ],
          ),
        ),
        // Floating action Button should appear in admin app only
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (FirebaseAuth.instance.currentUser?.email == 'admin@admin.com') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewEventPost()));
            } else {
              showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error!'),
                content: const Text(
                    'Your are not an admin.'),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // dismisses only the dialog and returns nothing
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            }
              // null;
              // (FirebaseAuth.instance.signOut());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void SignOut() {
    FirebaseAuth.instance.signOut();
  }
}
