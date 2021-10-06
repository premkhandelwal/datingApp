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

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Random random = Random();
  CurrentUser _currentUser = CurrentUser();

  @override
  void initState() {
    _currentUser = SessionConstants.sessionUser;
    /* _controller.addListener(() {
      // reached bottom
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() => isBottom = true);
      }
      _controller.position.isScrollingNotifier.addListener(() {
        if (!_controller.position.isScrollingNotifier.value) {
          print('scroll is stopped');
          setState(() => isScrolling = false);
        } else {
          print('scroll is started');
          setState(() => isScrolling = true);
        }
      });

      // IS SCROLLING
//         if (_controller.offset >= _controller.position.minScrollExtent &&
//             _controller.offset < _controller.position.maxScrollExtent && !_controller.position.outOfRange) {
//           setState(() {
//             isBottom = false;
//           });
//         }

      // REACHED TOP
      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() => isBottom = false);
      }
    }); */
    super.initState();
  }

  bool isBottom = false;
  bool isScrolling = false;
  bool showMoreBio = true;
  bool showMoreInterests = true;

  ScrollController _controller = new ScrollController();
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
              userActivitystate is UpdatingLocationInfoState ||
              userActivitystate is ApplyingFilters ||
              state is UpdatingInfoState) {
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
                    height: 500,
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
                        SizedBox(height: 380),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 40),
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
                                        iconSize: 30,
                                        size: Size(20, 60),
                                        icon: Icons.near_me,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 30),
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
                                        height: 40,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color: AppColor.withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                            Text(
                                              '1 KM',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30),
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
                                  _currentUser.bio != null ? SizedBox(height: 10) : Container(),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        context.read<ProfiledetailsBloc>().add(
                                            ShowMore(
                                                isBio: !showMoreBio,
                                                isInterests:
                                                    showMoreInterests));
                                      },
                                      child: Text(
                                        _currentUser.bio != null &&
                                                _currentUser.bio!.length > 150
                                            ? showMoreBio
                                                ? "Show More"
                                                : "Show less"
                                            : "",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                 _currentUser.bio != null ?  SizedBox(height: 30) : Container(),
                                  Text(
                                    'Interests',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _currentUser.interests != null
                                      ? Container(
                                          height: showMoreInterests ? 50 : null,
                                          child: GridView.builder(
                                            controller: _controller,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
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
                                              );
                                            },
                                          ),
                                        )
                                      : Container(),
                                if(_currentUser.interests != null && _currentUser.interests!.length > 3)
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        context.read<ProfiledetailsBloc>().add(
                                            ShowMore(
                                                isBio: showMoreBio,
                                                isInterests:
                                                    !showMoreInterests));
                                      },
                                      child: Text(
                                        showMoreInterests
                                            ? "Show More"
                                            : "Show less",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
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
                                  SizedBox(height: 30),
                                  Container(
                                    height: 400,
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
                                                BorderRadius.circular(15),
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
                              top: -25,
                              left: MediaQuery.of(context).size.width / 2.5,
                              child: CircleAvatar(
                                backgroundColor: AppColor,
                                radius: 35,
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
                                      iconSize: 25,
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
