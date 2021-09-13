import 'package:flutter/material.dart';

class LoggingIn extends StatelessWidget {
  const LoggingIn({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}