import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/pengU_user.dart';

import 'firestore_provider.dart';
import 'user_auth_provider.dart';

class Repository {
  final _userAuthProvider = UserAuthProvider();
  final _firestoreProvider = FirestoreProvider();

  /*--------repository based on User authentication and firestore collection "users"----------*/

  ///Firebase authentification Sign in with email and password
  /// returns User Id

  Future<String> signInFirebaseAuthWithEmail(String email, String password) =>
      _userAuthProvider.signInFirebaseAuthWithEmail(
          email: email, password: password);

  ///Firebase authentification create FirebaseUser (SignUp) with email and password
  ///returns User Id

  Future<String> createFirebaseAuthUserWithEmail(String email,
      String password) =>
      _userAuthProvider.signUpFirebaseAuthWithEmail(
          email: email, password: password);

  ///returns the current firebaseUser object

  Future<FirebaseUser> getCurrentFirebaseUser() =>
      _userAuthProvider.getCurrentFirebaseUser();

  ///returns a User object out of a Firebase User

  Future<User> createUserWithFirebaseUser(FirebaseUser firebaseUser) =>
      _userAuthProvider.createUserWithFirebaseUser(firebaseUser);

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

  Future<String> signInWithGoogle() => _userAuthProvider.signInWithGoogle();

  ///Stream which listens to change in User sign in status GoogleSignInAccount

  Stream<GoogleSignInAccount> checkUserSignedInWithGoogle() =>
      _userAuthProvider.checkUserSignedInWithGoogle();

  ///Method thats signs out Google account

  Future<void> signOutWithGoogle() => _userAuthProvider.signOutWithGoogle();

/*---------------------repository based on firestore business logic */

  /// stream to get global User list returning firestore snapshop
  ///
  Stream<QuerySnapshot> globalUserListFromFirestore() =>
      _firestoreProvider.globalUserListFromFirestore();

  /// stream to get Users personal friends list returning firestore snapshop

  Stream<QuerySnapshot> userPersonalFriendsListFromFirestore(
      {String currentUserId}) =>
      _firestoreProvider.userPersonalFriendsListFromFirestore(
          currentUserID: currentUserId);

  /// Add User Friend to users personal friends list create to fire

  Future<void> addUserIdToUsersPersonalFriendsListToFirestore(
      {String currentUserID, String newUserID}) =>
      _firestoreProvider.addUserIdToUsersPersonalFriendsListToFirestore(
          currentUserID: currentUserID, newUserID: newUserID);

  /// Delete User Friend to users personal friends list create to fire

  Future<void> deleteUserIdFromUsersPersonalFriendsListAtFirestore(
      {String currentUserID, String toDeleteUserId}) =>
      _firestoreProvider.deleteUserIdFromUsersPersonalFriendsListAtFirestore(
          currentUserID: currentUserID, toDeleteUserID: toDeleteUserId);

/*-----------User rooms related firestore provider operation*/

  /// Creating a new unique room at Firestore rooms Collection and returns roomId as a String

  Future<String> createNewRoomWithUniqueIDAtFirestoreRoomCollection() =>
      _firestoreProvider.createNewRoomWithUniqueIDAtFirestoreRoomCollection();

  ///sets the Event object Data with event.tojson to a room with the given roomID

  Future<void> setEventDataToSpecificRoom({Event event, String roomID}) =>
      _firestoreProvider.setEventDataToSpecificRoom(
          event: event, roomID: roomID);

  ///Adds a room Id to a user´s private rooms list

  Future<void> addRoomIDToUsersPrivateRoomList(
      {String userID, String roomID}) =>
      _firestoreProvider.addRoomIDToUsersPrivateRoomList(
          userID: userID, roomID: roomID);

  ///changes user commitment in a specific room

  Future<void> changeCurrentUserCommitmentInASpecificRoom(
      {String currentUserID, String roomId, String commitment}) =>
      _firestoreProvider.changeCurrentUserCommitmentInASpecificRoom(
          currentUserID: currentUserID, roomId: roomId, commitment: commitment);

  /// stream to get Users personal room list returning firestore snapshop
  ///
  //Todo: checkt bzw zeigt dem User dieser Stream auch Änderungen innhrhalb eines Rooms z.b commitment änderungen
  Stream<QuerySnapshot> userPersonalRoomListFromFirestore(
      {String currentUserID}) =>
      _firestoreProvider.userPersonalRoomListFromFirestore(
          currentUserID: currentUserID);

  /// stream of the Event data in a specific room

  Stream<DocumentSnapshot> getRoomDocumentSnapshotWithRoomID({String roomID}) =>
      _firestoreProvider.getRoomDocumentSnapshotWithRoomID(roomID: roomID);
}
