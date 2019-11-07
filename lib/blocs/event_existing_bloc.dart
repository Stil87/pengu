import 'package:flutter/material.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/resources/repository.dart';
import 'package:url_launcher/url_launcher.dart';

class EventExistingBloc {
  final _repository = Repository();

  Future deleteEvent(Event event, String currentUserId) async {
    await _repository.deleteEvent(event);
    List<String> tokens = [];
    event.invitedUserObjectList
        .forEach((user) => tokens.add(user.userMobileToken));
    User deleter = event.invitedUserObjectList.firstWhere((user) => user.userID == currentUserId);
    await _repository.deleteEventInformationToRoomCollection(event, tokens, deleter);
  }

  Future forwardEventToAddedFriend(
      Event event, List<User> extendedUserList, String currentUserId) async {
    event.invitedUserObjectList.addAll(extendedUserList);
    event.invitedUserObjectList.forEach((user) async {
      await _repository.addRoomObjectToUsersPrivateRoomList(
          userID: user.userID, roomID: event.roomId, event: event);
      print('event forwarded');

      List<String> tokens = [];

      User forwarder = event.invitedUserObjectList
          .firstWhere((user) => user.userID == currentUserId);

      event.invitedUserObjectList
          .forEach((user) => tokens.add(user.userMobileToken));
      await _repository.addForwardedUserDetailsToRoomInRoomCollection(
          event, tokens, forwarder);
      print(
          'rooms collection: event forwarded from forwarder: ${forwarder.firstName}');
    });
  }

  Stream getRoomStream(String roomId, String currentUserId) =>
      _repository.getRoomDocumentSnapshotWithRoomIDAndUserId(
          roomID: roomId, userId: currentUserId);

  void launchMapsUrl(String placeId, String placeName) async {
    placeName = placeName.replaceAll(' ', "");

    print('launchMap tapped');
    final url =
        'https://www.google.com/maps/search/?api=1&query=$placeName&query_place_id=$placeId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> changeEventRequestStatus(
      Event event, String currentUserId, String inviterId, String newEventStatus) async {
    User _oldCurrentUser = event.invitedUserObjectList
        .firstWhere((user) => user.userID == currentUserId);

    String status = _oldCurrentUser.eventRequestStatus;
    print('alter Status $status');
    if (currentUserId == inviterId) {
      if (status == 'inviter') {
        status = 'inviterThere';
      } else if (status == 'inviterThere') {
        status = 'inviter';
      }
    }
   if (status == 'in') {
      status = 'there';
    } else if (status == 'there') {
      status = 'out';
    } else if (status == 'out') {
      status = 'in';
    } else if (status == '') {
      status = 'in';
    }

    int index = event.invitedUserObjectList.indexOf(_oldCurrentUser);
    event.invitedUserObjectList.removeAt(index);

    _oldCurrentUser.eventRequestStatus = status;
    print('neuer Status $status');

    event.invitedUserObjectList.add(_oldCurrentUser);

    event.invitedUserObjectList.forEach((user) async {
      await _repository.addRoomObjectToUsersPrivateRoomList(
          userID: user.userID, roomID: event.roomId, event: event);

      print('event created');
    });
    List<String> tokens = [];
    event.invitedUserObjectList
        .forEach((user) => tokens.add(user.userMobileToken));

// correct the status string for the snaackbar alert for user with inviter status
    if (status == 'inviter') {
      status = 'in';
    } else if (status == 'inviterThere') {
      status = 'there';
    }

    _oldCurrentUser.eventRequestStatus = status;
    await _repository.addUserStatusToRoomInRoomCollection(
        event, tokens, _oldCurrentUser);

    return status;
  }

  void sendPush(User userInList, String currentUserId, int pushNote) {
   _repository.sendPush(userInList, currentUserId,pushNote);

  }
}
