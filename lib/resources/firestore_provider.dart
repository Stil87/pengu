import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;
  final String _firestoreCollectionNameAllUsers = 'users';
  final String _userPersonalFriendslistCollectionName = 'userFriends';
  final String _userPersonalFriendIdFieldInDocument = 'userFriendsId';
  final String _roomCollectionNameAllRooms = 'rooms';
  final String _userPersonalRoomsListCollectionName = 'userRooms';

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

  ///Future to search the firestore user list by searchKeyword
  ///
  Future<QuerySnapshot> getUserDocumentsFromFirestoreBySearchKey(
      {String searchKey}) async {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .where('searchKey', isEqualTo: searchKey.substring(0, 1).toUpperCase())
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

/*-----------User rooms related firebase provider operation*/

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
        .snapshots()
        .map((list) =>
            list.documents.map((doc) => Event.fromFirestore(doc)).toList());

    //Event.fromFirestore(doc)).toList());
  }

  /// stream of the Event data in a specific room

  Stream<DocumentSnapshot> getRoomDocumentSnapshotWithRoomID({String roomID}) {
    return _firestore
        .collection(_roomCollectionNameAllRooms)
        .document(roomID)
        .snapshots();
  }
}
