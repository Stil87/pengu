import 'package:flutter/material.dart';
import 'package:peng_u/ui/pengu_control_page_animator.dart';

void main() {
  runApp(PengU());
}

class PengU extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better place',
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      home: PengUControlPageAnimator(),
    );
  }
}
