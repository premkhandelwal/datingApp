import 'dart:io';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/gender_selection_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({Key? key}) : super(key: key);

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  String _date = "Choose birthday date";
  DateTime _selectedDate = DateTime.now();
  TextEditingController name = new TextEditingController();
  TextEditingController profession = new TextEditingController();
  File? _image;

  Future<File?> _addImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    return null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomAppBar(
                    centerWidget: Container(),
                    trailingWidget: Container(),
                    context: context,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Profile Details",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Stack(clipBehavior: Clip.none, children: [
                    Container(
                        width: 99,
                        height: 99,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  alignment: Alignment.topCenter,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/female_model_2.png',
                                  alignment: Alignment.topCenter,
                                  fit: BoxFit.cover,
                                ),
                        )),
                    Positioned(
                      bottom: -15,
                      right: -5,
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: AppColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: IconButton(
                          onPressed: _addImage,
                          icon: Icon(Icons.camera_alt_rounded),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val == null || val == "") {
                        return "This is a required field";
                      }
                      return null;
                    },
                    controller: name,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          gapPadding: 5,
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.black45)),
                        labelText: "Full Name",
                        labelStyle: TextStyle(color: Colors.black45)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: profession,
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
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[50],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(
                            cancelStyle: TextStyle(color: Colors.grey),
                            doneStyle: TextStyle(color: AppColor),
                            itemStyle: TextStyle(color: AppColor),
                            containerHeight: 210.0,
                          ),
                          onCancel: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Please Select Your Birth Date',
                              ),
                              duration: Duration(seconds: 1),
                              backgroundColor: AppColor,
                            ));
                          },
                          showTitleActions: true,
                          onConfirm: (date) {
                            _selectedDate = date;
                            _date = '${date.day}/${date.month}/${date.year}';
                            setState(() {});
                          },
                          currentTime: DateTime.now());
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                color: AppColor,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                " $_date",
                                style:
                                    TextStyle(color: AppColor, fontSize: 15.0),
                              )
                            ],
                          ),
                        ],
                      ),
                      color: Colors.red[50],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  CommonButton(
                    onPressed: () {
                      bool isDateNotSelected = false;
                      if (_date == "Choose birthday date") {
                        isDateNotSelected = true;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please select your birth date!")));
                      } else {
                        isDateNotSelected = false;
                      }
                      if (_formKey.currentState!.validate() &&
                          !isDateNotSelected) {
                        context.read<ProfiledetailsBloc>().add(
                            AddBasicInfoEvent(
                                user: CurrentUser(
                                    name: name.text,
                                    profession: profession.text,
                                    birthDate: _selectedDate,
                                    age: calculateAge(_selectedDate),
                                    image: _image)));
                        changePageTo(
                            context: context, widget: GenderSelectionScreen());
                      }
                    },
                    text: "Confirm",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
