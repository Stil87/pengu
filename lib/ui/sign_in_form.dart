import 'package:flutter/material.dart';
import 'package:peng_u/blocs/login_bloc.dart';
import 'package:peng_u/blocs/login_bloc_provider.dart';
import 'package:peng_u/utils/strings.dart';
import 'package:peng_u/ux/teambuilder_grouping.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        emailField(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        passwordField(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        submitButton()
      ],
    );
  }

  Widget passwordField() {
    return StreamBuilder(
        stream: _bloc.password,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _bloc.changePassword,
            obscureText: true,
            decoration: InputDecoration(
                hintText: StringConstants.passwordHint,
                errorText: snapshot.error),
          );
        });
  }

  Widget emailField() {
    return StreamBuilder(
        stream: _bloc.email,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _bloc.changeEmail,
            decoration: InputDecoration(
                hintText: StringConstants.emailHint, errorText: snapshot.error),
          );
        });
  }

  Widget submitButton() {
    return StreamBuilder(
        stream: _bloc.signInStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return button();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget button() {
    return RaisedButton(
        child: Text(StringConstants.submit),
        textColor: Colors.white,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          if (_bloc.validateFields()) {
            authenticateUser();
          } else {
            showErrorMessage();
          }
        });
  }

  void authenticateUser() {
    _bloc.showProgressBar(true);
    _bloc.signInWithFirebaseAndEmail().then((value) {
      //Already registered
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => TeambuilderstflGroup()));
    }).catchError((e) {
      if (_bloc.getExceptionText(e: e) == null) {
        showAlertDialog(context);
      } else {
        showErrorMessage(errorMessage: _bloc.getExceptionText(e: e));
      }
    });
  }

  showAlertDialog(BuildContext context) {
    //set up the alerts buttons
    Widget cancelButton = FlatButton(onPressed: () {}, child: Text('Nea!'));
    Widget signUpButton = FlatButton(
        onPressed: () => _bloc.signUpWithFirebaseAndEmail(),
        child: Text('Yeah!'));

    //set up the alertDialog
    AlertDialog alertDialog = AlertDialog(
      title: Text('We don´t know you?! '),
      content: Text('Want to create a new account?'),
      actions: <Widget>[cancelButton, signUpButton],
    );

    //show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void showErrorMessage({String errorMessage}) {
    final snackbar = SnackBar(
        content: Text(errorMessage), duration: new Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
