import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peng_u/model/user.dart';

class UserAuthProvider {
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /*User Auth Firebase*/

  ///Firebase authentification Sign in with email and password
  /// returns User Id

  Future<String> signInFirebaseAuthWithEmail(
      {String email, String password}) async {
    FirebaseUser user;
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    return user.uid;
  }

  ///Firebase authentification Sign up with email and password
  ///returns User Id

  Future<String> signUpFirebaseAuthWithEmail(
      {String email, String password}) async {
    FirebaseUser user;
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    return user.uid;
  }

  ///returns the current firebaseUser

  Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  ///returns a User object out of a Firebase User

  Future<User> createUserWithFirebaseUser(FirebaseUser firebaseUser,
      {String userName}) async {
    String userDisplayName;
    if (firebaseUser.displayName == null || firebaseUser.displayName == '') {
      userDisplayName = userName;
    } else {
      userDisplayName = firebaseUser.displayName;
    }
    User user = new User(
        firstName: userName,
        userID: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        profilePictureURL: firebaseUser.photoUrl ?? '',
        searchKey: userName[0] ?? '');
    return user;
  }

  ///returns the current firebaseUserId

  Future<String> getCurrentFirebaseUserId() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String userId = user.uid;
    return userId;
  }

  ///adds FirebaseAut User to firebase storage collection "users" needed user object

  Future<void> addUserToFirebaseStoreCollection(
      {User user, String userName}) async {
    await checkUserExistInFirestoreCollection(userID: user.userID)
        .then((value) {
      if (value == false) {
        print("user ${user.firstName} ${user.email} added");
        _firestore
            .collection('users')
            .document(user.userID)
            .setData(user.toJson());
      } else {
        print("user ${user.firstName} ${user.email} exists");
      }
    });
  }

  ///method that checks if user exists already in firestore collection "user"

  Future<bool> checkUserExistInFirestoreCollection({String userID}) async {
    bool exists = false;
    try {
      await _firestore.collection('users').document(userID).get().then((doc) {
        if (doc.exists) {
          if (doc.data.containsKey('email')) {
            exists = true;
          } else
            exists = false;
        } else
          exists = false;
      });
      return exists;
    } catch (e) {
      print('checkUserExist ethod in firestore_provider caught $e');
      return false;
    }
  }

  /// method that returns a user object from firestore "users" collection with User.fromDocument method

  Stream<User> getUserFomFirestoreCollection({String userID}) {
    return _firestore
        .collection("users")
        .where("userID", isEqualTo: userID)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return User.fromDocument(doc);
      }).first;
    });
  }

  ///Stream which listens to change in User sign in status FirebaseAuth
  ///returns either a user object or null

  Stream<FirebaseUser> checkUserSignedInWithFirebaseAuthChangeListener() {
    return _firebaseAuth.onAuthStateChanged;
  }

  ///Future<bool> which returns status if User sign in  FirebaseAuth
  ///returns either true or false

  Future<bool> checkIfUserSignedInWithFirebaseAuthBool() async {
    if (_firebaseAuth.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  ///Firebase authentification Sign out current user
  ///returns User Id

  Future<void> signOutFirebaseAuth() async {
    return await _firebaseAuth.signOut();
  }

  /// method to reset user Password

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /*User Auth Firebase with GOOGLE*/

  ///method to sign in user to Firebase.Auth with google account returning the FirebaseAuth user id

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    if (credential != null) {
      String userId = await signInWithGoogleCredential(credential: credential);
      return userId;
    }
  }

  ///method to sign in user to Firebase.Auth with google account
  ///just here for debug reason and should be deleted when finished

  Future signInWithGooglealt() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    if (credential != null) {
      signInWithGoogleCredential(credential: credential).then((uid) {
        getCurrentFirebaseUser().then((firebaseUser) {
          User user = new User(
            firstName: firebaseUser.displayName,
            userID: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            profilePictureURL: firebaseUser.photoUrl ?? '',
          );
          addUserToFirebaseStoreCollection(user: user);
          //Todo: Navigator: Unhandled Exception: Looking up a deactivated widget's ancestor is unsafe.
          //Navigator.push(context,
          //  MaterialPageRoute(builder: (context) => UserProfileScreen()));
          debugPrint('google sign in function ');
        });
      });
    } else {
      debugPrint('credentials = null');
    }
    ;
  }

  ///Helper method which signs user in Firebase.Auth with google account credentials

  static Future<String> signInWithGoogleCredential(
      {AuthCredential credential}) async {
    FirebaseUser user;
    AuthResult result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    user = result.user;
    return user.uid;
  }

  ///Stream which listens to change in User sign in status GoogleSignInAccount

  Stream<GoogleSignInAccount> checkUserSignedInWithGoogle() {
    return _googleSignIn.onCurrentUserChanged;
  }

  ///Method thats signs out Google account

  Future<GoogleSignInAccount> signOutWithGoogle() async {
    _googleSignIn.signOut();
    print('Google sign out');
  }

/*User Auth Firebase with Facebook*/
//Todo: do FAcebook Sign in register app on Facebook

}
