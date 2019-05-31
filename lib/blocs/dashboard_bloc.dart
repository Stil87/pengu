import 'package:firebase_auth/firebase_auth.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/resources/repository.dart';

class DashboardBloc {
  final _repository = Repository();

  /// methods checks if the current FirebaseAuthUser is already in FirestoreUserCollection and create a new user if needed

  Future<void> createNewFirestoreCollectionUser({String currentUserId}) async {
    String firebaseUserId = currentUserId;
    if (await _repository.checkUserExistInFirestoreCollection(firebaseUserId)) {
      print('user exists already in Firestore Collection');
    } else {
      FirebaseUser firebaseUser = await _repository.getCurrentFirebaseUser();
      await _repository.createUserWithFirebaseUser(firebaseUser);
      print('user added to firestore user collection');
    }
  }

  /// stream to get Users personal rooms list returning  List of event objects
  ///
  Stream<List<Event>> streamUserPersonalEventsObjectList(
      {String currentUserID}) {
    return _repository
        .streamUserPersonalEventsObjectList(currentUserID: currentUserID)
        .handleError((e) {
      print('streamUserPersonalEventsObjectList error : $e');
    });
  }

  /// stream to get Users personal friends list returning  List of user objects
  ///
  Stream<List<User>> streamUserPersonalFriendsObjectList(
          {String currentUserID}) =>
      _repository.streamUserPersonalFriendsObjectList(
          currentUserID: currentUserID);

  /// stream to get Users personal friends event list returning  List of Events objects
  /// currentUser/userFriends(snapshot)/userObject/Eventlists/
  ///
  Stream<List<Event>> streamUserPersonalFriendsEventObjectList(
          {String currentUserID}) =>
      _repository.streamUserPersonalFriendsEventsObjectList(
          currentUserID: currentUserID);

  Future<String> getCurrentUserId() {
    return _repository.getCurrentFirebaseUserId();
  }
}
