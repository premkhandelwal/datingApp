import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/screens/choose_page/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';

class EmailPasswordScreen extends StatefulWidget {
  final String authSide;

  const EmailPasswordScreen({Key? key, required this.authSide})
      : super(key: key);

  @override
  _EmailPasswordScreenState createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        obscureText: true,
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
              CommonButton(
                  text: widget.authSide,
                  onPressed: () {
                    changePageTo(
                        context: context,
                        widget: widget.authSide == 'Sign Up'
                            ? ProfileDetailPage()
                            : HomePage());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
// widget:
