import 'dart:math';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/screens/home_page/widget/edit_profile_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Random random = Random();
  CurrentUser _currentUser = CurrentUser();
  late ProfiledetailsBloc profiledetailsBloc;

  @override
  void initState() {
    super.initState();
    profiledetailsBloc = BlocProvider.of<ProfiledetailsBloc>(context);
    if (SessionConstants.sessionUser != CurrentUser()) {
      profiledetailsBloc.add(FetchLocInfoEvent());
    }
    _currentUser = SessionConstants.sessionUser;
  }

  bool isBottom = false;
  bool isScrolling = false;
  bool showMoreBio = true;
  bool showMoreInterests = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfiledetailsBloc, ProfiledetailsState>(
        /* listenWhen: (previousState, currentState) {
          if (currentState is UpdatedInfoState) {
            return true;
          }
          return false;
        }, */
        listener: (context, state) async {
          if (state is UpdatedInfoState) {
            _currentUser.bio = state.currentUser.bio;
            _currentUser = state.currentUser;
            if (_currentUser.locationCoordinates != null) {
              _currentUser.location =
                  await coordinatestoLoc(_currentUser.locationCoordinates!);
            }
          } else if (state is ShowMoreState) {
            showMoreBio = state.isBio;
            showMoreInterests = state.isInterests;
          } else if (state is FetchedUserInfoState) {
            _currentUser = state.currentUser;
          }
        },
        builder: (context, state) {
          /*  if (state is InfoState) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.pink,
            ));
          } */

          final userActivitystate = context.watch<UseractivityBloc>().state;

          if (userActivitystate is FetchingAllUsersState ||
              userActivitystate is FetchingInfoState ||
              userActivitystate is ApplyingFilters ||
              state is UpdatingInfoState ||
              state is FetchingUserInfoState ||
              state is FetchingUserLocInfoState) {
            return Center(child: CircularProgressIndicator());
          } else if (userActivitystate is FetchedInfoState ||
              userActivitystate is FetchedAllUserswithFiltersState ||
              userActivitystate is UpdatedLocInfoState ||
              state is AppliedFiltersState) {
            _currentUser = SessionConstants.sessionUser;
          } else if (state is UpdatedInfoState) {
            _currentUser = state.currentUser;
          }
          return SafeArea(
            child: Container(
              child: Stack(
                children: [
                  Container(
                    height: 500.h,
                    width: double.infinity,
                    child: _currentUser.image != null &&
                            isImage(_currentUser.image!.path)
                        ? Image.file(
                            _currentUser.image!,
                            errorBuilder: (context, exception, stacktrace) {
                              return Center(
                                  child: Text("Failed to load image"));
                            },
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          )
                        : Container(
                            color: Colors.amber,
                          ),
                  ),
                  Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(height: 380.h),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.sp, vertical: 20.sp),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.r),
                                    topRight: Radius.circular(25.r),
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 40.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              '${_currentUser.name != null ? _currentUser.name : ""}, ${_currentUser.age != null ? _currentUser.age : ""}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!),
                                          Text(
                                              '${_currentUser.profession != null ? _currentUser.profession : ""}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!),
                                        ],
                                      ),
                                      IconsOutlinedButton(
                                        onPressed: () {},
                                        iconSize: 30.sp,
                                        size: Size(20.sp, 60.sp),
                                        icon: Icons.near_me,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 30.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Location',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!),
                                          if (_currentUser.location != null)
                                            Text(_currentUser.location!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!),
                                        ],
                                      ),
                                      Container(
                                        height: 40.h,
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                            color: AppColor.withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(10.r)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                                size: 15.sp,
                                              ),
                                            ),
                                            Text(
                                              '1 KM',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.h),
                                  Text(
                                    'Bio',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  Text(
                                    '${_currentUser.bio != null ? _currentUser.bio!.length > 150 && showMoreBio ? _currentUser.bio!.substring(0, 150) + "..." : _currentUser.bio : ""}',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  _currentUser.bio != null
                                      ? SizedBox(height: 10.h)
                                      : Container(),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        profiledetailsBloc.add(ShowMore(
                                            isBio: !showMoreBio,
                                            isInterests: showMoreInterests));
                                      },
                                      child: Text(
                                        _currentUser.bio != null &&
                                                _currentUser.bio!.length > 150
                                            ? showMoreBio
                                                ? "Show More"
                                                : "Show less"
                                            : "",
                                        style: TextStyle(
                                            fontSize: 12.sp, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  _currentUser.bio != null
                                      ? SizedBox(height: 30.h)
                                      : Container(),
                                  Text(
                                    'Interests',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  _currentUser.interests != null
                                      ? Container(
                                          height:
                                              showMoreInterests ? 50.h : null,
                                          child: GridView.builder(
                                            physics:
                                                new NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                _currentUser.interests?.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    childAspectRatio: 2),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Text(
                                                "${_currentUser.interests![index]}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                                textAlign: TextAlign.center,
                                              );
                                            },
                                          ),
                                        )
                                      : Container(),
                                  if (_currentUser.interests != null &&
                                      _currentUser.interests!.length > 3)
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          profiledetailsBloc.add(ShowMore(
                                                  isBio: showMoreBio,
                                                  isInterests:
                                                      !showMoreInterests));
                                        },
                                        child: Text(
                                          showMoreInterests
                                              ? "Show More"
                                              : "Show less",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 30.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Gallery',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      Text(
                                        'See all',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                                color: AppColor,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.h),
                                  Container(
                                    height: 400.h,
                                    child: GridView.builder(
                                      itemCount: sampleImages.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 2,
                                              crossAxisSpacing: 5,
                                              childAspectRatio: 1),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            child: Image.asset(
                                              sampleImages[index],
                                              fit: BoxFit.fitWidth,
                                              alignment: Alignment.topCenter,
                                            ));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -25.sp,
                              left: MediaQuery.of(context).size.width / 2.5.sp,
                              child: CircleAvatar(
                                backgroundColor: AppColor,
                                radius: 35.r,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            clipBehavior: Clip.none,
                                            enableDrag: true,
                                            isScrollControlled: true,
                                            context: context,
                                            backgroundColor:
                                                Colors.white.withOpacity(0),
                                            builder: (ctx) => EditProfileScreen(
                                                  user: _currentUser,
                                                ));
                                      },
                                      iconSize: 25.sp,
                                      color: Colors.white,
                                      icon: Icon(Icons.edit)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   top: 10,
                  //   left: 10,
                  //   child,
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
