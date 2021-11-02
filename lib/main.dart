import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/routes.dart';
import 'package:dating_app/logic/providers/audio_player_provider.dart';
import 'package:dating_app/logic/providers/emoji_showing_provider.dart';
import 'package:dating_app/logic/providers/is_uploading_provider.dart';
import 'package:dating_app/logic/providers/recording_provider.dart';
import 'package:dating_app/logic/providers/text_time_provider.dart';
import 'package:dating_app/logic/providers/youtube_player_provider.dart';
import 'package:dating_app/services/db_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/logic/repositories/firebaseAuthRepo.dart';
import 'package:dating_app/logic/repositories/profileDetailsRepo.dart';
import 'package:dating_app/logic/repositories/userActivityRepo.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

//Recieve messages when app is terminated and in background.
Future<void> backgroundMessageRecieveHandler(RemoteMessage message) async {
  // LocalNotificationService.display(message);
}
late BuildContext myContext;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _enableCatcheDatabase();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageRecieveHandler);
  SharedObjects.prefs = await CachedSharedPreference.getInstance();
  runApp(MyApp(
    firebaseAuthRepository: FirebaseAuthRepository(),
    userActivityRepository: UserActivityRepository(),
    profileDetailsRepository: ProfileDetailsRepository(),
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseAuthRepository firebaseAuthRepository;
  final UserActivityRepository userActivityRepository;
  final ProfileDetailsRepository profileDetailsRepository;
  const MyApp({
    Key? key,
    required this.firebaseAuthRepository,
    required this.userActivityRepository,
    required this.profileDetailsRepository,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DbServices db = DbServices();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FirebaseauthBloc(firebaseAuthRepo: firebaseAuthRepository),
        ),
        BlocProvider(
          create: (context) => UseractivityBloc(
            userActivityRepository: userActivityRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ProfiledetailsBloc(
            profileDetailsRepository: profileDetailsRepository,
          ),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<IsUpLoading>(
            create: (context) => IsUpLoading(),
          ),
          ChangeNotifierProvider<EmojiShowing>(
            create: (context) => EmojiShowing(),
          ),
          ChangeNotifierProvider<IsExpanded>(
            create: (context) => IsExpanded(),
          ),
          ChangeNotifierProvider<IsPlaying>(
            create: (context) => IsPlaying(),
          ),
          ChangeNotifierProvider<RecordingProvider>(
              create: (context) => RecordingProvider()),
          ChangeNotifierProvider<ChatAudioPlayer>(
              create: (context) => ChatAudioPlayer()),
        ],
        child: ScreenUtilInit(
            designSize: Size(393, 851), //Redmi Note 7
            builder: () => MaterialApp(
                  initialRoute: HomePage.routeName,
                  routes: namedRoutes,
                  title: 'Dating App',
                  theme: ThemeData(
                    primaryColor: AppColor,
                    scaffoldBackgroundColor: Colors.white,
                    textTheme: TextTheme(
                      bodyText1: TextStyle(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Modernist'),
                      bodyText2: TextStyle(
                          fontSize: 27.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Modernist'),
                      subtitle1:
                          TextStyle(fontSize: 14.sp, fontFamily: 'Modernist'),
                      subtitle2:
                          TextStyle(fontSize: 18.sp, fontFamily: 'Modernist'),
                    ),
                    colorScheme: ColorScheme.fromSwatch()
                        .copyWith(secondary: AppColor.withOpacity(0.1)),
                  ),

                  // home: ChooseSignInSignUpPage(),
                )),
      ),
    );
  }
}

void _enableCatcheDatabase() {
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true); //mobile
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
}
