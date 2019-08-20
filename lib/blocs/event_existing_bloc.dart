import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/resources/repository.dart';

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

  Future changeEventRequestStatus(Event event, String currentUserId) async {
    User _oldCurrentUser = event.invitedUserObjectList
        .firstWhere((user) => user.userID == currentUserId);

    String status = _oldCurrentUser.eventRequestStatus;
    print('alter Status $status');
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
