import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/linkPhoneandEmail_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/email_pasword_screen/email_password_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/email_phone_selection_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/gender_selection_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/interestedIn.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/otp_verification_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/phone_number_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/your_interest_screen.dart';
import 'package:dating_app/screens/enable_notification_screen/enable_notification_screen.dart';
import 'package:dating_app/screens/home_page/discover_screen.dart';
import 'package:dating_app/screens/home_page/full_screen_image.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/screens/home_page/matches_screen.dart';
import 'package:dating_app/screens/home_page/profile_screen.dart';
import 'package:dating_app/screens/search_friends_screen/search_friends_Screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> namedRoutes = {
  DiscoverScreen.routeName: (context) => const DiscoverScreen(),
  MatchesScreen.routeName: (context) => const MatchesScreen(),
  ProfilePage.routeName: (context) => ProfilePage(),
  ChooseSignInSignUpPage.routeName: (context) => ChooseSignInSignUpPage(),
  LinkPhoneEmailScreen.routeName: (context) => LinkPhoneEmailScreen(),
  SignUpSignInSelectionScreen.routeName: (context) => SignUpSignInSelectionScreen(),
  GenderSelectionScreen.routeName: (context) => GenderSelectionScreen(),
  InterestedInScreen.routeName: (context) => InterestedInScreen(),
  ProfileDetailPage.routeName: (context) => ProfileDetailPage(),
  YourInterestScreen.routeName: (context) => YourInterestScreen(),
  EmailPasswordScreen.routeName: (context) => EmailPasswordScreen(),
  OTPVerificationPage.routeName: (context) => OTPVerificationPage(),
  PhoneNumberPage.routeName: (context) => PhoneNumberPage(),
  EnableNotificationScreen.routeName: (context) => EnableNotificationScreen(),
  FullScreenImage.routeName: (context) => FullScreenImage(),
  HomePage.routeName: (context) => HomePage(),
  SearchFriendsScreen.routeName: (context) => SearchFriendsScreen()
  
};
