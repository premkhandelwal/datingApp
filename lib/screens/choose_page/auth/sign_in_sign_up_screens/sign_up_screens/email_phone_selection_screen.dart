import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/screens/choose_page/auth/sign_in_sign_up_screens/sign_up_screens/email_pasword_screen/email_password_screen.dart';
import 'package:dating_app/screens/choose_page/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/phone_number_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';

class SignUpSignInSelectionScreen extends StatelessWidget {
  final String authSide;
  const SignUpSignInSelectionScreen({Key? key, required this.authSide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  child: Text('LOGO HERE'),
                  backgroundColor: AppColor,
                  radius: 50,
                ),
              ],
            ),
            Text(
              '$authSide to continue',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Column(
              children: [
                CommonButton(
                  onPressed: () {
                    changePageTo(
                        context: context,
                        widget: EmailPasswordScreen(
                          authSide: authSide,
                        ));
                  },
                  text: "Continue with email",
                ),
                SizedBox(height: 40),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(350, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    changePageTo(
                        context: context,
                        widget: PhoneNumberPage(
                          authSide: authSide,
                        ));
                  },
                  child: Text(
                    'Use phone number',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: AppColor),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Terms of use',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: AppColor),
                ),
                Text(
                  'Privacy Policy',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: AppColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
