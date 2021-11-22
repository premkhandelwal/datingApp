import 'dart:io';
import 'dart:math';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/screens/home_page/widget/edit_profile_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const routeName = '/profileScreen';


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
    if (SessionConstants.sessionUser.locationCoordinates == null) {
      //Location Coordinates will not be null if they are already fetched in the discover screen
      profiledetailsBloc.add(FetchLocInfoEvent());
    } else if (SessionConstants.sessionUser == CurrentUser()) {
      // If fetching of personal info is done in the discover screen, then this function will not be called
      profiledetailsBloc.add(FetchUserInfoEvent(
          locationCoordinates:
              SessionConstants.sessionUser.locationCoordinates!));
    }
    _currentUser = SessionConstants.sessionUser;
  }

  bool isBottom = false;
  bool isScrolling = false;
  bool showMoreBio = true;
  bool showMoreInterests = true;

  Future<File?> _addImage() async {
    List<File> _pickedImages = [];
      final picker = await MultiImagePicker.pickImages(
        maxImages: SessionConstants.sessionUser.images != null
            ? 10 - SessionConstants.sessionUser.images!.length
            : 10,
        enableCamera: true,
      );

      for (var i = 0; i < picker.length; i++) {
        _pickedImages.add(await assetToFile(picker[i]));
      }

      profiledetailsBloc.add(AddUserImages(images: _pickedImages));
  }

  final ScrollController _controller = ScrollController();

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
          } else if (state is AddedUserImages) {
            _currentUser = SessionConstants.sessionUser;
          } else if (state is FailedtoAddUserImages) {
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: const Text('Error'),
                      content: Text(state.exceptionMessage.toString()),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            child: const Text('Ok')),
                      ],
                    ));
          }
        },
        builder: (context, state) {
          if (state is FetchingUserInfoState ||
              state is FetchingUserLocInfoState) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  height: 500.h,
                  width: double.infinity,
                  child: _currentUser.image != null &&
                          isImage(_currentUser.image!.path)
                      ? Image.file(
                          _currentUser.image!,
                          errorBuilder: (context, exception, stacktrace) {
                            return Container(
                              color: Colors.amber,
                            );
                          },
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                        )
                      : Container(
                          color: Colors.amber,
                        ),
                ),
                ListView(
                  shrinkWrap: true,
                  controller: _controller,
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
                                          '${_currentUser.name ?? ""}, ${_currentUser.age ?? ""}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!),
                                      Text(
                                          _currentUser.profession ?? "",
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
                                        color: appColor.withOpacity(0.9),
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
                                  ? SizedBox(
                                      height:
                                          showMoreInterests ? 50.h : null,
                                      child: GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            _currentUser.interests?.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                childAspectRatio: 2),
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          return Text(
                                            _currentUser.interests![index],
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
                                          isInterests: !showMoreInterests));
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
                              Text(
                                'Gallery',
                                style:
                                    Theme.of(context).textTheme.bodyText2,
                              ),
                              SizedBox(height: 30.h),
                              BlocBuilder<ProfiledetailsBloc,
                                  ProfiledetailsState>(
                                builder: (context, state) {
                                  if (state is AddingUserImages) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return Container(
                                    child: _currentUser.images == null
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("No Images Available"),
                                              const Spacer(),
                                              IconButton(
                                                icon: const Icon(Icons.add,
                                                    size: 25),
                                                onPressed: _addImage,
                                              )
                                            ],
                                          )
                                        : GridView.builder(
                                            itemCount: _currentUser
                                                        .images!.length <
                                                    10
                                                ? _currentUser
                                                        .images!.length +
                                                    1 // +1 is for the "Add More" tile
                                                : _currentUser
                                                    .images!.length,
                                            controller: _controller,
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 2,
                                                    crossAxisSpacing: 5,
                                                    childAspectRatio: 1),
                                            itemBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return InkWell(
                                                onTap: () => imagePopUp(
                                                  context: context,
                                                  image: _currentUser
                                                      .images![index],
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(15.r),
                                                    child: _currentUser
                                                                    .images!
                                                                    .length <
                                                                10 &&
                                                            index ==
                                                                _currentUser
                                                                    .images!
                                                                    .length
                                                        ? GestureDetector(
                                                            onTap:
                                                                _addImage,
                                                            child:
                                                                Container(
                                                              color: Colors
                                                                  .grey,
                                                              child: const Icon(
                                                                Icons.add,
                                                                size: 40,
                                                              ),
                                                            ),
                                                          )
                                                        : Image.file(//Add More Tile
                                                            _currentUser
                                                                    .images![
                                                                index],
                                                            fit: BoxFit
                                                                .cover,
                                                            alignment:
                                                                Alignment
                                                                    .topCenter,
                                                            errorBuilder:
                                                                (context,
                                                                    exception,
                                                                    stacktrace) {
                                                              return Container(
                                                                color: Colors
                                                                    .amber,
                                                              );
                                                            },
                                                          )),
                                              );
                                            },
                                          ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -25.sp,
                          left: MediaQuery.of(context).size.width / 2.5.sp,
                          child: CircleAvatar(
                            backgroundColor: appColor,
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
                                  icon: const Icon(Icons.edit)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Positioned(
                //   top: 10,
                //   left: 10,
                //   child,
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
