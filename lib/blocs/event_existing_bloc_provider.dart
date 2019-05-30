import 'package:flutter/material.dart';
import 'package:peng_u/blocs/event_existing_bloc.dart';

class EventBlocProvider extends InheritedWidget {
  final bloc = EventExistingBloc();

  EventBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static EventExistingBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(EventBlocProvider)
            as EventBlocProvider)
        .bloc;
  }
}
