import 'package:flutter/material.dart';
import 'package:peng_u/blocs/login_bloc.dart';

class LoginBlocProvider extends InheritedWidget {
  final bloc = LoginBloc();

  LoginBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(
        LoginBlocProvider) as LoginBlocProvider).bloc;
  }
}
