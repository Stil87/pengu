import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddFriendsBloc {
  final _repository = Repository();

  BehaviorSubject<List<User>> _tempSearchStore = BehaviorSubject<List<User>>.seeded( []);
  BehaviorSubject<List<User>> _resultSearchStore =
      BehaviorSubject<List<User>>.seeded( []);
  BehaviorSubject<List<User>> _userFriendsList = BehaviorSubject<List<User>>.seeded( []);

  Observable<List<User>> get tempSearchStoreStream => _tempSearchStore.stream;

  List get tempSearchStore => _tempSearchStore.value;

  Observable<List> get resultSearchStoreStream => _resultSearchStore.stream;

  List<User> get resultSearchStore => _resultSearchStore.value;

  List<User> get friendsList => _userFriendsList.value;

  set setfriendsList(List<User> list) => _userFriendsList.add(list);

  Stream getUserFriendsList(String userID) =>
      _repository.streamUserPersonalFriendsObjectList(currentUserID: userID);

  Future<User> getCurrentUser() async {
    String userID = await _repository.getCurrentFirebaseUserId();
    User user =
        await _repository.getUserFromFirestoreCollectionFuture(userID: userID);
    return user;
  }

  Future changeUserName(String userId, String changedName) async {
    List<User> friendsList = await _repository
        .futureUserPersonalFriendsObjectList(currentUserID: userId);
    List<Event> userEventList = await _repository
        .futureUserPersonalEventsObjectList(currentUserID: userId);

    await _repository.setUserNameAllUserandUserFriends(userId, changedName, friendsList);

    await _repository.setUserNameAllEvents(userId, changedName, userEventList);

  }

  Future changeUserProfileImage(int sourceId, String userId) async {
    File image;
    if (sourceId == 1) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);}

    File compressedImage = await FlutterImageCompress.compressAndGetFile(
        image.path, image.path,
        quality: 1);

    String uploadUrl =
        await _repository.uploadUserImage(compressedImage, userId);

    _spreadUserImage(uploadUrl, userId);
  }

  Future _spreadUserImage(String imageURL, String userId) async {
    List<User> friendsList = await _repository
        .futureUserPersonalFriendsObjectList(currentUserID: userId);
    List<Event> userEventList = await _repository
        .futureUserPersonalEventsObjectList(currentUserID: userId);

    await _repository.setUserImageAllUserandUserFriends(
        userId, imageURL, friendsList);

    await _repository.setUserImageAllEvents(userId, imageURL, userEventList);
  }

  Stream<User> getUserObject(String userId) =>
      _repository.getUserFomFirestoreCollection(userId);

  void dispose() async {
    await _tempSearchStore.drain();
    _tempSearchStore.close();
    await _resultSearchStore.drain();
    _resultSearchStore.close();
    await _userFriendsList.drain();
    _userFriendsList.close();
  }

  sendFriendshipRequest(String currentUserId, String userIdToAdd) {
    print('addToMyList tapped');
    _repository.sendUserFriendshipRequest(
        currentUserId: currentUserId, userIdToAdd: userIdToAdd);
  }

  acceptFriendshipRequest(String currentUserId, String userIdToAdd) =>
      _repository.acceptFriendshipRequest(currentUserId, userIdToAdd);

  Future deleteFriend(String currentUserId, String userToDeleteId) async {
    return _repository.deleteFriend(currentUserId, userToDeleteId);
  }

  initiateSearch(value) {
    List<User> list = [];
    if (value.length == 0) {
      _tempSearchStore.add([]);
      _resultSearchStore.add([]);
    }

    var capitalizedValue = value;
    //.substring(0, 1).toUpperCase() + value.substring(1);

    if (resultSearchStore.length == 0 && value.length == 1) {
      _repository
          .getUserDocumentsFromFirestoreBySearchKey(searchKey: value)
          .then((QuerySnapshot docs) {
        docs.documents.forEach((snap) {
          list.add(User.fromDocument(snap));
          _resultSearchStore.add(list);
        });
      });
    } else {
      _tempSearchStore.add([]);
      List<User> list = [];
      resultSearchStore.forEach((user) {
        List _friendsIdList = friendsList.map((user) => user.userID).toList();

        bool alreadyFriend = _friendsIdList.contains(user.userID);
        if (alreadyFriend == false &&
            user.firstName.startsWith(capitalizedValue)) {
          list.add(user);
          _tempSearchStore.add(list);
        }
      });
    }
  }
}
