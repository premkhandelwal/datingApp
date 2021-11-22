import 'package:dating_app/arguments/email_password_arguments.dart';
import 'package:dating_app/arguments/phone_number_arguments.dart';
import 'package:dating_app/arguments/signin_signup_selection_arguments.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/email_pasword_screen/email_password_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/phone_number_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpSignInSelectionScreen extends StatelessWidget {
  static const routeName = '/signUpSignInSelectionScreen';
  const SignUpSignInSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as SignInSignUpSelectionArguments;

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
                  child: const Text('LOGO HERE'),
                  backgroundColor: appColor,
                  radius: 50.r,
                ),
              ],
            ),
            Text(
              '${args.authSide} to continue',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Column(
              children: [
                CommonButton(
                  onPressed: () {
                    changePageWithNamedRoutes(
                        context: context,
                        routeName: EmailPasswordScreen.routeName,
                        arguments: EmailPasswordArguments(authSide: args.authSide));
                  },
                  text: "Continue with email",
                  textSize: 18.sp,
                ),
                SizedBox(height: 40.h),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(350.sp, 60.sp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  onPressed: () {
                    changePageWithNamedRoutes(
                        context: context,
                        routeName: PhoneNumberPage.routeName,
                        arguments:
                            PhoneNumberArguments(authSide: args.authSide));
                  },
                  child: Text(
                    'Use phone number',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: appColor),
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
                      .copyWith(color: appColor),
                ),
                Text(
                  'Privacy Policy',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: appColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
