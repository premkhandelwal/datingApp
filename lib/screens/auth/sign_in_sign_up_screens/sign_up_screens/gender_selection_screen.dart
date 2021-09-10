import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/your_interest_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderSelectionScreen extends StatefulWidget {
  GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  var _selected = GENDER.NotSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                context: context,
                centerWidget: Container(),
                trailingWidget: Container(),
              ),
              SizedBox(height: 20),
              Text('I am a '),
              Spacer(),
              Column(
                children: [
                  GenderSelectionTile(
                    tileText: 'Man',
                    isThisTile: _selected == GENDER.male ? true : false,
                    onPress: () {
                      setState(() {
                        _selected = GENDER.male;
                      });
                    },
                  ),
                  GenderSelectionTile(
                    tileText: 'Woman',
                    isThisTile: _selected == GENDER.female ? true : false,
                    onPress: () {
                      setState(() {
                        _selected = GENDER.female;
                      });
                    },
                  ),
                  GenderSelectionTile(
                    tileText: 'Other',
                    isThisTile: _selected == GENDER.other ? true : false,
                    onPress: () {
                      setState(() {
                        _selected = GENDER.other;
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
                            content: Text('Please select your gender'),
                            backgroundColor: AppColor,
                          ));
                        }
                      : () {
                          context
                              .read<ProfiledetailsBloc>()
                              .add(AddGenderInfoEvent(
                                  user: CurrentUser(
                                uid: "User1",
                                gender: _selected,
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

class GenderSelectionTile extends StatelessWidget {
  final VoidCallback onPress;
  final bool isThisTile;
  final String tileText;
  const GenderSelectionTile({
    Key? key,
    required this.onPress,
    required this.isThisTile,
    required this.tileText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: !isThisTile ? Colors.grey : Colors.grey.withOpacity(0)),
          color: AppColor.withOpacity(isThisTile ? 1 : 0),
          borderRadius: BorderRadius.circular(15)),
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
