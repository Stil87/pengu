import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peng_u/resources/repository.dart';
import 'package:peng_u/ui/dashboard_screen/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'dashboard_bloc_provider.dart';

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
  void initState() {
    super.initState();
    print('MessageHandler initState MEthode fires');
    if (Platform.isIOS) {
      print('MessageHandler ios detected ');
      _fcm.requestNotificationPermissions(IosNotificationSettings());
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print('onIOSSettingsregistered $data');
        _saveDeviceToken();
      });

    } else {
      _saveDeviceToken();
    }
print('push notes if you read this fcm.configure might fire');
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
        print('on Message AlerDiolog showed');
      },
      onLaunch: (Map<String, dynamic> pushNote) async {
        print('on Launch: $pushNote');

        print('on launch AlerDiolog showed');
      },
      onResume: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        print('on Resume AlerDiolog showed');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardBlocProvider(
      child: DashboardScreen(),
    );
  }

  void _saveDeviceToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print('pushNote - saveDevice token firebase user: ${user.displayName}');
    String fcmToken;
  try{
    fcmToken = await _fcm.getToken();}
    catch (e) {print('getToken e : $e');}
    print ('token: $fcmToken');
    if (fcmToken != null) {
      _repository.saveUserDeviceToken(fcmToken, user.uid);
    }
  }
}
