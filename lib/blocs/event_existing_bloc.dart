import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/resources/repository.dart';
import 'package:url_launcher/url_launcher.dart';

class EventExistingBloc {
  final _repository = Repository();

  Future forwardEventToAddedFriend(
      Event event, List<User> extendedUserList) async {
    event.invitedUserObjectList.addAll(extendedUserList);
    event.invitedUserObjectList.forEach((user) async {
      await _repository.addRoomObjectToUsersPrivateRoomList(
          userID: user.userID, roomID: event.roomId, event: event);
      print('event forwarded');
    });
  }

  Stream getRoomStream(String roomId, String currentUserId) =>
      _repository.getRoomDocumentSnapshotWithRoomIDAndUserId(
          roomID: roomId, userId: currentUserId);

  void launchMapsUrl(String placeId, String placeName) async {
    placeName= placeName.replaceAll(' ',"");
    print('launchMap tapped');
    final url =
        'https://www.google.com/maps/search/?api=1&query=$placeName&query_place_id=ChIJLU7jZClu5kcR4PcOOO6p3I0$placeId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future changeEventRequestStatus(
      Event event, String currentUserId, String inviterId) async {
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
  }
}
