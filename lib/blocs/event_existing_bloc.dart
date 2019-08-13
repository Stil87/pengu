import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/resources/repository.dart';

class EventExistingBloc {
  final _repository = Repository();

  forwardEventToAddedFriend(Event event, List<User> extendedUserList) {
    event.invitedUserObjectList = extendedUserList;

    event.invitedUserObjectList.forEach((user) async {
      await _repository.addRoomObjectToUsersPrivateRoomList(
          userID: user.userID, roomID: event.roomId, event: event);
      print('event created');
    });
  }
}
