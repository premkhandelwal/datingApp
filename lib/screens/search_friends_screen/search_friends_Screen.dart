import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/enable_notification_screen/enable_notification_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';

class SearchFriendsScreen extends StatelessWidget {
  const SearchFriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TopBarForSignUpAndSignIn(
                context: context,
              ),
              SizedBox(height: 20),
              Container(
                child: Center(
                    child:
                        Image.asset('assets/images/search_friends/people.png')),
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    'Search friend’s',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'You can find friends from your contact lists to connected',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
              Spacer(),
              CommonButton(
                  text: 'Access to a contact list',
                  onPressed: () {
                    changePageTo(
                        context: context, widget: EnableNotificationScreen());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
