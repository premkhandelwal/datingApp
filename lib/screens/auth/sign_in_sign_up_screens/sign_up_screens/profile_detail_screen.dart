import 'dart:io';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/repositories/firebase_auth_repo.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/gender_selection_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({Key? key}) : super(key: key);
  static const routeName = '/profileDetailPage';

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  String _date = "Choose birthday date";
  DateTime _selectedDate = DateTime.now();
  TextEditingController name = TextEditingController();
  TextEditingController profession = TextEditingController();
  File? _image;
  late ProfiledetailsBloc profiledetailsBloc;

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
  void initState() {
    profiledetailsBloc = BlocProvider.of<ProfiledetailsBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Confirm'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuthRepository().signOut();
                          Navigator.pop(ctx);
                          changePagewithoutBackWithNamedRoutes(
                              context: context,
                              routeName: ChooseSignInSignUpPage.routeName);
                        },
                        child: const Text('Yes')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text('No')),
                  ],
                ));

        return true;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 20.sp),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomAppBar(
                      canGoBack: false,
                      centerWidget: Container(),
                      trailingWidget: Container(),
                      context: context,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Profile Details",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Stack(clipBehavior: Clip.none, children: [
                      Container(
                          width: 99.w,
                          height: 99.h,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0.r),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.0.r),
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    alignment: Alignment.topCenter,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, exception, stacktrace) {
                                      return Container(
                                        color: Colors.amber,
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.amber,
                                  ),
                          )),
                      Positioned(
                        bottom: -15,
                        right: -5,
                        child: Container(
                          height: 50.h,
                          width: 50.w,
                          padding: EdgeInsets.all(5.sp),
                          decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(15.0.r),
                              border:
                                  Border.all(color: Colors.white, width: 2.w)),
                          child: IconButton(
                            onPressed: _addImage,
                            icon: const Icon(Icons.camera_alt_rounded),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 50.h,
                    ),
                    TextFormField(
                      //Full Name (Compulsory field)
                      validator: (val) {
                        if (val == null || val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      controller: name,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            gapPadding: 5.sp,
                            borderSide: const BorderSide(color: Colors.black45),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: const BorderSide(color: Colors.black45)),
                          labelText: "Full Name",
                          labelStyle: const TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      //Profession (Optional field)
                      controller: profession,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            gapPadding: 5.sp,
                            borderSide: const BorderSide(color: Colors.black45),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: const BorderSide(color: Colors.black45)),
                          labelText: "Profession",
                          labelStyle: const TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      /* Birth Date (Compulsory Field): User must be greater than 18 years, otherwise he/she will not be able to use the app. 
                         We are checking the same when user submits the form */
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[50],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r)),
                      ),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(
                              backgroundColor: Colors.white,
                              cancelStyle: const TextStyle(color: Colors.grey),
                              doneStyle: const TextStyle(color: appColor),
                              itemStyle: const TextStyle(color: appColor),
                              containerHeight: 210.0.h,
                            ),
                            onCancel: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  'Please Select Your Birth Date',
                                ),
                                duration: Duration(seconds: 1),
                                backgroundColor: appColor,
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
                        height: 50.0.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.calendar_today,
                                  color: appColor,
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                Text(
                                  " $_date",
                                  style: TextStyle(
                                      color: appColor, fontSize: 15.0.sp),
                                )
                              ],
                            ),
                          ],
                        ),
                        color: Colors.red[50],
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    CommonButton(
                      onPressed: () {
                        bool isDateNotSelected = false;
                        if (_date == "Choose birthday date") {
                          isDateNotSelected = true;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Please select your birth date!")));
                        } else {
                          isDateNotSelected = false;
                        }
                        if (_formKey.currentState!.validate() &&
                            !isDateNotSelected) {
                          num age = calculateAge(_selectedDate);
                          if (age < 18) {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Sorry, you cannot sign up into the app. Minimum age to use the app is 18 years.'),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                            },
                                            child: const Text('Ok')),
                                      ],
                                    ));
                          } else {
                            profiledetailsBloc.add(AddBasicInfoEvent(
                                user: CurrentUser(
                                    name: name.text,
                                    profession: profession.text,
                                    birthDate: _selectedDate,
                                    age: age,
                                    image: _image)));
                            changePageWithNamedRoutes(
                              context: context,
                              routeName: GenderSelectionScreen.routeName,
                            );
                          }
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
      ),
    );
  }
}
