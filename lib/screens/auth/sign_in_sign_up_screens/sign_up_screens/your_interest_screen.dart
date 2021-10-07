import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/screens/search_friends_screen/search_friends_Screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YourInterestScreen extends StatefulWidget {
  YourInterestScreen({Key? key}) : super(key: key);

  @override
  _YourInterestScreenState createState() => _YourInterestScreenState();
}

class _YourInterestScreenState extends State<YourInterestScreen> {
  List<String> _selectedInterests = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(20.0.sp),
          child: Column(
            children: [
              CustomAppBar(
                centerWidget: Container(),
                trailingWidget: Container(),
                context: context,
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Text(
                    'Your interests',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                'Select a few of your interests and let everyone know what you’re passionate bio.',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1,
                      childAspectRatio: 3 / 1),
                  itemCount: interests.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding:  EdgeInsets.all(2.0.sp),
                      child: ChoiceChip(
                          avatar: Icon(
                            iconsList[index],
                            color: _selectedInterests.contains(interests[index])
                                ? Colors.white
                                : AppColor,
                          ),
                          backgroundColor: Colors.white,
                          label: Row(children: [
                            Text(interests[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: _selectedInterests
                                                .contains(interests[index])
                                            ? Colors.white
                                            : Colors.black)),
                          ]),
                          pressElevation: 8.sp,
                          elevation:
                              _selectedInterests.contains(interests[index])
                                  ? 5.sp
                                  : 0,
                          labelPadding:
                               EdgeInsets.symmetric(vertical: 8.0.sp),
                          selectedColor: AppColor,
                          selected:
                              _selectedInterests.contains(interests[index]),
                          onSelected: (selected) {
                            _selectedInterests.contains(interests[index])
                                ? _selectedInterests.remove(interests[index])
                                : _selectedInterests.add(interests[index]);
                            setState(() {});
                          }),
                    );
                  },
                ),
              ),
              BlocConsumer<ProfiledetailsBloc, ProfiledetailsState>(
                listener: (context, state) {
                  if (state is FailedtoAddInfoState) {
                    SharedObjects.prefs
                        ?.setString(SessionConstants.sessionSignedInWith, "");
                    SharedObjects.prefs
                        ?.setString(SessionConstants.sessionUid, "");
                    
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text("Error"),
                              content: Text(
                                "Failed to add your information",
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                    },
                                    child: Text("Ok"))
                              ],
                            ));
                  } else if (state is SubmittedInfoState) {
                    changePageTo(
                        context: context, widget: SearchFriendsScreen());
                  }
                },
                builder: (context, state) {
                  if (state is AddingInfoState ||
                      state is SubmittingInfoState) {
                    return CircularProgressIndicator();
                  }
                  return CommonButton(
                      text: 'Continue',
                      onPressed: () {
                        context
                            .read<ProfiledetailsBloc>()
                            .add(AddInterestsInfoEvent(
                                user: CurrentUser(
                              interests: _selectedInterests,
                            )));
                        context
                            .read<ProfiledetailsBloc>()
                            .add(SubmitInfoEvent());
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
