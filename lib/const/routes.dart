import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/link_phoneemail_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/email_pasword_screen/email_password_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/email_phone_selection_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/gender_selection_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/interested_in_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/otp_verification_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/phone_number_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/your_interest_screen.dart';
import 'package:dating_app/screens/enable_notification_screen/enable_notification_screen.dart';
import 'package:dating_app/screens/home_page/chat/screens/chat_screen.dart';
import 'package:dating_app/screens/home_page/chat/screens/conversations_screen.dart';
import 'package:dating_app/screens/home_page/chat/screens/video_player_screen.dart';
import 'package:dating_app/screens/home_page/discover_screen.dart';
import 'package:dating_app/screens/home_page/full_screen_image.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:dating_app/screens/home_page/matches_screen.dart';
import 'package:dating_app/screens/home_page/profile_screen.dart';
import 'package:dating_app/screens/search_friends_screen/search_friend_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> namedRoutes = {
  DiscoverScreen.routeName: (context) => const DiscoverScreen(),
  MatchesScreen.routeName: (context) => const MatchesScreen(),
  ProfilePage.routeName: (context) => const ProfilePage(),
  ChooseSignInSignUpPage.routeName: (context) => const ChooseSignInSignUpPage(),
  LinkPhoneEmailScreen.routeName: (context) => const LinkPhoneEmailScreen(),
  SignUpSignInSelectionScreen.routeName: (context) =>
      const SignUpSignInSelectionScreen(),
  GenderSelectionScreen.routeName: (context) => const GenderSelectionScreen(),
  InterestedInScreen.routeName: (context) => const InterestedInScreen(),
  ProfileDetailPage.routeName: (context) => const ProfileDetailPage(),
  YourInterestScreen.routeName: (context) => const YourInterestScreen(),
  EmailPasswordScreen.routeName: (context) => const EmailPasswordScreen(),
  OTPVerificationPage.routeName: (context) => const OTPVerificationPage(),
  PhoneNumberPage.routeName: (context) => const PhoneNumberPage(),
  EnableNotificationScreen.routeName: (context) => const EnableNotificationScreen(),
  FullScreenImage.routeName: (context) => const FullScreenImage(),
  HomePage.routeName: (context) => const HomePage(),
  SearchFriendsScreen.routeName: (context) => const SearchFriendsScreen(),
  ConversationsScreen.routeName: (context) => const ConversationsScreen(),
  VideoPlayerScreen.routeName: (context) => const VideoPlayerScreen(),
  ChatScreen.routeName: (context) => const ChatScreen(),
};
