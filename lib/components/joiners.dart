import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Participants extends StatefulWidget {

  final String user;
  final String time;
  const Participants(
      {super.key,  required this.user, required this.time,  });

  @override
  State<Participants> createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person_2),
      title: Text(
        widget.user,
        style: TextStyle(color: Theme
            .of(context)
            .colorScheme
            .secondary),
      ),

    );
  }
}

