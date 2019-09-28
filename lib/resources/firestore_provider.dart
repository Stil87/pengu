import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  final String _firestoreCollectionNameAllUsers = 'users';
  final String _userPersonalFriendslistCollectionName = 'userFriends';
  final String _userPersonalFriendIdFieldInDocument = 'userFriendsId';
  final String _roomCollectionNameAllRooms = 'rooms';
  final String _userPersonalRoomsListCollectionName = 'userRooms';
  final String _userTokenCollection = 'tokens';

  /*-----------User friends related firebase provider operation*/

  /// set firestore timestamp settings

  Future setFirebaseTimestampSettings() async {
    final Firestore firestore = Firestore();
    await firestore.settings(timestampsInSnapshotsEnabled: true);
  }

  /// stream to get global User list returning firestore snapshop
  ///
  Stream<QuerySnapshot> globalUserListFromFirestore() {
    return _firestore.collection(_firestoreCollectionNameAllUsers).snapshots();
  }

  /// stream to get Users personal friends list returning firestore snapshop
  ///
  Stream<QuerySnapshot> userPersonalFriendsListFromFirestore(
      {String currentUserID}) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserID)
        .collection(_userPersonalFriendslistCollectionName)
        .snapshots();
  }

  /// stream to get Users personal friends list returning  List<Strings> of friends ids
  ///
  Stream<List<String>> streamUserPersonalFriendsIdStringList(
      {String currentUserID}) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserID)
        .collection(_userPersonalFriendslistCollectionName)
        .snapshots()
        .map((list) => list.documents.map((doc) => doc.documentID).toList());
  }

  /// stream to get Users personal friends list returning  List of user objects
  ///
  Stream<List<User>> streamUserPersonalFriendsObjectList(
      {String currentUserID}) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserID)
        .collection(_userPersonalFriendslistCollectionName)
        .snapshots()
        .map((list) =>
            list.documents.map((doc) => User.fromDocument(doc)).toList());
  }

  /// Future to get Users personal friends list returning  List of user objects
  ///
  Future<List<User>> futureUserPersonalFriendsObjectList(
      {String currentUserID}) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserID)
        .collection(_userPersonalFriendslistCollectionName)
        .getDocuments()
        .then((list) =>
            list.documents.map((doc) => User.fromDocument(doc)).toList());
  }

  ///Future to search the firestore user list by searchKeyword
  ///
  Future<QuerySnapshot> getUserDocumentsFromFirestoreBySearchKey(
      {String searchKey}) async {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .where('searchKey', isEqualTo: searchKey)
        .getDocuments();
  }

  ///Future that returns User object by Userid

  Future<User> getUserFromFirestoreCollectionFuture({String userID}) async {
    return _firestore
        .collection('users')
        .document(userID)
        .get()
        .then((snap) => User.fromJson(snap.data));
  }

  ///Future that adds a Userobeject to current users friends list in firestore

  Future<void> sendUserFriendshipRequest(
      {String currentUserId, String userIdToAdd}) async {
    //get userToAdd Json plus requested value
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(userIdToAdd)
        .get()
        .then((friendsSnap) {
      friendsSnap.data.addAll({'requestStatus': 'requested'});
      //put userToAdd Json in currentUser Friendlist marked as requested
      _firestore
          .collection(_firestoreCollectionNameAllUsers)
          .document(currentUserId)
          .collection(_userPersonalFriendslistCollectionName)
          .document(userIdToAdd)
          .setData(friendsSnap.data)
          .whenComplete(() {
        //get current USer Json plus friendRequested value
        _firestore
            .collection(_firestoreCollectionNameAllUsers)
            .document(currentUserId)
            .get()
            .then((currentUserSnap) {
          currentUserSnap.data.addAll({'requestStatus': 'friendRequested'});
          //put current user json in userToAdd freindlist marked as friendrequested
          _firestore
              .collection(_firestoreCollectionNameAllUsers)
              .document(userIdToAdd)
              .collection(_userPersonalFriendslistCollectionName)
              .document(currentUserId)
              .setData(currentUserSnap.data);
        });
      });
    });
  }

  ///Future that accepts a friendship request an put changes both requestStatus to friend

  Future<void> acceptFriendshipRequest(
      String currentUserId, String userIdToAdd) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserId)
        .collection(_userPersonalFriendslistCollectionName)
        .document(userIdToAdd)
        .setData({'requestStatus': 'friend'}, merge: true).whenComplete(() {
      _firestore
          .collection(_firestoreCollectionNameAllUsers)
          .document(userIdToAdd)
          .collection(_userPersonalFriendslistCollectionName)
          .document(currentUserId)
          .setData({'requestStatus': 'friend'}, merge: true);
    });
  }

  ///Future that deletes json user object to delete friends and all related requests requests

  Future<void> deleteFriend(String currentUserId, String userToDeleteId) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserId)
        .collection(_userPersonalFriendslistCollectionName)
        .document(userToDeleteId)
        .delete()
        .whenComplete(() {
      _firestore
          .collection(_firestoreCollectionNameAllUsers)
          .document(userToDeleteId)
          .collection(_userPersonalFriendslistCollectionName)
          .document(currentUserId)
          .delete();
    });
  }

  /// stream to get Users personal friends event list returning  List of Events objects
  /// currentUser/userFriends(snapshot)/userObject/Eventlists/
  ///
  Stream<List<Event>> streamUserPersonalFriendsEventsObjectList(
      {String currentUserID}) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserID)
        .collection(_userPersonalFriendslistCollectionName)
        .snapshots()
        .map((list) => list.documents.map((doc) {
              User user = User.fromDocument(doc);
              return user.eventList.forEach((e) => e);
            }).toList());
  }

  /// Add User Friend to users personal friends list create to fire

  Future<void> addUserIdToUsersPersonalFriendsListToFirestore(
      {String currentUserID, String newUserID}) async {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserID)
        .collection(_userPersonalFriendslistCollectionName)
        .document(newUserID);
  }

  ///Change User Profile data
  ///

  /// change user Image in firestore collection of the userobject including userfriends

  Future setUserImageAllUserandUserFriends(
      String userId, String imageURL, List<User> friendsList) async {
    _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(userId)
        .setData({'profilePictureURL': imageURL}, merge: true).whenComplete(() {
      friendsList.forEach((user) {
        _firestore
            .collection(_firestoreCollectionNameAllUsers)
            .document(user.userID)
            .collection(_userPersonalFriendslistCollectionName)
            .document(userId)
            .setData({'profilePictureURL': imageURL}, merge: true);
      });
    });
  }

  /// change user name in firestore collection of the userobject including userfriends

  Future setUserNameAllUserandUserFriends(
      String userId, String changedName, List<User> friendsList) async {
    _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(userId)
        .setData({'firstName': changedName}, merge: true).whenComplete(() {
      friendsList.forEach((user) {
        _firestore
            .collection(_firestoreCollectionNameAllUsers)
            .document(user.userID)
            .collection(_userPersonalFriendslistCollectionName)
            .document(userId)
            .setData({'firstName': changedName}, merge: true);
      });
    });
  }

  /// change user Name in firestore collection of the userobject in all events

  Future setUserNameAllEvents(
      String userId, String changedName, List<Event> userEventList) async {
    userEventList.forEach((event) {
      User userToChange = event.invitedUserObjectList
          .singleWhere((user) => user.userID == userId);
      event.invitedUserObjectList.removeWhere((user) => user.userID == userId);
      userToChange.firstName = changedName;
      event.invitedUserObjectList.add(userToChange);
      event.invitedUserObjectList.forEach((user) {
        _firestore
            .collection(_firestoreCollectionNameAllUsers)
            .document(user.userID)
            .collection(_userPersonalRoomsListCollectionName)
            .document(event.roomId)
            .setData(event.toJson(), merge: true);
      });
    });
  }

  /*-----------User rooms related firebase provider operation*/

  /// change user Image in firestore collection of the userobject in all events

  Future setUserImageAllEvents(
      String userId, String imageURL, List<Event> userEventList) async {
    userEventList.forEach((event) {
      User userToChange = event.invitedUserObjectList
          .singleWhere((user) => user.userID == userId);
      event.invitedUserObjectList.removeWhere((user) => user.userID == userId);
      userToChange.profilePictureURL = imageURL;
      event.invitedUserObjectList.add(userToChange);
      event.invitedUserObjectList.forEach((user) {
        _firestore
            .collection(_firestoreCollectionNameAllUsers)
            .document(user.userID)
            .collection(_userPersonalRoomsListCollectionName)
            .document(event.roomId)
            .setData(event.toJson(), merge: true);
      });
    });
  }

  ///stream user friends events
  ///
  Stream<List<Event>> streamUserFriendsEvent(String currentUserId) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserId)
        .collection(_userPersonalFriendslistCollectionName)
        .snapshots()
        .map((snap) {
      print('hdjfhsdjk');
      snap.documents.map((doc) => User.fromJson(doc.data)).toList().map((user) {
        print(
            'Stream freinds events: mapping of friendslist stream ${user.firstName}');
        return _firestore
            .collection(_firestoreCollectionNameAllUsers)
            .document(user.userID)
            .collection(_userPersonalRoomsListCollectionName)
              ..where('dateTime',
                      isGreaterThanOrEqualTo: Timestamp.fromDate(
                          DateTime.now().subtract(Duration(hours: 6))))
                  .orderBy('dateTime', descending: false)
                  .snapshots()
                  .map((snap2) {
                print('UUUHH ${snap2.documents}');
                snap2.documents.forEach((doc) {
                  print('aahhhaa');
                  return Event.fromFirestore(doc);
                });
              });
      });
    });

    /*_firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(user.userID)
        .collection(_userPersonalRoomsListCollectionName)
        .where('dateTime',
        isGreaterThanOrEqualTo:
        Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 6))))
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snap) => snap.documents.map((doc) => Event.fromFirestore(doc)))
        .toList();*/
  }

  /// Creating a new unique room at Firestore rooms Collection and returns roomId as a String

  Future<String> createNewRoomWithUniqueIDAtFirestoreRoomCollection() async {
    final String roomID = _firestore
        .collection(_roomCollectionNameAllRooms)
        .document()
        .documentID;
    return roomID;
  }

  ///sets the Event object Data with event.tojson to a room with the given roomID

  Future<void> setEventDataToSpecificRoom({Event event, String roomID}) async {
    _firestore
        .collection(_roomCollectionNameAllRooms)
        .document(roomID)
        .setData(event.toJson());
  }

  ///updates EventData in  specific room
  ///delete room and event (!! delete in allrooms collection and in each invited users userroomslist )
  ///
  Future deleteEvent(Event event) async {
    event.invitedUserObjectList.forEach((user) {
      _firestore
          .collection(_firestoreCollectionNameAllUsers)
          .document(user.userID)
          .collection(_userPersonalRoomsListCollectionName)
          .document(event.roomId)
          .delete();
    });
  }

  ///Adds a room Id to a user´s private rooms list

  Future<void> addRoomIDToUsersPrivateRoomList(
      {String userID, String roomID}) async {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(userID)
        .collection(_userPersonalRoomsListCollectionName)
        .document(roomID);
  }

  ///Adds a eventobject to a user´s private rooms list

  Future<void> addRoomObjectToUsersPrivateRoomList(
      {String userID, String roomID, Event event}) async {
    return await _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(userID)
        .collection(_userPersonalRoomsListCollectionName)
        .document(roomID)
        .setData(event.toJson());
  }

  Future<void> addRoomObjectToRoomCollection(Event event) async {
    await _firestore
        .collection(_roomCollectionNameAllRooms)
        .document(event.roomId)
        .setData(event.toJson());
  }

  ///changes user commitment in a specific room

  Future<void> changeCurrentUserCommitmentInASpecificRoom(
      {String currentUserID, String roomId, String commitment}) async {
    return _firestore
        .collection(_roomCollectionNameAllRooms)
        .document(roomId)
        .updateData({
      'invitedUser': {currentUserID: commitment}
    });
  }

  /// stream to get Users personal room list returning firestore snapshop
  ///
  //Todo: checkt bzw zeigt dem User dieser Stream auch Änderungen innhrhalb eines Rooms z.b commitment änderungen
  Stream<QuerySnapshot> userPersonalRoomListFromFirestore(
      {String currentUserID}) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserID)
        .collection(_userPersonalRoomsListCollectionName)
        .snapshots();
  }

  ///stream to returning the dummy Event object in rooms/unique id
  ///
  Stream<Event> streamDummyEventById(String eventId) {
    return _firestore
        .collection(_roomCollectionNameAllRooms)
        .document(eventId)
        .snapshots()
        .map((doc) => Event.fromFirestore(doc))
        .handleError((e) => print('method firestore provider: $e'));
  }

  /// stream to get Users personal rooms list returning  List of event objects
  ///
  Stream<List<Event>> streamUserPersonalEventsObjectList(
      {String currentUserID}) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserID)
        .collection(_userPersonalRoomsListCollectionName)
        .where('dateTime',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 6))))
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((list) =>
            list.documents.map((doc) => Event.fromFirestore(doc)).toList());

    //Event.fromFirestore(doc)).toList());
  }

  /// stream to get Users personal rooms list returning  List of event objects
  ///
  Future<List<Event>> futureUserPersonalEventsObjectList(
      {String currentUserID}) async {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserID)
        .collection(_userPersonalRoomsListCollectionName)
        .where('dateTime',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 6))))
        .orderBy('dateTime', descending: false)
        .getDocuments()
        .then((list) =>
            list.documents.map((doc) => Event.fromFirestore(doc)).toList());

    //Event.fromFirestore(doc)).toList());
  }

  /// stream of the Event data in a specific room

  Stream<Event> getRoomDocumentSnapshotWithRoomIDAndUserId(
      {String roomID, String userId}) {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(userId)
        .collection(_userPersonalRoomsListCollectionName)
        .document(roomID)
        .snapshots()
        .map((doc) => Event.fromFirestore(doc));
  }

  /// Firebasestorage methods
  ///
  /// uploads file to storage in file 'images/'

  Future<String> uploadUserImage(File image, String userId) async {
    //Create a reference to the location you want to upload to in firebase
    StorageReference ref = await _storage.ref().child("images/$userId/");

    //Upload the file to firebase
    StorageUploadTask uploadTask = await ref.putFile(image);

    // Waits till the file is uploaded then stores the download url
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();

    return url;
  }

  /// save user Devicetoken

  Future saveUserDeviceToken(String token, String userId) {
    _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(userId)
        .collection(_userTokenCollection)
        .document(token)
        .setData({'token': token, 'platform': Platform.operatingSystem});
  }
}
