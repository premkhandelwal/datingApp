import 'package:flutter/material.dart';

class ShowAlert extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback successFunction;
  const ShowAlert(
      {Key? key,
      required this.title,
      required this.content,
      required this.successFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: successFunction,
        ),
        TextButton(
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
