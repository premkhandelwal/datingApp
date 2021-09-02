import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';

class EnableNotificationScreen extends StatelessWidget {
  const EnableNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TopBarForSignUpAndSignIn(
                context: context,
              ),
              SizedBox(height: 20),
              Container(
                child: Center(
                    child: Image.asset(
                        'assets/images/enable_notification/chat.png')),
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    'Enable notification’s',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Get push-notification when you get the match or receive a message.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
              Spacer(),
              CommonButton(
                  text: 'I want to be notified',
                  onPressed: () {
                    changePageTo(context: context, widget: HomePage());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
