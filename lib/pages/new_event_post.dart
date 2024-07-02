import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class NewEventPost extends StatefulWidget {
  const NewEventPost({super.key});

  @override
  _NewEventPostState createState() => _NewEventPostState();
}

class _NewEventPostState extends State<NewEventPost> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser!;
  String _selectedItem = "Volleyball";
  TextEditingController locationController = TextEditingController();
  TextEditingController datePickerController = TextEditingController();
  TimeOfDay _timeOfDayFrom = TimeOfDay.now();
  TimeOfDay _timeOfDayTo = TimeOfDay.now();

  TextEditingController costController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _showTimePickerFrom() {
      showTimePicker(context: context, initialTime: TimeOfDay.now())
          .then((value) {
        setState(() {
          _timeOfDayFrom = value!;
        });
      });
    }

    void _showTimePickerTo() {
      showTimePicker(context: context, initialTime: _timeOfDayFrom)
          .then((value) {
        setState(() {
          _timeOfDayTo = value!;
        });
      });
    }

    Future postEvent() async {
      FirebaseFirestore.instance.collection('Events').add({
        'UserEmail': currentUser.email,
        'TimeStamp': Timestamp.now(),
        'joiners': [],
        'sports': _selectedItem,
        'location': locationController.text,
        'date': datePickerController.text,
        'From': _timeOfDayFrom.format(context).toString(),
        'to': _timeOfDayTo.format(context).toString(),
        'cost': costController.text
      });
      Navigator.pop(context);
      notify();
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Card(
          elevation: 50,
          child: SizedBox(
            height: 500,
            width: 300,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedItem,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedItem = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select an option',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Volleyball',
                    'Beach Volleyball',
                    'Padel Tennis',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          const Icon(Icons.star),
                          const SizedBox(width: 10),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Location',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: datePickerController,
                    readOnly: true,
                    decoration: const InputDecoration(hintText: "Pick a date"),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        lastDate: DateTime(2200),
                        firstDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      );
                      if (pickedDate == null) return;
                      datePickerController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        TextButton(
                            onPressed: _showTimePickerFrom,
                            child: Text('From',
                                style: TextStyle(
                                    decoration: TextDecoration.underline))),
                        Text(_timeOfDayFrom.format(context).toString()),
                      ],
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: _showTimePickerTo,
                            child: Text('To',
                                style: TextStyle(
                                    decoration: TextDecoration.underline))),
                        Text(_timeOfDayTo.format(context).toString()),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: costController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Cost',
                  ),
                ),
                ElevatedButton(
                    onPressed: postEvent,
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.touch_app),
                          Text('Post'),
                        ],
                      ), //Row
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void notify() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 1,
                color: Colors.red,
                channelKey: 'test_channel',
                title: 'Hello, A new event has been posted',
                body: 'Yalla join',
                criticalAlert: true,
                wakeUpScreen: true));
      }
    });
  }
}
