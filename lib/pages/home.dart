import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:group_event/pages/postPage.dart';
import 'package:group_event/pages/profile.dart';
import 'package:group_event/pages/scoard.dart';
import 'Forum.dart';
import 'UsersList.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    postPage(),
    ProfilePage(),
    Scoard(),
    Forum(),
    UsersList()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The Sports Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading:
            IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: ('Events'),
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: ('Profile'),
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.scoreboard_rounded),
                label: ('Score Board'),
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: ('Forum'),
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: ('Champions'),
                backgroundColor: Colors.green),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          iconSize: 40,
          backgroundColor: Color(0x00ffffff),
          onTap: _onItemTapped,
          elevation: 0),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
