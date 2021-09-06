import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerificationPage extends StatefulWidget {
  final String authSide;

  OTPVerificationPage({Key? key, required this.authSide}) : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  bool _sendAgain = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomAppBar(
                  context: context,
                  centerWidget: Container(),
                  trailingWidget: Container(),
                ),
                SizedBox(height: 60),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Type the verification code \nwe’ve sent you',
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20),
                  child: PinCodeTextField(
                      animationType: AnimationType.scale,
                      length: 6,
                      hintStyle: TextStyle(color: AppColor.withOpacity(0.3)),
                      textStyle: TextStyle(color: Colors.white),
                      autoFocus: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 50,
                        fieldWidth: 47,
                        activeColor: Colors.pink,
                        activeFillColor: AppColor,
                        inactiveFillColor: Colors.grey.withOpacity(0),
                        selectedFillColor: AppColor.withOpacity(0),
                        inactiveColor: AppColor.withOpacity(0.3),
                        selectedColor: AppColor,
                      ),
                      cursorColor: AppColor,
                      appContext: context,
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      hintCharacter: '0',
                      useHapticFeedback: true,
                      onChanged: (value) {
                        print(value);
                      }),
                ),
                Spacer(),
                CommonButton(
                    text: 'Continue',
                    onPressed: () {
                      changePageTo(
                          context: context,
                          widget: widget.authSide == 'Sign Up'
                              ? ProfileDetailPage()
                              : HomePage());
                    }),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
