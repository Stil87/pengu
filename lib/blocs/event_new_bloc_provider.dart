import 'package:flutter/material.dart';
import 'package:peng_u/blocs/dashboard_bloc.dart';
import 'package:peng_u/blocs/event_new_bloc.dart';


class NewEventBlocProvider extends InheritedWidget {
  final bloc = NewEventBloc();

  NewEventBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static NewEventBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(
        NewEventBlocProvider) as NewEventBlocProvider).bloc;
  }
}
