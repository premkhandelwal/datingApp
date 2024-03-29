import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/repositories/firebase_auth_repo.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/enable_notification_screen/enable_notification_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFriendsScreen extends StatelessWidget {
  const SearchFriendsScreen({Key? key}) : super(key: key);

  static const routeName = '/searchFriendsScreen';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Confirm'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuthRepository().signOut();
                          Navigator.pop(ctx);
                          changePagewithoutBackWithNamedRoutes(
                              context: context,
                              routeName: ChooseSignInSignUpPage.routeName);
                        },
                        child: const Text('Yes')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text('No')),
                  ],
                ));

        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomAppBar(
                  canGoBack: false,
                  context: context,
                  centerWidget: Container(),
                  trailingWidget: Container(),
                ),
                SizedBox(height: 20.h),
                Center(
                    child: Image.asset(
                        'assets/images/search_friends/people.png')),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      'Search friend’s',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                      child: Text(
                        'You can find friends from your contact lists to connected',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                CommonButton(
                    text: 'Access to a contact list',
                    onPressed: () {
                      changePageWithNamedRoutes(
                          context: context,
                          routeName: EnableNotificationScreen.routeName);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
