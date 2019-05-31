import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peng_u/business/backend/firebase_auth.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/old/ui/button_app_bar/fancy_tab_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfileScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;

  const UserProfileScreen({this.firebaseUser});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserProfileScreenBody(widget.firebaseUser),
      bottomNavigationBar: FancyTabBar(),
    );
  }
}

Widget UserProfileScreenBody(FirebaseUser firebaseUser) {
  return StreamBuilder(
    stream: Auth.getUser(firebaseUser.uid),
    builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              Color.fromRGBO(212, 20, 15, 1.0),
            ),
          ),
        );
      } else {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onLongPress: _uploadPic,
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    child: CircleAvatar(
                      backgroundImage: (snapshot.data.profilePictureURL != '')
                          ? NetworkImage(snapshot.data.profilePictureURL)
                          : AssetImage("assets/images/default.png"),
                    ),
                  ),
                ),
                Text("Name: ${snapshot.data.firstName}"),
                Text("Email: ${snapshot.data.email}"),
                Text("UID: ${snapshot.data.userID}"),
              ],
            ),
          ),
        );
      }
    },
  );
}

Future _uploadPic() async {
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseUser user = await Auth.getCurrentFirebaseUser();

  //Get the file from the image picker and store it
  File image = await ImagePicker.pickImage(source: ImageSource.gallery);

  //Create a reference to the location you want to upload to in firebase
  StorageReference reference = await _storage.ref().child("images/${user.uid}");

  //Upload the file to firebase
  StorageUploadTask uploadTask = await reference.putFile(image);

  // Waits till the file is uploaded then stores the download url
  String location = await (await uploadTask.onComplete).ref.getDownloadURL();
  debugPrint('url: ${location.toString()}');

  debugPrint('${user.uid}');
  //returns the download url
  await updateData( user.uid, location);
}

updateData(String userId, String photoUrl) async {
  print(userId);
  print(photoUrl);

  await Firestore.instance
      .collection('users')
      .document(userId)
      .updateData({"profilePictureURL": photoUrl}).catchError((e) {
    print(e);
  });
}
