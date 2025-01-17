import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peng_u/blocs/login_bloc.dart';
import 'package:peng_u/blocs/login_bloc_provider.dart';
import 'package:peng_u/ui/login.dart';
import 'package:peng_u/utils/strings.dart';
import 'package:peng_u/ux/login_screen/root_screen.dart';
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
        userNameField(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        emailField(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        passwordField(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        submitButton(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        googleButton(),
        Container(margin: EdgeInsets.only(top: 50.0, bottom: 5.0)),
        resetPasswordButton(),
      ],
    );
  }

  Widget userNameField() {
    return StreamBuilder(
        stream: _bloc.name,
        builder: (_, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _bloc.changeName,
            decoration: InputDecoration(
                hintText: 'Enter your Name', errorText: snapshot.error),
          );
        });
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

  Widget googleButton() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: () {
          authenticateUserWithGoogle();
        },
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: new Icon(
            FontAwesomeIcons.google,
            color: Color(0xFF0084ff),
          ),
        ),
      ),
    );
  }

  Widget resetPasswordButton() {
    return Container(
      child: GestureDetector(
        child: Text('forgot password?'),
        onTap: () {
          print('pusked');
          String email = '';

          return launchEmailChanger(context, email);
        },
      ),
    );
  }

  launchEmailChanger(BuildContext context, String email) {
    //set up the alerts buttons
    Widget cancelButton = FlatButton(
        onPressed: () {
          return Navigator.pop(context);
        },
        child: Text('Nay!'));

    Widget sendButton = FlatButton(
        onPressed: () {
          _bloc.resetUserPassword();
          return Navigator.pop(context);
        },
        child: Text('Send!'));
    //New FirebaseAuth user
    Widget textField = SizedBox(
      height: 150,
      width: 220,
      child: TextField(
        decoration: InputDecoration(labelText: email),
        onChanged: _bloc.changeEmail,
      ),
    );

    //set up the alertDialog
    AlertDialog alertDialog = AlertDialog(
      title: Text('Reset your password'),
      content: Text('Enter your mail address and we will send you a new password'),
      actions: <Widget>[
        Column(
          children: <Widget>[
            textField,
            Row(
              children: <Widget>[cancelButton, sendButton],
            )
          ],
        ),
      ],
    );

    //show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
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

  void authenticateUserWithGoogle() {
    _bloc.showProgressBar(true);
    _bloc.signInWithGoogle().then((userId) {
      print('google sign in with FirebaseAuth User id: $userId');
    }).catchError((e) {
      _bloc.setSignInStatus(null);
      showErrorMessage(errorMessage: e);
    });
  }

  void authenticateUser() {
    _bloc.showProgressBar(true);
    _bloc.signInWithFirebaseAndEmail().then((userId) {
      //Already registered
      print('firebaseAuth user signed in: userId: $userId');
    
      //todo:root to dasboard screen
    }).catchError((e) {
      _bloc.setSignInStatus(null);
      if (_bloc.getExceptionText(e: e) == null) {
        showAlertDialog(context);
      } else {
        showErrorMessage(errorMessage: _bloc.getExceptionText(e: e));
      }
    });
  }

  showAlertDialog(BuildContext context) {
    //set up the alerts buttons
    Widget cancelButton = FlatButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RootScreen()));
        },
        child: Text('Nea!'));
    //New FirebaseAuth user
    Widget signUpButton = FlatButton(
        onPressed: () {
          _bloc.signUpWithFirebaseAndEmail();

          //todo: route to dashboard screen
          return Navigator.pop(context);
        },
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
