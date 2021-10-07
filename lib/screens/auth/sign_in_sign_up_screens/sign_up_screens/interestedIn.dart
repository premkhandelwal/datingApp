import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/your_interest_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InterestedInScreen extends StatefulWidget {
  InterestedInScreen({Key? key}) : super(key: key);

  @override
  _InterestedInScreenState createState() => _InterestedInScreenState();
}

class _InterestedInScreenState extends State<InterestedInScreen> {
  var _selected = GENDER.NotSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(20.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                context: context,
                centerWidget: Container(),
                trailingWidget: Container(),
              ),
              SizedBox(height: 20.h),
              Text('Interested In'),
              Spacer(),
              Column(
                children: [
                  InterestedInTile(
                    tileText: 'Man',
                    isThisTile: _selected == GENDER.male ? true : false,
                    onPress: () {
                      setState(() {
                        _selected = GENDER.male;
                      });
                    },
                  ),
                  InterestedInTile(
                    tileText: 'Woman',
                    isThisTile: _selected == GENDER.female ? true : false,
                    onPress: () {
                      setState(() {
                        _selected = GENDER.female;
                      });
                    },
                  ),
                  InterestedInTile(
                    tileText: 'Both',
                    isThisTile: _selected == GENDER.both ? true : false,
                    onPress: () {
                      setState(() {
                        _selected = GENDER.both;
                      });
                    },
                  ),
                ],
              ),
              Spacer(),
              CommonButton(
                  text: 'Continue',
                  onPressed: _selected == GENDER.NotSelected
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please select interested gender'),
                            backgroundColor: AppColor,
                          ));
                        }
                      : () {
                          context
                              .read<ProfiledetailsBloc>()
                              .add(AddInterestedInInfoEvent(
                                  user: CurrentUser(
                                interestedin: _selected,
                              )));
                          changePageTo(
                              context: context, widget: YourInterestScreen());
                        })
            ],
          ),
        ),
      ),
    );
  }
}

class InterestedInTile extends StatelessWidget {
  final VoidCallback onPress;
  final bool isThisTile;
  final String tileText;
  const InterestedInTile({
    Key? key,
    required this.onPress,
    required this.isThisTile,
    required this.tileText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.sp),
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
          border: Border.all(
              width: 2.w,
              color: !isThisTile ? Colors.grey : Colors.grey.withOpacity(0.sp)),
          color: AppColor.withOpacity(isThisTile ? 1.sp : 0),
          borderRadius: BorderRadius.circular(15.r)),
      child: InkWell(
        onTap: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tileText,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: isThisTile ? Colors.white : Colors.black),
            ),
            Icon(Icons.check, color: isThisTile ? Colors.white : Colors.grey)
          ],
        ),
      ),
    );
  }
}
