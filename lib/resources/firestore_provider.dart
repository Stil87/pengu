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

  /// Delete User Friend from users personal friends list create to fire

  Future<void> deleteUserIdFromUsersPersonalFriendsListAtFirestore(
      {String currentUserID, String toDeleteUserID}) async {
    return _firestore
        .collection(_firestoreCollectionNameAllUsers)
        .document(currentUserID)
        .collection(_userPersonalFriendslistCollectionName)
        .document(toDeleteUserID)
        .delete();
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
