import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/screens/choose_page/auth/sign_in_sign_up_screens/sign_up_screens/email_phone_selection_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChooseSignInSignUpPage extends StatefulWidget {
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
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CarouselSlider(
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                    height: 400,
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
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
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
                          color: AppColor, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          color: AppColor, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          color: AppColor, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  print(entry.key);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _current = entry.key;
                        buttonCarouselController.animateToPage(entry.key);
                      });
                    },
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.withOpacity(
                              _current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
              CommonButton(
                  text: 'Create an account',
                  onPressed: () {
                    changePageTo(
                        context: context,
                        widget: SignUpSignInSelectionScreen(
                          authSide: 'Sign Up',
                        ));
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
                                  color: AppColor, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              changePageTo(
                                  context: context,
                                  widget: SignUpSignInSelectionScreen(
                                    authSide: 'Sign In',
                                  ));
                            }),
                    ]),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
