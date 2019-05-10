import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peng_u/model/pengU_user.dart';

class UserAuthProvider {

  Firestore _firestore = Firestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /*User Auth Firebase*/

  ///Firebase authentification Sign in with email and password
  /// returns User Id

  Future<String> signInFirebaseAuthWithEmail(
      String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  ///Firebase authentification Sign up with email and password
  ///returns User Id

  Future<String> signUpFirebaseAuthWithEmail(
      String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  ///returns the current firebaseUser

  Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  ///returns the current firebaseUserId

  Future<String> getCurrentFirebaseUserId() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String userId = user.uid;
    return userId;
  }

  ///adds FirebaseAut User to firebase storage collection "users" needed user object

  Future<void> addUserToFirebaseStoreCollection(User user) async {
    checkUserExistInFirestoreCollection(user.userID).then((value) {
      if (!value) {
        print("user ${user.firstName} ${user.email} added");
        _firestore.document("users/${user.userID}").setData(user.toJson());
      } else {
        print("user ${user.firstName} ${user.email} exists");
      }
    });
  }

  ///method that checks if user exists already in firestore collection "user"

  Future<bool> checkUserExistInFirestoreCollection(String userID) async {
    bool exists = false;
    try {
      await _firestore.document("users/$userID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      print('checkUserExist ethod in firestore_provider caught $e');
      return false;
    }
  }

  /// method that returns a user object from firestore "users" collection with User.fromDocument method

  Stream<User> getUserFomFirestoreCollection(String userID) {
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

  Stream<FirebaseUser> checkUserSignedInWithFirebaseAuth() {
    return _firebaseAuth.onAuthStateChanged;
  }

  ///Firebase authentification Sign out current user
  ///returns User Id

  Future<void> signOutFirebaseAuth() async {
    return await _firebaseAuth.signOut();
  }

  /*User Auth Firebase with GOOGLE*/

  ///method to sign in user to Firebase.Auth with google account

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    if (credential != null) {
      signInWithGoogleCredential(credential).then((uid) {
        getCurrentFirebaseUser().then((firebaseUser) {
          User user = new User(
            firstName: firebaseUser.displayName,
            userID: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            profilePictureURL: firebaseUser.photoUrl ?? '',
          );
          addUserToFirebaseStoreCollection(user);
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
      AuthCredential credential) async {
    FirebaseUser user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return user.uid;
  }

  ///Stream which listens to change in User sign in status GoogleSignInAccount

  Stream<GoogleSignInAccount> checkUserSignedInWithGoogle() {
    return _googleSignIn.onCurrentUserChanged;
  }

  ///Method thats signs out Google account

  Future<GoogleSignInAccount> signOutWithGoogle() {
    _googleSignIn.signOut();
    print('Google sign out');
  }

  /*User Auth Firebase with Facebook*/
  //Todo: do FAcebook Sign in register app on Facebook

  /*catch exception and create text*/

  ///returns String error messages depending on input exception

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
}
