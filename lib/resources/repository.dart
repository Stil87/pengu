import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/resources/location_provider.dart';

import 'firestore_provider.dart';
import 'user_auth_provider.dart';

class Repository {
  final _userAuthProvider = UserAuthProvider();
  final _firestoreProvider = FirestoreProvider();
  final _locationProvider = LocationProvider();

  /*--------repository based on User authentication and firestore collection "users"----------*/

  ///set firestore timestamp settings to true
  Future setFirebaseTimestampSettings() =>
      _firestoreProvider.setFirebaseTimestampSettings();

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

  ///returns a User object out of a Firebase User

  Future<User> createUserWithFirebaseUser(FirebaseUser firebaseUser) =>
      _userAuthProvider.createUserWithFirebaseUser(firebaseUser);

  ///returns the current firebaseUserId

  Future<String> getCurrentFirebaseUserId() =>
      _userAuthProvider.getCurrentFirebaseUserId();

  ///adds FirebaseAut User to firebase storage collection "users" needed user object

  Future<void> addUserToFirebaseStoreCollection(User user) =>
      _userAuthProvider.addUserToFirebaseStoreCollection(user: user);

  ///method that checks if user exists already in firestore collection "user"
  ///returns boolean

  Future<bool> checkUserExistInFirestoreCollection(String userID) =>
      _userAuthProvider.checkUserExistInFirestoreCollection(userID: userID);

  /// method that returns a user object from firestore "users" collection with User.fromDocument method

  Stream<User> getUserFomFirestoreCollection(String userID) =>
      _userAuthProvider.getUserFomFirestoreCollection(userID: userID);

  ///Future that returns User object by Userid

  Future<User> getUserFromFirestoreCollectionFuture({String userID}) =>
      _firestoreProvider.getUserFromFirestoreCollectionFuture(userID: userID);

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

  ///reset user password using mail

  resetPassword(String email)=>_userAuthProvider.resetPassword(email);

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

  /// stream to get Users personal friends list returning  List<Strings> of friends ids
  ///
  Stream<List<String>> streamUserPersonalFriendsIdStringList(
          {String currentUserID}) =>
      _firestoreProvider.streamUserPersonalFriendsIdStringList(
          currentUserID: currentUserID);

  /// stream to get Users personal friends list returning  List of user objects
  ///
  Stream<List<User>> streamUserPersonalFriendsObjectList(
          {String currentUserID}) =>
      _firestoreProvider.streamUserPersonalFriendsObjectList(
          currentUserID: currentUserID);

  /// future to get Users personal friends list returning  List of user objects

  Future<List<User>> futureUserPersonalFriendsObjectList(
          {String currentUserID}) =>
      _firestoreProvider.futureUserPersonalFriendsObjectList(
          currentUserID: currentUserID);

  /// stream to get Users personal friends event list returning  List of Events objects
  /// currentUser/userFriends(snapshot)/userObject/Eventlists/
  ///
  Stream<List<Event>> streamUserPersonalFriendsEventsObjectList(
          {String currentUserID}) =>
      _firestoreProvider.streamUserPersonalFriendsEventsObjectList(
          currentUserID: currentUserID);

  ///stream user friends events
  ///
  Stream<List<Event>> streamUserFriendsEvent(String currentUserId) =>
      _firestoreProvider.streamUserFriendsEvent(currentUserId);

  ///Future to search the firestore user list by searchKeyword
  ///
  Future<QuerySnapshot> getUserDocumentsFromFirestoreBySearchKey(
          {String searchKey}) =>
      _firestoreProvider.getUserDocumentsFromFirestoreBySearchKey(
          searchKey: searchKey);

  /// Add User Friend to users personal friends list create to fire

  Future<void> addUserIdToUsersPersonalFriendsListToFirestore(
          {String currentUserID, String newUserID}) =>
      _firestoreProvider.addUserIdToUsersPersonalFriendsListToFirestore(
          currentUserID: currentUserID, newUserID: newUserID);

  ///Future that adds a Userobeject as Json to current users friends list in firestore

  Future<void> sendUserFriendshipRequest(
          {String currentUserId, String userIdToAdd}) =>
      _firestoreProvider.sendUserFriendshipRequest(
          currentUserId: currentUserId, userIdToAdd: userIdToAdd);

  ///Future that accepts a friendship request an put changes both requestStatus to friend

  Future<void> acceptFriendshipRequest(
          String currentUserId, String userIdToAdd) =>
      _firestoreProvider.acceptFriendshipRequest(currentUserId, userIdToAdd);

