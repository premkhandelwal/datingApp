import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnableNotificationScreen extends StatelessWidget {
  static const routeName = '/enableNotificationScreen';

  const EnableNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              SizedBox(height: 20.h),
              Center(
                  child: Image.asset(
                      'assets/images/enable_notification/chat.png')),
              const Spacer(),
              Column(
                children: [
                  Text(
                    'Enable notification’s',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                    child: Text(
                      'Get push-notification when you get the match or receive a message.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CommonButton(
                  text: 'I want to be notified',
                  onPressed: () {
                    changePageWithNamedRoutes(
                        context: context, routeName: HomePage.routeName);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
