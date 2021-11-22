import 'package:dating_app/arguments/email_password_arguments.dart';
import 'package:dating_app/arguments/link_phone_email_arguments.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/link_phoneemail_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailPasswordScreen extends StatefulWidget {
  static const routeName = '/emailPasswordScreen';

  const EmailPasswordScreen({Key? key}) : super(key: key);

  @override
  _EmailPasswordScreenState createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String sessionUid = "";
  late FirebaseauthBloc firebaseauthBloc;

  @override
  void initState() {
    firebaseauthBloc = BlocProvider.of<FirebaseauthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EmailPasswordArguments;
    return Form(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(25.0.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    IconsOutlinedButton(
                        icon: Icons.arrow_back,
                        size: Size(52.sp, 52.sp),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
                SizedBox(height: 40.h),
                Row(
                  children: [
                    Text(
                      'Email',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 40.0.sp),
                  child: Text(
                    'Please enter your email address and password. to ${args.authSide}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(height: 20.h),
                Form(
                    key: _formKey,
                    child: Column(
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
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: const BorderSide(color: appColor)),
                              focusColor: appColor,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r),
                                gapPadding: 5.sp,
                                borderSide: const BorderSide(color: appColor),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: const BorderSide(color: appColor)),
                              labelText: "Enter Your Email",
                              labelStyle: const TextStyle(color: appColor)),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          validator: (val) {
                            String pattern =
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                            RegExp regex = RegExp(pattern);
                            if (val == null) {
                              return "Password cannot be empty";
                            } else if (!regex.hasMatch(val) &&
                                args.authSide == "Sign Up") {
                              return 'Password should contain at least 8 characters, at least one uppercase letter, at least one lowercase letter,at least one digit and at least one special character';
                            }
                            return null;
                          },
                          obscureText: obscurePassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  child: obscurePassword
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: Colors.black,
                                          size: 25.sp,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: Colors.black,
                                          size: 25.sp,
                                        )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: const BorderSide(color: appColor)),
                              focusColor: appColor,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r),
                                gapPadding: 5.sp,
                                borderSide: const BorderSide(color: appColor),
                              ),
                              errorMaxLines: 4,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: const BorderSide(color: appColor)),
                              labelText: "Enter Your Password",
                              labelStyle: const TextStyle(color: appColor)),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 20.h),
                        args.authSide == "Sign Up"
                            ? TextFormField(
                                validator: (val) {
                                  if (val != passwordController.text) {
                                    return "Password does not match";
                                  }
                                  return null;
                                },
                                obscureText: obscureConfirmPassword,
                                controller: confirmpasswordController,
                                decoration: InputDecoration(
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            obscureConfirmPassword =
                                                !obscureConfirmPassword;
                                          });
                                        },
                                        child: obscureConfirmPassword
                                            ? Icon(
                                                Icons.visibility_off,
                                                color: Colors.black,
                                                size: 25.sp,
                                              )
                                            : Icon(
                                                Icons.visibility,
                                                color: Colors.black,
                                                size: 25.sp,
                                              )),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        borderSide:
                                            const BorderSide(color: appColor)),
                                    focusColor: appColor,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                      gapPadding: 5.sp,
                                      borderSide: const BorderSide(color: appColor),
                                    ),
                                    errorMaxLines: 4,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        borderSide:
                                            const BorderSide(color: appColor)),
                                    labelText: "Confirm Your Password",
                                    labelStyle: const TextStyle(color: appColor)),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                              )
                            : Container(),
                      ],
                    )),
                const Spacer(),
                BlocConsumer<FirebaseauthBloc, FirebaseauthState>(
                  /* listenWhen: (previousState, currentState) {
                    if (previousState is OperationInProgress &&
                        (currentState is UserLoggedIn ||
                            currentState is UserSignedUp)) {
                      return true;
                    }
                    return false;
                  }, */
                  listener: (context, state) {
                    if (state is UserSignedUp) {
                      firebaseauthBloc.add(EmailVerificationRequested());
                    } else if (state is EmailVerificationSentState) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Message"),
                          content: const Text(
                              "An email verification link has been sent to your email id. Please verify your email to continue."),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  if (args.authSide == "Sign Up") {
                                    firebaseauthBloc.add(SignOutRequested());
                                    changePagewithoutBackWithNamedRoutes(
                                        context: context,
                                        routeName:
                                            ChooseSignInSignUpPage.routeName);
                                    changePageWithNamedRoutes(
                                        context: context,
                                        routeName:
                                            EmailPasswordScreen.routeName,
                                        arguments: EmailPasswordArguments(
                                            authSide: "Sign In"));
                                  }
                                },
                                child: const Text("Ok"))
                          ],
                        ),
                      );
                    } else if (state is UserLoggedIn) {
                      sessionUid = state.userUID;
                      firebaseauthBloc
                          .add(SignedInforFirstTimeEvent(uid: state.userUID));
                    } else if (state is NotSignedInForFirstTimeState) {
                      SharedObjects.prefs?.setString(
                          SessionConstants.sessionSignedInWith, "email");
                      SharedObjects.prefs
                          ?.setString(SessionConstants.sessionUid, sessionUid);
                      changePagewithoutBackWithNamedRoutes(
                          context: context, routeName: HomePage.routeName);
                    } else if (state is EmailVerifiedState) {
                      SharedObjects.prefs?.setString(
                          SessionConstants.sessionSignedInWith, "email");
                      SharedObjects.prefs
                          ?.setString(SessionConstants.sessionUid, sessionUid);
                      firebaseauthBloc.add(LinkStatusEvent(uid: sessionUid));
                    } else if (state is PhoneEmailNotLinkedState) {
                      changePageWithNamedRoutes(
                        context: context,
                        routeName: LinkPhoneEmailScreen.routeName,
                        arguments:
                            LinkPhoneEmailArguments(connectWith: 'phone'),
                      );
                    } else if (state is PhoneEmailLinkedState) {
                      changePageWithNamedRoutes(
                          context: context,
                          routeName: ProfileDetailPage.routeName);
                    } else if (state is EmailNotVerifiedState) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Message"),
                          content: const Text(
                              "An email verification link has been sent to your email id. Please verify your email to continue."),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: const Text("Ok"))
                          ],
                        ),
                      );
                    } else if (state is RequestedOperationFailed) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Message"),
                          content: Text(state.errorMessage.toString()),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: const Text("Ok"))
                          ],
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is OperationInProgress) {
                      return const CircularProgressIndicator();
                    }
                    return CommonButton(
                        text: args.authSide,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (args.authSide == 'Sign Up') {
                              firebaseauthBloc.add(
                                  SignUpWithEmailPasswordRequested(
                                      emailId: emailIdController.text,
                                      password: passwordController.text));
                            } else {
                              firebaseauthBloc.add(
                                  SignInWithEmailPasswordRequested(
                                      emailId: emailIdController.text,
                                      password: passwordController.text));
                            }
                          }
                        });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// widget:
