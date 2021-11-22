import 'dart:async';

import 'package:dating_app/arguments/link_phone_email_arguments.dart';
import 'package:dating_app/arguments/otp_verification_arguments.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/link_phoneemail_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPVerificationPage extends StatefulWidget {
  static const routeName = '/otpVerificationPage';

  // This variable will be true when user has signed with email and password and we want him to add his phone number as well as the secondary login

  const OTPVerificationPage({Key? key}) : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late FirebaseauthBloc firebaseauthBloc;

  var counterStream = Stream<int>.periodic(const Duration(seconds: 1), (x) {
    return 30 - x;
  }).take(31);

  @override
  void initState() {
    firebaseauthBloc = BlocProvider.of<FirebaseauthBloc>(context);
    _listenOTP();
    super.initState();
  }

  void _listenOTP() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as OtpVerificationArguments;

    return Form(
      key: _formKey,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0.sp),
            child: Column(
              children: [
                CustomAppBar(
                  context: context,
                  centerWidget: Container(),
                  trailingWidget: Container(),
                ),
                SizedBox(height: 60.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Type the verification code \nwe’ve sent you',
                      style: Theme.of(context).textTheme.subtitle2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Code will expire in: ",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    TweenAnimationBuilder<double>(
                        tween: Tween(begin: 30.0, end: 0),
                        duration: const Duration(seconds: 30),
                        builder: (ctx, value, child) {
                          if (value.toInt() == 0) {
                            firebaseauthBloc.add(OtpRetrievalTimeOut());
                          }
                          return Text(
                            "00:${value.toInt().toString().padLeft(2, '0')}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(color: Colors.red),
                          );
                        }),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: 20.0, vertical: 20),
                //   child: PinCodeTextField(
                //       validator: (val) {
                //         if (val == null) {
                //           return "Otp cannot be empty";
                //         } else if (val.length != 6) {
                //           return 'Otp must be of 6 digit';
                //         }
                //       },
                //       controller: otpController,
                //       hintStyle: TextStyle(color: AppColor.withOpacity(0.3)),
                //       textStyle: TextStyle(color: Colors.white),
                //       autoFocus: true,
                //       pinTheme: PinTheme(
                //         shape: PinCodeFieldShape.box,
                //         borderRadius: BorderRadius.circular(15),
                //         fieldHeight: 50,
                //         fieldWidth: 50,
                //         activeColor: Colors.pink,
                //         activeFillColor: AppColor,
                //         inactiveFillColor: Colors.grey.withOpacity(0),
                //         selectedFillColor: AppColor.withOpacity(0),
                //         inactiveColor: AppColor.withOpacity(0.3),
                //         selectedColor: AppColor,
                //       ),
                //       cursorColor: AppColor,
                //       appContext: context,
                //       length: 6,
                //       enableActiveFill: true,
                //       keyboardType: TextInputType.number,
                //       hintCharacter: '0',
                //       useHapticFeedback: true,
                //       onChanged: (value) {
                //         print(value);
                //       }),
                // ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0.sp, vertical: 20.sp),
                  child: StreamBuilder<String>(
                      stream: SmsAutoFill().code,
                      builder: (context, snapshot) {
                        otpController.text =
                            snapshot.data ?? otpController.text;
                        return PinFieldAutoFill(
                          currentCode: otpController.text,
                          controller: otpController,
                          autoFocus: true,
                          decoration: UnderlineDecoration(
                            hintText: '000000',
                            lineHeight: 1.h,
                            hintTextStyle:
                                TextStyle(fontSize: 20.sp, color: Colors.grey),
                            bgColorBuilder: const FixedColorBuilder(appColor),
                            textStyle:
                                TextStyle(fontSize: 20.sp, color: Colors.white),
                            gapSpace: 10.sp,
                            colorBuilder: const FixedColorBuilder(appColor),
                          ),
                          codeLength: 6,
                          // controller: otpController,
                        );
                      }),
                ),
                /*  const SizedBox(height: 30),
                StreamBuilder<int>(
                    stream: counterStream,
                    builder: (ctx, snapshot) {
                      if (snapshot.data == null) {
                        return const Text("Resend OTP in: 00 : 30");
                      } else if (snapshot.data == 0) {
                        return Container();
                      }
                      return Text("Resend OTP in: 00 : " +
                          snapshot.data.toString().padLeft(2, '0'));
                    }), */
                const Spacer(),
                BlocConsumer<FirebaseauthBloc, FirebaseauthState>(
                  builder: (context, state) {
                    if (state is OperationInProgress) {
                      return const CircularProgressIndicator();
                    } else if (state is OtpNotVerified) {
                      return Container();
                    } else if (state is OtpRetrievalTimedOut) {
                      return const Text("Redirecting...");
                    }
                    return CommonButton(
                        text: 'Continue',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            firebaseauthBloc.add(!args.issignUpWithEmail
                                ? OtpVerificationRequested(
                                    smsCode: otpController.text,
                                    verificationId: args.verificationId)
                                : LinkPhoneNumberWithEmailEvent(
                                    smsCode: otpController.text,
                                    verificationId: args.verificationId));
                          }
                        });
                  },
                  listener: (context, state) {
                    if (state is OtpRetrievalTimedOut) {
                      Navigator.pop(context);
                    } else if (state is SignedInForFirstTimeState) {
                      changePageWithNamedRoutes(
                        context: context,
                        routeName: LinkPhoneEmailScreen.routeName,
                        arguments:
                            LinkPhoneEmailArguments(connectWith: 'email'),
                      );
                    } else if (state is LinkedPhoneNumberWithEmail ||
                        state is LinkedEmailWithPhoneNumber) {
                      changePagewithoutBackWithNamedRoutes(
                          context: context,
                          routeName: ProfileDetailPage.routeName);
                    } else if (state is NotSignedInForFirstTimeState) {
                      if (state.userUID != null) {
                        SharedObjects.prefs?.setString(
                            SessionConstants.sessionSignedInWith,
                            "phone number");
                        SharedObjects.prefs?.setString(
                            SessionConstants.sessionUid, state.userUID!);
                        changePagewithoutBackWithNamedRoutes(
                            context: context, routeName: HomePage.routeName);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Error"),
                            content: const Text(
                                "Something went wrong. Please try again later"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    changePagewithoutBackWithNamedRoutes(
                                        context: context,
                                        routeName:
                                            ChooseSignInSignUpPage.routeName);
                                  },
                                  child: const Text("Ok"))
                            ],
                          ),
                        );
                      }
                    } else if (state is OtpNotVerified) {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Failed to verify otp!"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text("Ok"))
                                ],
                              ));
                    }
                  },
                ),
                SizedBox(height: 20.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
