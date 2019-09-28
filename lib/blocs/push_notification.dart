import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peng_u/resources/repository.dart';
import 'package:provider/provider.dart';

class MessageHandler extends StatefulWidget {

  @override
  _MessageHandlerState createState() => _MessageHandlerState();




}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
 final _repository = Repository();


  ///Todo: cancel subsription
  StreamSubscription iosSubscription;

  @override
  void dispose() {
    super.dispose();
    print('!!!MessageHandler dispose!!!');
    //iosSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    print('MessageHandler initState MEthode fires');
    if (Platform.isIOS) {
      print('MessageHandler ios detected ');
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        _saveDeviceToken();
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }

    _fcm.configure(

      onMessage: (Map<String, dynamic> pushNote) async {
        print('on Message: $pushNote');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(pushNote['notification']['title']),
              subtitle: Text(pushNote['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> pushNote) async {
        print('on Launch: $pushNote');
        final snackBar =
            SnackBar(content: Text(pushNote['notification']['title']));
        Scaffold.of(context).showSnackBar(snackBar);},
      onResume: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _saveDeviceToken()  async{

  FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String fcmToken = await _fcm.getToken();
    if (fcmToken != null ) {
      _repository.saveUserDeviceToken(fcmToken, user.uid);

    }

  }
}