  ///Future that deletes json user object to delete friends and all related requests requests

  Future<void> deleteFriend(String currentUserId, String userToDeleteId) =>
      _firestoreProvider.deleteFriend(currentUserId, userToDeleteId);

  /// Delete User Friend to users personal friends list create to fire
  ///
  /// change profile image of user user info plus friends
  ///
  setUserImageAllUserandUserFriends(
          String userId, String imageURL, List<User> friendsList) =>
      _firestoreProvider.setUserImageAllUserandUserFriends(
          userId, imageURL, friendsList);

  Future setUserNameAllUserandUserFriends(
          String userId, String changedName, List<User> friendsList) =>
      _firestoreProvider.setUserNameAllUserandUserFriends(
          userId, changedName, friendsList);

  /// change user Name in firestore collection of the userobject in all events

  Future setUserNameAllEvents(
          String userId, String changedName, List<Event> userEventList) =>
      _firestoreProvider.setUserNameAllEvents(
          userId, changedName, userEventList);

/*-----------User rooms related firestore provider operation*/

  /// Creating a new unique room at Firestore rooms Collection and returns roomId as a String

  Future<String> createNewRoomWithUniqueIDAtFirestoreRoomCollection() =>
      _firestoreProvider.createNewRoomWithUniqueIDAtFirestoreRoomCollection();

  ///sets the Event object Data with event.tojson to a room with the given roomID
  ///
  ///

  Future<void> setEventDataToSpecificRoom({Event event, String roomID}) =>
      _firestoreProvider.setEventDataToSpecificRoom(
          event: event, roomID: roomID);

  ///stream to returning the dummy Event object in rooms/unique id
  ///
  Stream<Event> streamDummyEventById({String eventId}) =>
      _firestoreProvider.streamDummyEventById(eventId);

  ///Adds a room Id to a user´s private rooms list

  Future<void> addRoomIDToUsersPrivateRoomList(
          {String userID, String roomID}) =>
      _firestoreProvider.addRoomIDToUsersPrivateRoomList(
          userID: userID, roomID: roomID);

  Future<void> addRoomObjectToUsersPrivateRoomList(
          {String userID, String roomID, Event event}) =>
      _firestoreProvider.addRoomObjectToUsersPrivateRoomList(
          userID: userID, roomID: roomID, event: event);

  /// method to add the new room to rooms collection at firestore

  Future<void> addRoomObjectToRoomCollection (Event event) async =>
  _firestoreProvider.addRoomObjectToRoomCollection(event);

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

  /// stream to get Users personal rooms list returning  List of event objects
  ///
  Stream<List<Event>> streamUserPersonalEventsObjectList(
          {String currentUserID}) =>
      _firestoreProvider.streamUserPersonalEventsObjectList(
          currentUserID: currentUserID);

  /// stream of the Event data in a specific room

  Stream<Event> getRoomDocumentSnapshotWithRoomIDAndUserId(
          {String roomID, String userId}) =>
      _firestoreProvider.getRoomDocumentSnapshotWithRoomIDAndUserId(
          roomID: roomID, userId: userId);

  /// change user Image in firestore collection of the userobject in all events

  Future setUserImageAllEvents(
          String userId, String imageURL, List<Event> userEventList) =>
      _firestoreProvider.setUserImageAllEvents(userId, imageURL, userEventList);

  ///get user Personal Event List as a future

  Future<List<Event>> futureUserPersonalEventsObjectList(
          {String currentUserID}) =>
      _firestoreProvider.futureUserPersonalEventsObjectList(
          currentUserID: currentUserID);

  ///delete room and event (!! delete in allrooms collection and in each invited users userroomslist )
  ///
  Future deleteEvent(Event event) => _firestoreProvider.deleteEvent(event);

/*-----------User location related firestore provider operation*/

  ///method get User location returns a LatLng
  ///
  Future<LatLng> getUserLocation() => _locationProvider.getUserLocation();

  ///method returns PlacesSearchResponse which can turn with .result into List<PlacesSearchResult>

  Future<PlacesSearchResponse> getNearbyPlacesByText(
          {String searchString, Location location}) =>
      _locationProvider.getNearbyPlacesByText(
          searchString: searchString, location: location);

  ///returns a google PlaceDetail object by id
  Future<PlaceDetails> getPlaceById(String id) =>
      _locationProvider.getPlaceById(id);

/*-----------User location related firebase storage provider operation*/

  Future<String> uploadUserImage(File image, String userId) async =>
      _firestoreProvider.uploadUserImage(image, userId);
}
