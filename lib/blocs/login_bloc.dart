import 'dart:async';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:peng_u/model/pengU_user.dart';
import 'package:peng_u/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:peng_u/utils/strings.dart';

class LoginBloc {
  final _repository = Repository();

  //add rx stream contoller to each field. they return an observable instead of a stream
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();

  Observable<String> get email => _email.stream.transform(_validateEmail);

  Observable<String> get password =>
      _password.stream.transform(_validatePassword);

  Observable<bool> get signInStatus => _isSignedIn.stream;

  String get emailAddress => _email.value;

  void  setSignInStatus(bool event) => _isSignedIn.add(event);

  //change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get showProgressBar => _isSignedIn.sink.add;

  final _validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError(StringConstants.emailValidateMessage);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length > 5) {
          sink.add(password);
        } else {
          sink.addError(StringConstants.passwordValidateMessage);
        }
      });

  ///method signs in FirebaseAuth and returns FirebaseAuth user.id

  Future<String> signInWithFirebaseAndEmail() async {
    String userId = await _repository.signInFirebaseAuthWithEmail(
        _email.value, _password.value);
    return userId;

  }

  ///method signs up a new user in FirebaseAuth and returns FirebaseAuth user id

  Future<String> signUpWithFirebaseAndEmail() async{
    String userId  =  await _repository.createFirebaseAuthUserWithEmail(
        _email.value, _password.value);
    return userId;

  }

  ///methods sign up with google in FirebaseAuth and returns FirebaseAuth user id

  Future<String> signInWithGoogle () async {
    String userId = await _repository.signInWithGoogle();
    return userId;
  }



  void dispose() async {
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
  }

  bool validateFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _email.value.contains('@') &&
        _password.value.length > 5) {
      return true;
    } else {
      return false;
    }
  }

  /*catch exception and create text*/

  ///returns String error messages depending on input exception

  String getExceptionText({Exception e}) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return null;
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'Email address is already taken.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }
}
