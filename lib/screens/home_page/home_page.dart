import 'dart:math';

import 'package:dating_app/arguments/chat_screen_arguments.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/logic/data/conversations.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/main.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/home_page/chat/screens/chat_screen.dart';
import 'package:dating_app/screens/home_page/chat/screens/conversations_screen.dart';
import 'package:dating_app/screens/home_page/discover_screen.dart';
import 'package:dating_app/screens/home_page/matches_screen.dart';
import 'package:dating_app/screens/home_page/profile_screen.dart';
import 'package:dating_app/services/db_services.dart';
import 'package:dating_app/services/notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  late FirebaseauthBloc firebaseauthBloc;
  late DbServices db;
  List<CurrentUser?>? conversationUsers;
  late List<CurrentUser?> users;
  List<Conversations?>? conversations;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    firebaseauthBloc = BlocProvider.of<FirebaseauthBloc>(context);

    LocalNotificationService.initialize(context);

    db = DbServices();
    WidgetsBinding.instance!.addObserver(this);
    getDeviceTokens();
    db.userStatusOnline();

    //Gives the message on which user taps and it open the app from terminated
    //state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        final routeNames = routeFromMessage.split(",");
        final Map<int, String> splitRoutes = {
          for (int i = 0; i < routeNames.length; i++) i: routeNames[i]
        };
        Navigator.of(context).pushNamed(ConversationsScreen.routeName);

        if (splitRoutes[0] == ChatScreen.routeName) {
          Navigator.of(context).pushNamed(splitRoutes[0]!,
              arguments: ChatScreenArguments(splitRoutes[1]!, splitRoutes[2]!));
        }
      }
    });

    //Called when the app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });

    //Called when the app is in background but not terminated
    //And user taps on notification from notification tray
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      final routeNames = routeFromMessage.split(",");
      final Map<int, String> splitRoutes = {
        for (int i = 0; i < routeNames.length; i++) i: routeNames[i]
      };

      if (splitRoutes[0] == ChatScreen.routeName) {
        Navigator.of(context).pushNamed(splitRoutes[0]!,
            arguments: ChatScreenArguments(splitRoutes[1]!, splitRoutes[2]!));
      }
    });
  }

  Future<void> getDeviceTokens() async {
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await db.saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(db.saveTokenToDatabase);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      db.userStatusOnline();
    } else {
      db.userStatusOffline();
    }
  }

  @override
  Widget build(BuildContext context) {
    myContext = context;
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
    return [
      DiscoverScreen(),
      MatchesScreen(),
      ConversationsScreen(),
      ProfilePage()
    ];
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
