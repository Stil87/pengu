import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';
import 'package:peng_u/model/user.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Auth {
  static Future<String> signIn(String email, String password) async {
    FirebaseUser user;
    AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    user= result.user;
    return user.uid;
  }

  static Future<String> signInWithGoogle(AuthCredential credential) async {
    FirebaseUser user;
    AuthResult result=
    await FirebaseAuth.instance.signInWithCredential(credential);
    user = result.user;
    return user.uid;
  }

  static Future<String> signUp(String email, String password) async {
    FirebaseUser user;
    AuthResult result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    user = result.user;
    }

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }
  static Future<String> getCurrentFirebaseUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    return userId;
  }

  static void addUser(User user) async {
    checkUserExist(user.userID).then((value) {
      if (!value) {
        print("user ${user.firstName} ${user.email} added");
        Firestore.instance
            .document("users/${user.userID}")
            .setData(user.toJson());
      } else {
        print("user ${user.firstName} ${user.email} exists");
      }
    });
  }

  static Map<String, dynamic> FromUserToMap(User user) {
    return {
      'userId': user.userID
    };
  }

  static addUserToMyFavoriteList(List<User> userList) async {
    if (isLoggedIn()) {
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      var addedUserList = userList.map((u)=>u.userID).toList();
      Map<String, List> userMap = {"friends" : addedUserList };
      // Map<String, List> userIds;



      Firestore.instance.collection('users').document(currentUser.uid)
          .collection('userFirendsList')
          .add(userMap)
          .catchError((e) {
        print(e);
      });
    } else {
      print('add User to list Error You need to be logged in');
    }
  }

  static Future<bool> checkUserExist(String userID) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$userID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Stream<User> getUser(String userID) {
    return Firestore.instance
        .collection("users")
        .where("userID", isEqualTo: userID)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return User.fromDocument(doc);
      }).first;
    });
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this e-mail not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'Email address is already taken.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }

  static bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }


}
