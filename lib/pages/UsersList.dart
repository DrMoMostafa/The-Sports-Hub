import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_event/pages/ChatPage.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot champion = snapshot.data!.docs[index];
                return Card(
                  color: Colors.white60,
                  child: ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                content: Text(champion['email']),
                                title: Text(
                                  champion['username'],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                  receiverUserEmail:
                                                      champion['email'],
                                                  receiverUserID:
                                                      champion['uid'])));
                                    },
                                    child: Container(

                                      padding: const EdgeInsets.all(14),
                                      child: const Text("Message"),
                                    ),
                                  ),
                                ],
                              ));
                    },
                    leading: Icon(Icons.person),
                    title: Text(champion['username']),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                );
              });
        },
      ),
    );
  }
}
