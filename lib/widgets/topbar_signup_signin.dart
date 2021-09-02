import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';

class TopBarForSignUpAndSignIn extends StatelessWidget {
  TopBarForSignUpAndSignIn({Key? key, required BuildContext context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconsOutlinedButton(
            icon: Icons.arrow_back,
            size: Size(52, 52),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
