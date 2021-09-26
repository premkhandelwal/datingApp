import 'dart:io';
import 'dart:ui';
import 'package:dating_app/const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  @override
  void initState() {
    context.read<UseractivityBloc>().add(FetchMatchedUsersEvent());
    super.initState();
  }

  List<CurrentUser> _matchedUsersList = [];

  @override
  Widget build(BuildContext context) {
    void removeItem(int i) {
      setState(() {
        sampleImages.removeAt(i);
      });
    }

    Widget cards(int index) {
      String? personName = _matchedUsersList[index].name;
      num? personAge = _matchedUsersList[index].age;
      File? imageUrl;
      if (_matchedUsersList[index].image != null) {
        imageUrl = _matchedUsersList[index].image!;
      }
      return Container(
          padding: EdgeInsets.all(7),
          child: ClipRRect(
            child: Container(
              height: 350,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 350,
                      width: 200,
                      child: imageUrl == null
                          ? Container(
                              color: Colors.amber,
                            )
                          : Image.file(
                              imageUrl,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$personName, $personAge',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: Container(
                        height: 50,
                        width: 170,
                        child: BackdropFilter(
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    removeItem(index);
                                    print('cancel');
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 2,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    print('like');
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          filter: ImageFilter.blur(
                              sigmaX: 10.0,
                              sigmaY: 10.0,
                              tileMode: TileMode.clamp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(20),
          ));
    }

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
                          'Matches',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                  trailingWidget: IconsOutlinedButton(
                      icon: Icons.filter_list,
                      size: Size(52, 52),
                      onPressed: () {}),
                ),
                SizedBox(height: 10),
                Text(
                  'This is a list of people who have liked you and your matches.',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: 20),
                BlocConsumer<UseractivityBloc, UseractivityState>(
                    listener: (context, state) {
                  if (state is FetchedMatchedUsersState) {
                    print(state.users);
                    _matchedUsersList = state.users;
                    print(_matchedUsersList);
                    for (var i = 0; i < _matchedUsersList.length; i++) {
                      /* int index =
                          SessionConstants.allUsers.indexWhere((element) {
                        return element.uid == _matchedUsersList[i].uid;
                      });
                      _matchedUsersList[i].name =
                          SessionConstants.allUsers[index].name;
                      _matchedUsersList[i].age =
                          SessionConstants.allUsers[index].age;
                      _matchedUsersList[i].image =
                          SessionConstants.allUsers[index].image; */
                    }
                  }
                }, builder: (context, state) {
                  if (_matchedUsersList.isNotEmpty) {
                    return Expanded(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 2 / 3),
                            itemCount: _matchedUsersList.length,
                            itemBuilder: (context, index) {
                              return cards(index);
                            }),
                      ),
                    );
                  } else {
                    return Center(child: Text("No Matched Users"));
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
