import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/linkPhoneandEmail_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/phone_number_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPVerificationPage extends StatefulWidget {
  final String authSide;
  final String verificationId;
  final bool issignUpWithEmail;
  // This variable will be true when user has signed with email and password and we want him to add his phone number as well as the secondary login

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
  TextEditingController otpController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late FirebaseauthBloc firebaseauthBloc;

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
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SafeArea(
          child: Container(
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
                    child: PinFieldAutoFill(
                      controller: otpController,
                      autoFocus: true,
                      decoration: UnderlineDecoration(
                        hintText: '000000',
                        lineHeight: 1.h,
                        hintTextStyle:
                            TextStyle(fontSize: 20.sp, color: Colors.grey),
                        bgColorBuilder: FixedColorBuilder(AppColor),
                        textStyle:
                            TextStyle(fontSize: 20.sp, color: Colors.white),
                        gapSpace: 10.sp,
                        colorBuilder: FixedColorBuilder(AppColor),
                      ),
                      codeLength: 6,
                      // controller: otpController,
                    ),
                  ),
                  Spacer(),
                  BlocConsumer<FirebaseauthBloc, FirebaseauthState>(
                    /* listenWhen: (previousState, currentState) {
                      if ((previousState is OperationInProgress &&
                              currentState is OtpVerified) ||
                          currentState is OtpNotVerified ||
                          currentState is LinkedPhoneNumberWithEmail) {
                        return true;
                      }
                      return false;
                    }, */
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
                              firebaseauthBloc.add(!widget.issignUpWithEmail
                                  ? OtpVerificationRequested(
                                      smsCode: otpController.text,
                                      verificationId: widget.verificationId)
                                  : LinkPhoneNumberWithEmailEvent(
                                      smsCode: otpController.text,
                                      verificationId: widget.verificationId));
                            }
                          });
                    },
                    listener: (context, state) {
                      if (state is NotSignedInForFirstTimeState) {
                        if (state.userUID != null) {
                          SharedObjects.prefs?.setString(
                              SessionConstants.sessionSignedInWith,
                              "phone number");
                          SharedObjects.prefs?.setString(
                              SessionConstants.sessionUid, state.userUID!);

                          changePageWithoutBack(
                              context: context, widget: HomePage());
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text(
                                  "Something went wrong. Please try again later"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      changePageWithoutBack(
                                          context: context,
                                          widget: ChooseSignInSignUpPage());
                                    },
                                    child: Text("Ok"))
                              ],
                            ),
                          );
                        }
                      } else if (state is SignedInForFirstTimeState) {
                        changePageWithoutBack(
                            context: context,
                            widget: LinkPhoneEmailScreen(
                              connectWith: "email",
                            ));
                      } else if (state is LinkedPhoneNumberWithEmail) {
                        changePageWithoutBack(
                            context: context, widget: ProfileDetailPage());
                      } else if (state is OtpNotVerified) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Failed to verify otp!"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          changePageWithoutBack(
                                              context: context,
                                              widget: PhoneNumberPage(
                                                  authSide: widget.authSide));
                                        },
                                        child: Text("Ok"))
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
      ),
    );
  }
}
