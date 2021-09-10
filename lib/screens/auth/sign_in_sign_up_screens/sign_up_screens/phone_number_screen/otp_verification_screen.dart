import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/linkPhoneandEmail_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/phone_number_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPVerificationPage extends StatefulWidget {
  final String authSide;
  final String verificationId;
  final bool
      issignUpWithEmail; // This variable will be true when user has signed with email and password and we want him to add his phone number as well as the secondary login

  OTPVerificationPage(
      {Key? key,
      required this.authSide,
      required this.verificationId,
      required this.issignUpWithEmail})
      : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  bool _sendAgain = false;
  TextEditingController otpController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // _listenOTP();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    // otpController.dispose();
    super.dispose();
  }

  void _listenOTP() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
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
                        horizontal: 20.0, vertical: 20),
                    child: PinCodeTextField(
                        validator: (val) {
                          if (val == null) {
                            return "Otp cannot be empty";
                          } else if (val.length != 6) {
                            return 'Otp must be of 6 digit';
                          }
                        },
                        controller: otpController,
                        hintStyle: TextStyle(color: AppColor.withOpacity(0.3)),
                        textStyle: TextStyle(color: Colors.white),
                        autoFocus: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(15),
                          fieldHeight: 50,
                          fieldWidth: 50,
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
                  /* Container(
                    child: PinFieldAutoFill(
                      controller: otpController,

                      decoration: UnderlineDecoration(
                        textStyle: TextStyle(fontSize: 20, color: Colors.black),
                        colorBuilder:
                            FixedColorBuilder(Colors.black.withOpacity(0.3)),
                      ),
                      codeLength: 6,
                      // controller: otpController,
                    ),
                  ), */
                  Spacer(),
                  BlocConsumer<FirebaseauthBloc, FirebaseauthState>(
                    listenWhen: (previousState, currentState) {
                      if ((previousState is OperationInProgress &&
                              currentState is OtpVerified) ||
                          currentState is OtpNotVerified ||
                          currentState is LinkedPhoneNumberWithEmail) {
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
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<FirebaseauthBloc>()
                                  .add(!widget.issignUpWithEmail
                                      ? OtpVerificationRequested(
                                          smsCode: otpController.text,
                                          verificationId: widget.verificationId)
                                      : LinkPhoneNumberWithEmailEvent(
                                          smsCode: otpController.text,
                                          verificationId:
                                              widget.verificationId));
                            }
                          });
                    },
                    listener: (context, state) {
                      if (state is OtpVerified) {
                        if (widget.authSide != "Sign Up") {
                          SharedObjects.prefs?.setString(
                              SessionConstants.sessionSignedInWith, "phone number");
                          SharedObjects.prefs?.setString(
                              SessionConstants.sessionUid, state.userUID!);
                        }

                        changePageWithoutBack(
                            context: context,
                            widget: widget.authSide == 'Sign Up'
                                ? LinkPhoneEmailScreen(
                                    connectWith: "email",
                                  )
                                : HomePage());
                      } else if (state is LinkedPhoneNumberWithEmail) {
                        changePageWithoutBack(
                            context: context, widget: ProfileDetailPage());
                      } else if (state is OtpNotVerified) {
                        showDialog(
                            context: context,
                            builder: (contextz) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Failed to verify otp!"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          changePageTo(
                                              context: contextz,
                                              widget: PhoneNumberPage(
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
      ),
    );
  }
}
