import 'dart:ui';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/screens/home_page/widget/filter_modal_bottom_sheet.dart';
import 'package:dating_app/screens/home_page/widget/its_a_match_pop_up.dart';
import 'package:dating_app/screens/home_page/widget/swipeable_card.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  void swipeLeft(int index) {
    context
        .read<UseractivityBloc>()
        .add(UserDislikedEvent(name[index]));
    print("person diliked");
    print('left');
    _controller.forward(direction: SwipDirection.Left);
  }

  Future<void> swipeRight(int index) async {
    context.read<UseractivityBloc>().add(UserLikedEvent(name[index]));
    context
        .read<UseractivityBloc>()
        .add(UserFindMatchEvent(name[index]));
    print("person liked");
    _controller.forward(direction: SwipDirection.Right);
  }

  TCardController _controller = TCardController();
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> cards = List.generate(
      sampleImages.length,
      (int index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SwipeableCard(
            personAge: age[index],
            personBio: biography[index],
            personName: name[index],
            personProfession: profession[index],
            imageUrl: sampleImages[index],
            swipeRight: swipeRight,
            swipeLeft: swipeLeft,
          ),
        );
      },
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                CustomAppBar(
                  context: context,
                  canGoBack: false,
                  centerWidget: Container(
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
                  trailingWidget: IconButton(
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
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      BlocListener<UseractivityBloc, UseractivityState>(
                        listener: (context, state) {
                          if (state is UserMatchFoundState) {
                            itIsAMatchPopUp(context, _index - 1);
                          }
                        },
                        listenWhen: (previousState, currentState) {
                          if (previousState is UserLikedState &&
                              currentState is UserMatchFoundState) {
                            return true;
                          }
                          return false;
                        },
                        child: TCard(
                          size: Size(450, 500),
                          slideSpeed: 10,
                          cards: cards,
                          controller: _controller,
                          onForward: (index, info) async {
                            if (info.direction == SwipDirection.Right) {
                              context
                                  .read<UseractivityBloc>()
                                  .add(UserLikedEvent(name[_index]));
                              context.read<UseractivityBloc>().add(
                                  UserFindMatchEvent(name[_index]));
                            } else if (info.direction == SwipDirection.Left) {
                              context.read<UseractivityBloc>().add(
                                  UserDislikedEvent(name[_index]));
                            }
                            _index = index;
                            print(info.direction);
                            setState(() {});
                          },
                          onBack: (index, info) {
                            _index = index;
                            setState(() {});
                          },
                          onEnd: () {
                            print('end');
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                swipeLeft(_index);
                              },
                              iconSize: 30,
                              color: Color(0xffF27121),
                              icon: Icon(Icons.close)),
                          Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    _index = 0;
                                    _controller.reset();
                                  },
                                  child: Text('Reset Stack')),
                              TextButton(
                                  onPressed: () {
                                    _controller.back();
                                  },
                                  child: Text('1 Step Back')),
                            ],
                          ),
                          CircleAvatar(
                            backgroundColor: AppColor,
                            radius: 30,
                            child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    swipeRight(_index);
                                    print('hi');
                                  },
                                  iconSize: 40,
                                  color: Colors.white,
                                  icon: Icon(Icons.favorite)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
