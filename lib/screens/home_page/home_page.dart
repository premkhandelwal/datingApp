import 'dart:math';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/home_page/chat/chat_screen.dart';
import 'package:dating_app/screens/home_page/discover_screen.dart';
import 'package:dating_app/screens/home_page/matches_screen.dart';
import 'package:dating_app/screens/home_page/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/homePage';
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  late FirebaseauthBloc firebaseauthBloc;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    firebaseauthBloc = BlocProvider.of<FirebaseauthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseauthBloc, FirebaseauthState>(
      buildWhen: (p, c) {
        if (c is FirebaseauthInitial ||
            c is UserLoggedOut ||
            c is UserLoggedIn) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is FirebaseauthInitial) {
          firebaseauthBloc.add(UserStateRequested());
          return Container();
        } else if (state is UserLoggedOut) {
          return ChooseSignInSignUpPage();
        }
        return persistentTabView(context);
      },
    );
  }

  PersistentTabView persistentTabView(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Color(0xffF3F3F3),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0.r),
        colorBehindNavBar: Color(0xffF3F3F3),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.linearToEaseOut,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style13,
    );
  }

  List<Widget> _buildScreens() {
    return [DiscoverScreen(), MatchesScreen(), ChatScreen(), ProfilePage()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.recent_actors),
        title: ("Discover"),
        activeColorPrimary: Colors.grey,
        activeColorSecondary: AppColor,
      ),
      PersistentBottomNavBarItem(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.favorite_border),
            if (Random().nextBool())
              Positioned(
                top: -8.sp,
                right: -10.sp,
                child: CircleAvatar(
                  radius: 12.r,
                  backgroundColor: AppColor,
                  child: Text(
                    '5',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Modernist',
                        color: Colors.white),
                  ),
                ),
              )
          ],
        ),
        title: ("Matches"),
        activeColorPrimary: Colors.grey,
        activeColorSecondary: AppColor,
      ),
      PersistentBottomNavBarItem(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.chat),
            if (Random().nextBool())
              Positioned(
                top: -8.sp,
                right: -10.sp,
                child: CircleAvatar(
                  radius: 12.r,
                  backgroundColor: AppColor,
                  child: Text(
                    '5',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Modernist',
                        color: Colors.white),
                  ),
                ),
              )
          ],
        ),
        title: ("Chat"),
        activeColorPrimary: Colors.grey,
        activeColorSecondary: AppColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Colors.grey,
        activeColorSecondary: AppColor,
      ),
    ];
  }
}
