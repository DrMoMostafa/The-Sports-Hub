import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final firestore = FirebaseFirestore.instance;
  Uint8List? pickedImage;
  File? _image;
  get data => null;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future registerNewUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // handle error
    }
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfilePicture();
  }
  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('Users').doc(user?.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          DocumentSnapshot<Object?> data = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: onProfileTapped,
                  child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          image: pickedImage != null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.memory(pickedImage!,
                                          fit: BoxFit.cover)
                                      .image)
                              : null)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ' ${data['username']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50,
                          ),

                    ),
                    IconButton(
                        onPressed: _showAlertDialogForUserName,
                        icon: Icon(
                          Icons.edit,
                        )),
                  ],
                ),

                Card(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    color: Colors.grey,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(' ${data['bio']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _showAlertDialogForBio,
                      ),
                    )),
                Card(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    color: Colors.grey,
                    child: ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(' ${data['mobile no']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _showAlertDialogForPhone,
                      ),
                    )),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  color: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.location_city),
                    title: Text(' ${data['city']}'),
                    trailing: IconButton(
                        onPressed: _showAlertDialogForCity,
                        icon: Icon(Icons.edit)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  color: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.calendar_month),
                    title: Text(' ${data['birthdate']}'),
                    trailing: IconButton(
                        onPressed: _showAlertDialogForBirthDate,
                        icon: Icon(Icons.edit)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  color: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.confirmation_number),
                    title: Text(' ${data['jersey No']}'),
                    trailing: IconButton(
                        onPressed: _showAlertDialogForJersey,
                        icon: Icon(Icons.edit)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  color: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.sports_volleyball_sharp),
                    title: Text(' ${data['Previous Playing Experience']}'),
                    trailing: IconButton(
                        onPressed: _showAlertDialogForClub,
                        icon: Icon(Icons.edit)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  color: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.sports_handball),
                    title: Text(' ${data['handed']}'),
                    trailing: IconButton(
                        onPressed: _showAlertDialogForHand,
                        icon: Icon(Icons.edit)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  color: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.sports_volleyball_sharp),
                    title: Text(' ${data['primary position']}'),
                    trailing: IconButton(
                        onPressed: _showAlertDialogForpposition,
                        icon: Icon(Icons.edit)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  color: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.sports_volleyball_sharp),
                    title: Text(' ${data['secondary position']}'),
                    trailing: IconButton(
                        onPressed: _showAlertDialogForsposition,
                        icon: Icon(Icons.edit)),
                  ),
                ),
              ],
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _showAlertDialogForPhone() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController phoneController = TextEditingController();
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(
              keyboardType: TextInputType.number,
              controller: phoneController,
              decoration: const InputDecoration(
                hintText: 'Phone Number',
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {}),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.email!)
                        .update({
                      'mobile no': phoneController.text,
                    });
                    Navigator.pop(context);
                  });
                }),
          ],
        );
      },
    );
  }

  void _showAlertDialogForCity() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController cityController = TextEditingController();
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {}),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.email!)
                        .update({
                      'city': cityController.text,
                    });
                    Navigator.pop(context);
                  });
                }),
          ],
        );
      },
    );
  }

  void _showAlertDialogForBirthDate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController birthDateController =
            TextEditingController();
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(
              controller: birthDateController,
              decoration: const InputDecoration(
                labelText: 'Birth date',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {}),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.email!)
                        .update({'birthdate': birthDateController.text});
                    Navigator.pop(context);
                  });
                }),
          ],
        );
      },
    );
  }

  void _showAlertDialogForJersey() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController JerseyController = TextEditingController();
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(
              controller: JerseyController,
              decoration: const InputDecoration(
                labelText: 'Jersey no',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {}),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.email!)
                        .update({'jersey No': JerseyController.text});
                    Navigator.pop(context);
                  });
                }),
          ],
        );
      },
    );
  }

  void _showAlertDialogForClub() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController ClubController = TextEditingController();
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(
              controller: ClubController,
              decoration: const InputDecoration(
                labelText: 'Clubs and/or recreations ',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {}),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.email!)
                        .update({
                      'Previous Playing Experience': ClubController.text
                    });
                    Navigator.pop(context);
                  });
                }),
          ],
        );
      },
    );
  }

  void _showAlertDialogForHand() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController HandController = TextEditingController();
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(
              controller: HandController,
              decoration: const InputDecoration(
                labelText: 'R/L handed ',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {}),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.email!)
                        .update({'handed': HandController.text});
                    Navigator.pop(context);
                  });
                }),
          ],
        );
      },
    );
  }

  void _showAlertDialogForpposition() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController ppositionController =
            TextEditingController();
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(
              controller: ppositionController,
              decoration: const InputDecoration(
                labelText: 'Primary position ',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {}),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.email!)
                        .update({'primary position': ppositionController.text});
                    Navigator.pop(context);
                  });
                }),
          ],
        );
      },
    );
  }

  void _showAlertDialogForsposition() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController spositionController =
            TextEditingController();
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(
              controller: spositionController,
              decoration: const InputDecoration(
                labelText: 'Primary position ',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {}),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.email!)
                        .update(
                            {'secondary position': spositionController.text});
                    Navigator.pop(context);
                  });
                }),
          ],
        );
      },
    );
  }

  void _showAlertDialogForUserName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController userNameController =
            TextEditingController();
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: 'User name ',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {}),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.email)
                        .update({'username': userNameController.text});
                    Navigator.pop(context);
                  });
                }),
          ],
        );
      },
    );
  }

  void _showAlertDialogForBio() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController bioController = TextEditingController();
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(
              maxLines: 5,
              controller: bioController,
              decoration: const InputDecoration(
                labelText: 'bio ',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {}),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.email!)
                        .update({'bio': bioController.text});
                    Navigator.pop(context);
                  });
                }),
          ],
        );
      },
    );
  }

  void onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final User? user = _auth.currentUser;
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('${user?.email}');
    final imageBytes = await image.readAsBytes();
    await imageRef.putData(imageBytes);
    setState(() => pickedImage = imageBytes);
  }
  Future<void> getProfilePicture() async{
    final storageRef = FirebaseStorage.instance.ref();
    final User? user = _auth.currentUser;
    final imageRef = storageRef.child('${user?.email}');
    try{
      final imageBytes= await imageRef.getData();
      if(
      imageBytes == null) return;
      setState(() => pickedImage= imageBytes);
    } catch (e){
      print('Profile picture not found');
    }
  }
}
