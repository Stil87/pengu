class Event {
  List invitedUserId;
  String eventName;

  Event({this.invitedUserId, this.eventName});

  Map<String, Object> toJson() {
    return {

      'eventName': eventName,
       'invitedUser' : invitedUserId


    };
  }



}
