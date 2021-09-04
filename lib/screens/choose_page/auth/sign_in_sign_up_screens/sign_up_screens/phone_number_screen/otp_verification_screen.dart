import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseauth_bloc.dart';
import 'package:dating_app/screens/choose_page/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/phone_number_screen.dart';
import 'package:dating_app/screens/choose_page/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPVerificationPage extends StatefulWidget {
  final String authSide;
  final String verificationId;

  OTPVerificationPage(
      {Key? key, required this.authSide, required this.verificationId})
      : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  bool _sendAgain = false;
  TextEditingController otpController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TopBarForSignUpAndSignIn(
                  context: context,
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
                      horizontal: 20.0, vertical: 20),
                  child: PinCodeTextField(
                      controller: otpController,
                      hintStyle: TextStyle(color: AppColor.withOpacity(0.3)),
                      textStyle: TextStyle(color: Colors.white),
                      autoFocus: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(15),
                        fieldHeight: 70,
                        fieldWidth: 67,
                        activeColor: Colors.pink,
                        activeFillColor: AppColor,
                        inactiveFillColor: Colors.grey.withOpacity(0),
                        selectedFillColor: AppColor.withOpacity(0),
                        inactiveColor: AppColor.withOpacity(0.3),
                        selectedColor: AppColor,
                      ),
                      cursorColor: AppColor,
                      appContext: context,
                      length: 6,
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      hintCharacter: '0',
                      useHapticFeedback: true,
                      onChanged: (value) {
                        print(value);
                      }),
                ),
                Spacer(),
                BlocConsumer<FirebaseauthBloc, FirebaseauthState>(
                  listenWhen: (previousState, currentState) {
                    if ((previousState is OperationInProgress &&
                            currentState is OtpVerified) ||
                        currentState is OtpNotVerified) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state is OperationInProgress) {
                      return CircularProgressIndicator();
                    } else if (state is OtpNotVerified) {
                      return Container();
                    }
                    return CommonButton(
                        text: 'Continue',
                        onPressed: () {
                          context.read<FirebaseauthBloc>().add(
                              OtpVerificationRequested(
                                  smsCode: otpController.text,
                                  verificationId: widget.verificationId));
                        });
                  },
                  listener: (context, state) {
                    if (state is OtpVerified) {
                      changePageWithoutBack(
                          context: context,
                          widget: widget.authSide == 'Sign Up'
                              ? ProfileDetailPage()
                              : HomePage());
                    } else if (state is OtpNotVerified) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Error"),
                                content: Text("Failed to verify otp!"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        changePageTo(
                                            context: context, widget: PhoneNumberPage(
                                                    authSide: widget.authSide));
                                       
                                      },
                                      child: Text("Ok"))
                                ],
                              ));
                    }
                  },
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
