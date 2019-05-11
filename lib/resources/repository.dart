import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peng_u/model/pengU_user.dart';

import 'firestore_provider.dart';
import 'user_auth_provider.dart';

class Repository {
  /*--------repository based on User authentication and firestore collection "users"----------*/

  final _userAuthProvider = UserAuthProvider();

  ///Firebase authentification Sign in with email and password
  /// returns User Id

  Future<String> signInFirebaseAuthWithEmail(String email, String password) =>
      _userAuthProvider.signInFirebaseAuthWithEmail(
          email: email, password: password);

  ///Firebase authentification create FirebaseUser (SignUp) with email and password
  ///returns User Id

  Future<String> createFirebaseAuthUserWithEmail(
          String email, String password) =>
      _userAuthProvider.signUpFirebaseAuthWithEmail(
          email: email, password: password);

  ///returns the current firebaseUser object

  Future<FirebaseUser> getCurrentFirebaseUser() =>
      _userAuthProvider.getCurrentFirebaseUser();

  ///returns the current firebaseUserId

  Future<String> getCurrentFirebaseUserId() =>
      _userAuthProvider.getCurrentFirebaseUserId();

  ///adds FirebaseAut User to firebase storage collection "users" needed user object

  Future<String> addUserToFirebaseStoreCollection(User user) =>
      _userAuthProvider.addUserToFirebaseStoreCollection(user: user);

  ///method that checks if user exists already in firestore collection "user"
  ///returns boolean

  Future<bool> checkUserExistInFirestoreCollection(String userID) =>
      _userAuthProvider.checkUserExistInFirestoreCollection(userID: userID);

  /// method that returns a user object from firestore "users" collection with User.fromDocument method

  Stream<User> getUserFomFirestoreCollection(String userID) =>
      _userAuthProvider.getUserFomFirestoreCollection(userID: userID);

  ///Stream which listens to change in User sign in status FirebaseAuth
  ///returns a User object r null

  Stream<FirebaseUser> checkUserSignedInWithFirebaseAuth() =>
      _userAuthProvider.checkUserSignedInWithFirebaseAuthChangeListener();

  ///Future<bool> which returns status if User sign in  FirebaseAuth
  ///returns either true or false

  Future<bool> checkIfUserSignedInWithFirebaseAuthBool() =>
      _userAuthProvider.checkIfUserSignedInWithFirebaseAuthBool();

  ///Firebase authentification Sign out current user
  ///returns User Id

  Future<void> signOutFirebaseAuth() => _userAuthProvider.signOutFirebaseAuth();

  /*--------------GOOGLE----------------------*/

  ///method to sign in user to Firebase.Auth with google account

  Future<void> signInWithGoogle() => _userAuthProvider.signInWithGoogle();

  ///Stream which listens to change in User sign in status GoogleSignInAccount

  Stream<GoogleSignInAccount> checkUserSignedInWithGoogle() =>
      _userAuthProvider.checkUserSignedInWithGoogle();

  ///Method thats signs out Google account

  Future<void> signOutWithGoogle() => _userAuthProvider.signOutWithGoogle();
}
