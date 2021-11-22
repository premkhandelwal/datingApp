import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating_app/arguments/signin_signup_selection_arguments.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/email_phone_selection_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseSignInSignUpPage extends StatefulWidget {
  static const routeName = '/chooseSignInSignUpPage';

  const ChooseSignInSignUpPage({Key? key}) : super(key: key);

  @override
  _ChooseSignInSignUpPageState createState() => _ChooseSignInSignUpPageState();
}

class _ChooseSignInSignUpPageState extends State<ChooseSignInSignUpPage> {
  List image = [
    'assets/images/female_model_1.png',
    'assets/images/female_model_2.png',
    'assets/images/female_model_3.png'
  ];
  int _current = 0;
  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                  height: 400.h,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: image.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        image: DecorationImage(
                            image: AssetImage('$i'),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topRight),
                      ),
                    );
                    // return Image.asset(
                    //
                    //   fit: BoxFit.fitHeight,
                    // );
                  },
                );
              }).toList(),
            ),
            if (_current == 0)
              Column(
                children: [
                  Text(
                    'Algorithm',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: appColor, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                    child: Text(
                      'We match you with people that have a large array of similar interests.',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            if (_current == 1)
              Column(
                children: [
                  Text(
                    'Matches',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: appColor, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                    child: Text(
                      'Sign up today and enjoy the first month of premium benefits on us.',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            if (_current == 2)
              Column(
                children: [
                  Text(
                    'Premium',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: appColor, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                    child: Text(
                      'Users going through a vetting process to ensure you never match with bots.',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: image.asMap().entries.map((entry) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _current = entry.key;
                      buttonCarouselController.animateToPage(entry.key);
                    });
                  },
                  child: Container(
                    width: 8.0.w,
                    height: 8.0.h,
                    margin: EdgeInsets.symmetric(
                        vertical: 4.0.sp, horizontal: 4.0.sp),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColor.withOpacity(
                            _current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
            CommonButton(
                text: 'Create an account',
                onPressed: () {
                  changePageWithNamedRoutes(
                      context: context,
                      routeName: SignUpSignInSelectionScreen.routeName,
                      arguments: SignInSignUpSelectionArguments(
                          authSide: 'Sign Up'));
                }),
            RichText(
              text: TextSpan(
                  text: 'Already have an account?',
                  style: Theme.of(context).textTheme.subtitle1,
                  children: [
                    TextSpan(
                        text: 'Sign In',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(
                                color: appColor, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            changePageWithNamedRoutes(
                                context: context,
                                routeName:
                                    SignUpSignInSelectionScreen.routeName,
                                arguments: SignInSignUpSelectionArguments(
                                    authSide: 'Sign In'));
                          }),
                  ]),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
