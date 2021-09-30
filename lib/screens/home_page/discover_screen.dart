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
  @override
  void initState() {
    filteredUsers = [];
    context.read<UseractivityBloc>().add(FetchInfoEvent());
    super.initState();
  }

  List<CurrentUser> filteredUsers = [];
  List<CurrentUser> allUsers = [];
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final GlobalKey<_DiscoverScreenState> key1 = GlobalKey();

    List<Widget> cards(List<CurrentUser> listUsers) {
      return List.generate(
        listUsers.length,
        (int index) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(20),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Flexible(
                child: CustomAppBar(
                  context: context,
                  canGoBack: false,
                  centerWidget: Container(
                    height: 50,
                    child: Column(
                      children: [
                        Text(
                          'Discover',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          'Chicago, II',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                  trailingWidget: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.filter_alt,
                          color: AppColor,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              enableDrag: true,
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.white.withOpacity(0),
                              builder: (ctx) => FilterModalBottomSheet());
                        },
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.logout_outlined,
                            color: AppColor,
                          ),
                          onPressed: () {
                            context
                                .read<FirebaseauthBloc>()
                                .add(SignOutRequested());

                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              changePageWithoutBack(
                                  context: context,
                                  widget: ChooseSignInSignUpPage());
                            });
                          }),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(children: <Widget>[
                  BlocConsumer<UseractivityBloc, UseractivityState>(
                      listener: (context, state) {
                    if (state is UserMatchFoundState) {
                      itIsAMatchPopUp(
                          context, state.user.image!, state.user.name!);
                      context
                          .read<UseractivityBloc>()
                          .add(UserStateNoneEvent());
                    } else if (state is FetchedAllUsersState) {
                      allUsers = List.from(state.users);
                    } else if (state is FetchedInfoState) {
                      context
                          .read<UseractivityBloc>()
                          .add(FetchLocationInfoEvent());
                    } else if (state is FetchedLocationInfoState) {
                      context.read<UseractivityBloc>().add(
                          UpdateLocationInfoEvent(
                              locationCoordinates: state.locationInfo));
                    } else if (state is UpdatedLocInfoState) {
                      context
                          .read<UseractivityBloc>()
                          .add(FetchAllUsersWithAppliedFiltersEvent());
                    } else if (state is AppliedFiltersState) {
                      if (filteredUsers == []) {
                        filteredUsers = new List.from(allUsers);
                      }
                      setState(() {});
                      allUsers = List.from(state.usersList);
                    }
                  }, builder: (context, state) {
                    print(state);
                    if (state is FailedToFetchAllUsersState) {
                      return Container(
                          width: 450,
                          height: 500,
                          child: Center(child: Text("Failed to fetch users")));
                    } else if (state is FetchingAllUsersState ||
                        state is FetchingInfoState ||
                        state is UpdatingLocationInfoState ||
                        state is ApplyingFilters) {
                      return Container(
                        width: 450,
                        height: 500,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (allUsers.isEmpty ||
                        (state is AppliedFiltersState && allUsers.isEmpty)) {
                      return Container(
                          width: 450,
                          height: 500,
                          child: Center(child: Text("No users found")));
                    }
                    return Column(
                      children: [
                        TCard(
                          size: Size(450, screenHeight * 0.6),
                          slideSpeed: 10,
                          cards: cards(
                              /* state is AppliedFiltersState
                                    ? filteredUsers
                                    :  */
                              allUsers),
                          controller: _controller,
                          onForward: (index, info) async {
                            if (info.direction == SwipDirection.Right) {
                              context
                                  .read<UseractivityBloc>()
                                  .add(UserLikedEvent(allUsers[_index].uid!));
                              context.read<UseractivityBloc>().add(
                                  UserFindMatchEvent(allUsers[_index].uid!));
                            } else if (info.direction == SwipDirection.Left) {
                              context.read<UseractivityBloc>().add(
                                  UserDislikedEvent(allUsers[_index].uid!));
                            }
                            _index = index;
                            print(info.direction);
                            // setState(() {});
                          },
                          onBack: (index, info) {
                            _index = index;
                            // setState(() {});
                          },
                          onEnd: () {
                            print('end');
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  swipeLeft();
                                },
                                iconSize: 30,
                                color: Color(0xffF27121),
                                icon: Icon(Icons.close)),
                            CircleAvatar(
                              backgroundColor: AppColor,
                              radius: screenHeight * 0.045,
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      swipeRight();
                                      print('hi');
                                    },
                                    iconSize: screenHeight * 0.05,
                                    color: Colors.white,
                                    icon: Icon(Icons.favorite)),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  _controller.back();
                                },
                                iconSize: 30,
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
