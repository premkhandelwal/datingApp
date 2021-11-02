import 'dart:io';
import 'dart:ui';
import 'package:dating_app/arguments/chat_screen_arguments.dart';
import 'package:dating_app/main.dart';
import 'package:dating_app/screens/home_page/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/matchesScreen';

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  late UseractivityBloc useractivityBloc;

  @override
  void initState() {
    useractivityBloc = BlocProvider.of<UseractivityBloc>(context);
    useractivityBloc.add(FetchAllUsersEvent());
    useractivityBloc.add(FetchMatchedUsersEvent());
    super.initState();
  }

  List<CurrentUser> _matchedUsersList = [];
  List<CurrentUser> _allUsersList = [];

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
          padding: EdgeInsets.all(7.sp),
          child: ClipRRect(
            child: Container(
              height: 350.h,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 350.h,
                      width: 200.w,
                      child: imageUrl == null
                          ? Container(
                              color: Colors.amber,
                            )
                          : Image.file(
                              imageUrl,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              errorBuilder: (context, exception, stacktrace) {
                              return Container(
                                color: Colors.amber,
                                  );
                            },
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 60.sp,
                    left: 2.sp,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$personName, $personAge',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.white, fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.r),
                        bottomRight: Radius.circular(15.r),
                      ),
                      child: Container(
                        height: 50.h,
                        width: 170.w,
                        child: BackdropFilter(
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                     Navigator.pushNamed(myContext, ChatScreen.routeName,
                              arguments: ChatScreenArguments(
                                 _matchedUsersList[index].uid!,
                                  DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString()));
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                height: 50.h,
                                width: 2.w,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
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
            borderRadius: BorderRadius.circular(20.r),
          ));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0.sp),
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
                      size: Size(52.sp, 52.sp),
                      onPressed: () {}),
                ),
                SizedBox(height: 10.h),
                Text(
                  'This is a list of people who have liked you and your matches.',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: 20.h),
                BlocConsumer<UseractivityBloc, UseractivityState>(
                    listener: (context, state) {
                  if (state is FetchedMatchedUsersState) {
                    _matchedUsersList = state.users;
                    for (var i = 0; i < _matchedUsersList.length; i++) {
                      int index = _allUsersList.indexWhere((element) {
                        return element.uid == _matchedUsersList[i].uid;
                      });
                      _matchedUsersList[i].name = _allUsersList[index].name;
                      _matchedUsersList[i].age = _allUsersList[index].age;
                      _matchedUsersList[i].image = _allUsersList[index].image;
                    }
                  } else if (state is FetchedAllUsersState) {
                    _allUsersList = state.users;
                  }
                }, builder: (context, state) {
                  if (state is FetchingAllUsersState ||
                      state is FetchingMatchedUsersState ||
                      state is FetchedAllUsersState) {
                    return Container(
                        height: 350.h,
                        child: Center(child: CircularProgressIndicator()));
                  } else if ((_matchedUsersList.isNotEmpty &&
                          state is FetchedMatchedUsersState) ||
                      _matchedUsersList.isNotEmpty) {
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
                    return Container(
                        height: 350.h,
                        child: Center(child: Text("No Matched Users")));
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
