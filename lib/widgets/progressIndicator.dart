import 'package:flutter/material.dart';

class CommonIndicator extends StatelessWidget {
  final String progressText;
  final MainAxisAlignment mainAxisAlignment;
  const CommonIndicator({Key? key, required this.progressText, this.mainAxisAlignment = MainAxisAlignment.start}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      children: <Widget>[
        new CircularProgressIndicator(),
        Text(
          progressText,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
