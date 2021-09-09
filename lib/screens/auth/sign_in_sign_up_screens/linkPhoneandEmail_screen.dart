import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/otp_verification_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LinkPhoneEmailScreen extends StatelessWidget {
  final String connectWith;
  LinkPhoneEmailScreen({Key? key, required this.connectWith}) : super(key: key);
  final TextEditingController emailIdController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController phoneNumber = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    void codeSent(String verificationId, int? forceResendingToken) {
      /* context.read<FirebaseauthBloc>().add(UserStateNone());
      phoneNumber.clear(); */
      changePageTo(
          context: context,
          widget: OTPVerificationPage(
            issignUpWithEmail: true,
            verificationId: verificationId,
            authSide: "Sign Up",
          ));
    }
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CustomAppBar(
                  context: context,
                  centerWidget: Container(),
                  trailingWidget: Container(),
                ),
                SizedBox(
                  height: 60,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "What's your $connectWith?",
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Don't lose access to your account. connect it with $connectWith",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                connectWith == "email"
                    ? Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              if (val == null) {
                                return "Email ID cannot be empty";
                              } else if (!EmailValidator.validate(val)) {
                                return "Invalid email-id";
                              }
                              return null;
                            },
                            controller: emailIdController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontFamily: 'Modernist', fontSize: 20),
                              counterText: '',
                              hintText: "Email ID",
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            validator: (val) {
                              String pattern =
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                              RegExp regex = new RegExp(pattern);
                              if (val == null) {
                                return "Password cannot be empty";
                              } else if (!regex.hasMatch(val)) {
                                return 'Password should contain at least 8 characters, at least one uppercase letter, at least one lowercase letter, at least one digit and at least one special character';
                              }
                              return null;
                            },
                            controller: passwordController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontFamily: 'Modernist', fontSize: 20),
                              counterText: '',
                              hintText: "Password",
                            ),
                          ),
                        ],
                      )
                    : TextFormField(
                        validator: (val) {
                          if (val == null) {
                            return "Phone Number cannot be empty";
                          } else if (val.length != 10) {
                            return 'Phone Number must be of 10 digit';
                          }
                        },
                        controller: phoneNumber,
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontFamily: 'Modernist', fontSize: 20),
                          counterText: '',
                          hintText: "Phone Number",
                        ),
                      ),
                Spacer(),
                CommonButton(
                    text: 'Continue',
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      context.read<FirebaseauthBloc>().add(
                          connectWith == "email"
                              ? LinkEmailWithPhoneNumberEvent(
                                  user: user,
                                  emailId: emailIdController.text,
                                  password: passwordController.text)
                              : OtpSendRequested(
                                 codeAutoRetrievalTimeout: (id) {
                                    context
                                        .read<FirebaseauthBloc>()
                                        .add(OtpRetrievalTimeOut());
                                  },
                                  verificationFailed: (exception) {
                                    context.read<FirebaseauthBloc>().add(
                                        OtpRetrievalFailure(
                                            errorMessage: exception.code));
                                    //throw Exception(exception);
                                  },
                                  codeSent: codeSent,
                                  
                                  phoneNumber: phoneNumber.text));

                      /* changePageTo(
                          context: context, widget: ProfileDetailPage()); */
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
