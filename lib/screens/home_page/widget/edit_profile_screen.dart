import 'package:dating_app/screens/home_page/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';

class EditProfileScreen extends StatefulWidget {
  final CurrentUser user;
  const EditProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> _selectedInterests = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  void initState() {
    _fillFields();
    super.initState();
  }

  void _fillFields() {
    if (widget.user.name != null) {
      nameController.text = widget.user.name!;
    }
    if (widget.user.profession != null) {
      professionController.text = widget.user.profession!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomAppBar(
                context: context,
                centerWidget: Text('Your Profile'),
                trailingWidget: Container()),
            Container(
              height: 420,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage(sampleImages[0]),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: AppColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            gapPadding: 5,
                            borderSide: BorderSide(color: Colors.black45),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.black45)),
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: professionController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            gapPadding: 5,
                            borderSide: BorderSide(color: Colors.black45),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.black45)),
                          labelText: "Profession",
                          labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: aboutController,
                      maxLines: 5,
                      maxLength: 399,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            gapPadding: 5,
                            borderSide: BorderSide(color: Colors.black45),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.black45)),
                          labelText: "About",
                          labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 100,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 1,
                            childAspectRatio: 3 / 1),
                        itemCount: interests.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(2.0),
                            child: ChoiceChip(
                                avatar: Icon(
                                  iconsList[index],
                                  color: _selectedInterests
                                          .contains(interests[index])
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
                                              color:
                                                  _selectedInterests.contains(
                                                          interests[index])
                                                      ? Colors.white
                                                      : Colors.black)),
                                ]),
                                pressElevation: 8,
                                elevation: _selectedInterests
                                        .contains(interests[index])
                                    ? 5
                                    : 0,
                                labelPadding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                selectedColor: AppColor,
                                selected: _selectedInterests
                                    .contains(interests[index]),
                                onSelected: (selected) {
                                  _selectedInterests.contains(interests[index])
                                      ? _selectedInterests
                                          .remove(interests[index])
                                      : _selectedInterests
                                          .add(interests[index]);
                                  setState(() {});
                                }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            BlocConsumer<ProfiledetailsBloc, ProfiledetailsState>(
              listener: (context, state) {
                if (state is UpdatedInfoState) {
                  changePageWithoutBack(context: context, widget: ProfilePage());
                }
              },
              builder: (context, state) {
                if (state is UpdatingInfoState) {
                  return CircularProgressIndicator();
                }
                return CommonButton(
                    text: 'Continue',
                    onPressed: () {
                      context.read<ProfiledetailsBloc>().add(UpdateInfoEvent(
                          user: CurrentUser(
                              name: nameController.text,
                              about: aboutController.text,
                              profession: professionController.text,
                              interests: _selectedInterests)));
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
