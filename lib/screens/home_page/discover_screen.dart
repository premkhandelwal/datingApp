import 'dart:ui';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/home_page/widget/filter_modal_bottom_sheet.dart';
import 'package:dating_app/screens/home_page/widget/its_a_match_pop_up.dart';
import 'package:dating_app/screens/home_page/widget/swipeable_card.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcard/tcard.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  void swipeLeft() {
    _controller.forward(direction: SwipDirection.Left);
  }

  Future<void> swipeRight() async {
    _controller.forward(direction: SwipDirection.Right);
  }

  TCardController _controller = TCardController();
  int _index = 0;
  late UseractivityBloc useractivityBloc;
  late FirebaseauthBloc firebaseAuthBloc;

  
  @override
  void initState() {
    filteredUsers = [];
    useractivityBloc = BlocProvider.of<UseractivityBloc>(context);
    firebaseAuthBloc = BlocProvider.of<FirebaseauthBloc>(context);
    useractivityBloc.add(FetchLocationInfoEvent());
    super.initState();
  }

  List<CurrentUser> filteredUsers = [];
  List<CurrentUser> allUsers = [];
  @override
  Widget build(BuildContext context) {
    final GlobalKey<_DiscoverScreenState> key1 = GlobalKey();

    List<Widget> cards(List<CurrentUser> listUsers) {
      listUsers.sort((user1, user2) {
        if (user1.distance != null && user2.distance != null) {
          return user1.distance!.compareTo(user2.distance!);
        }
        return 0;
      });
      return List.generate(
        listUsers.length,
        (int index) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: SwipeableCard(
                personDistance: listUsers[index].distance != null
                    ? listUsers[index].distance!
                    : null,
                personAge: age[index],
                personBio: biography[index],
                personName: listUsers[index].name != null
                    ? listUsers[index].name!
                    : name[index],
                personProfession: profession[index],
                imageUrl: listUsers[index].image != null
                    ? listUsers[index].image!
                    : null,
                swipeRight: swipeRight,
                swipeLeft: swipeLeft,
              ));
        },
      );
    }

    return Scaffold(
      key: key1,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0.sp),
          child: Column(
            children: [
              CustomAppBar(
                context: context,
                canGoBack: false,
                centerWidget: Container(
                  height: 50.h,
                  child: Column(
                    children: [
                      Text(
                        'Discover',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      BlocBuilder<UseractivityBloc, UseractivityState>(
                        buildWhen: (previousState, currentState) {
                          if (currentState is FetchedInfoState) {
                            return true;
                          }
                          return false;
                        },
                        builder: (context, state) {
                          return Text(
                            SessionConstants.sessionUser.location != null
                                ? '${SessionConstants.sessionUser.location}'
                                : "",
                            style: Theme.of(context).textTheme.subtitle1,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                trailingWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.filter_alt,
                        color: AppColor,
                      ),
                      onPressed: () {
                        UseractivityState state =
                            BlocProvider.of<UseractivityBloc>(context,
                                    listen: false)
                                .state;
                        if (state is FetchingAllUsersState ||
                            state is FetchingInfoState ||
                            state is ApplyingFilters) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Loading Data..Please wait")));
                        } else {
                          showModalBottomSheet(
                              enableDrag: true,
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.white.withOpacity(0),
                              builder: (ctx) => FilterModalBottomSheet());
                        }
                      },
                    ),
                    Flexible(
                      child: IconButton(
                          icon: Icon(
                            Icons.logout_outlined,
                            color: AppColor,
                          ),
                          onPressed: () {
                            firebaseAuthBloc.add(SignOutRequested());

                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              changePageWithoutBack(
                                  context: context,
                                  widget: ChooseSignInSignUpPage());
                            });
                          }),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(children: <Widget>[
                  BlocConsumer<UseractivityBloc, UseractivityState>(
                      listener: (context, state) {
                    if (state is UserMatchFoundState) {
                      itIsAMatchPopUp(
                          context, state.user.image!, state.user.name!);
                      useractivityBloc.add(UserStateNoneEvent());
                    } else if (state is FetchedAllUserswithFiltersState) {
                      allUsers = List.from(state.users);
                    } else if (state is AppliedFiltersState) {
                      if (filteredUsers == []) {
                        filteredUsers = new List.from(allUsers);
                      }
                      allUsers = List.from(state.usersList);
                    }
                  }, builder: (context, state) {
                    print(state);
                    if (state is FailedToFetchAllUsersState) {
                      return Container(
                          width: 450.w,
                          height: 500.h,
                          child: Center(child: Text("Failed to fetch users")));
                    } else if (state is FetchingAllUsersState ||
                        state is FetchingInfoState ||
                        state is ApplyingFilters) {
                      return Container(
                        width: 450.w,
                        height: 500.h,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (allUsers.isEmpty ||
                        (state is AppliedFiltersState && allUsers.isEmpty)) {
                      return Container(
                          width: 450.w,
                          height: 500.h,
                          child: Center(child: Text("No users found")));
                    }
                    return Column(
                      children: [
                        TCard(
                          size: Size(450.w, 0.6.sh),
                          slideSpeed: 10,
                          cards: cards(
                              /* state is AppliedFiltersState
                                    ? filteredUsers
                                    :  */
                              allUsers),
                          controller: _controller,
                          onForward: (index, info) async {
                            if (info.direction == SwipDirection.Right) {
                             useractivityBloc.add(UserLikedEvent(allUsers[_index].uid!));
                              useractivityBloc.add(
                                  UserFindMatchEvent(allUsers[_index].uid!));
                            } else if (info.direction == SwipDirection.Left) {
                              useractivityBloc.add(
                                  UserDislikedEvent(allUsers[_index].uid!));
                            }
                            _index = index;
                          },
                          onBack: (index, info) {
                            _index = index;
                          },
                          onEnd: () {},
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  swipeLeft();
                                },
                                iconSize: 30.sp,
                                color: Color(0xffF27121),
                                icon: Icon(Icons.close)),
                            CircleAvatar(
                              backgroundColor: AppColor,
                              radius: 0.045.sh,
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      swipeRight();
                                    },
                                    iconSize: 0.05.sh,
                                    color: Colors.white,
                                    icon: Icon(Icons.favorite)),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  _controller.back();
                                },
                                iconSize: 30.sp,
                                color: Color(0xffF27121),
                                icon: Icon(Icons.restore)),
                          ],
                        )
                      ],
                    );
                  }),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
