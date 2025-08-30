import 'package:flutter/material.dart';
import 'pages.dart';

void main() {
  runApp(SetApp());
}

class SetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SET!!!',
      home: SetHome(),
    );
  }
}
