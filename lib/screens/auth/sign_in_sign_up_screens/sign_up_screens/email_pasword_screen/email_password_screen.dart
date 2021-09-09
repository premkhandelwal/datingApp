import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/linkPhoneandEmail_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailPasswordScreen extends StatefulWidget {
  final String authSide;

  const EmailPasswordScreen({Key? key, required this.authSide})
      : super(key: key);

  @override
  _EmailPasswordScreenState createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailIdController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconsOutlinedButton(
                        icon: Icons.arrow_back,
                        size: Size(52, 52),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Text(
                      'Email',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: Text(
                    'Please enter your email address and password. to ${widget.authSide}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(height: 40),
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
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: AppColor)),
                              focusColor: AppColor,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                gapPadding: 5,
                                borderSide: BorderSide(color: AppColor),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: AppColor)),
                              labelText: "Enter Your Email",
                              labelStyle: TextStyle(color: AppColor)),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20),
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
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: AppColor)),
                              focusColor: AppColor,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                gapPadding: 5,
                                borderSide: BorderSide(color: AppColor),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: AppColor)),
                              labelText: "Enter Your Password",
                              labelStyle: TextStyle(color: AppColor)),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                        ),
                      ],
                    )),
                Spacer(),
                BlocConsumer<FirebaseauthBloc, FirebaseauthState>(
                  listenWhen: (previousState, currentState) {
                    if (previousState is OperationInProgress &&
                        (currentState is UserLoggedIn ||
                            currentState is UserSignedUp)) {
                      return true;
                    }
                    return false;
                  },
                  listener: (context, state) {
                    if (state is UserSignedUp) {
                      changePageWithoutBack(
                          context: context, widget: LinkPhoneEmailScreen(connectWith: "phone number",));
                    } else if (state is UserLoggedIn) {
                      changePageWithoutBack(
                          context: context, widget: HomePage());
                    }
                  },
                  builder: (context, state) {
                    if (state is OperationInProgress) {
                      return CircularProgressIndicator();
                    }
                    return CommonButton(
                        text: widget.authSide,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.authSide == 'Sign Up') {
                              context.read<FirebaseauthBloc>().add(
                                  SignUpWithEmailPasswordRequested(
                                      emailId: emailIdController.text,
                                      password: passwordController.text));
                            } else {
                              context.read<FirebaseauthBloc>().add(
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
