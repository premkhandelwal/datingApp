import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/logic/repositories/firebaseAuthRepo.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/otp_verification_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LinkPhoneEmailScreen extends StatefulWidget {
  final String connectWith;
  LinkPhoneEmailScreen({Key? key, required this.connectWith}) : super(key: key);

  @override
  _LinkPhoneEmailScreenState createState() => _LinkPhoneEmailScreenState();
}

class _LinkPhoneEmailScreenState extends State<LinkPhoneEmailScreen> {
  late FirebaseauthBloc firebaseauthBloc;
  final TextEditingController emailIdController = new TextEditingController();

  final TextEditingController passwordController = new TextEditingController();

  final TextEditingController phoneNumber = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    firebaseauthBloc = BlocProvider.of<FirebaseauthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Country _selectedCountry =
        Country(isoCode: "IN", iso3Code: 'IND', phoneCode: "91", name: 'India');
    void codeSent(String verificationId, int? forceResendingToken) {
      /* context.read<FirebaseauthBloc>().add(UserStateNone());
      phoneNumber.clear(); */
      changePageTo(
          context: context,
          widget: OTPVerificationPage(
            issignUpWithEmail: true,
            verificationId: verificationId,
            authSide: "Sign Up",
          ));
    }

    Widget _buildDropdownItem(Country country) => Container(
          child: Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(
                width: 5.0.w,
              ),
              Text("+${country.phoneCode}(${country.isoCode})"),
            ],
          ),
        );

    return WillPopScope(
      onWillPop: () async {
        await FirebaseAuthRepository().signOut();
        changePageWithoutBack(
            context: context, widget: ChooseSignInSignUpPage());
        return true;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomAppBar(
                        context: context,
                        canGoBack: false,
                        centerWidget: Container(),
                        trailingWidget: Container(),
                      ),
                      GestureDetector(
                          onTap: () {
                            changePageTo(
                                context: context, widget: ProfileDetailPage());
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: 'Modernist',
                                color: Colors.red),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "What's your ${widget.connectWith}?",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Don't lose access to your account. connect it with ${widget.connectWith}",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  widget.connectWith == "email"
                      ? Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                if (val == null) {
                                  return "Email ID cannot be empty";
                                } else if (!EmailValidator.validate(val)) {
                                  return "Invalid email-id";
                                }
                                return null;
                              },
                              controller: emailIdController,
                              keyboardType: widget.connectWith == "phone"
                                  ? TextInputType.phone
                                  : TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontFamily: 'Modernist', fontSize: 20),
                                counterText: '',
                                hintText: "Email ID",
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            TextFormField(
                              validator: (val) {
                                String pattern =
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                                RegExp regex = new RegExp(pattern);
                                if (val == null) {
                                  return "Password cannot be empty";
                                } else if (!regex.hasMatch(val)) {
                                  return 'Password should contain at least 8 characters, at least one uppercase letter, at least one lowercase letter, at least one digit and at least one special character';
                                }
                                return null;
                              },
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontFamily: 'Modernist', fontSize: 20.sp),
                                counterText: '',
                                hintText: "Password",
                              ),
                            ),
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.all(10.sp),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.w),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: CountryPickerDropdown(
                                  initialValue: "IN",
                                  isDense: true,
                                  isExpanded: false,
                                  priorityList: [
                                    Country(
                                        isoCode: 'IN',
                                        iso3Code: 'IND',
                                        phoneCode: "91",
                                        name: 'India'),
                                    Country(
                                        isoCode: 'US',
                                        iso3Code: 'USA',
                                        phoneCode: "1",
                                        name: 'United States')
                                  ],
                                  itemBuilder: _buildDropdownItem,
                                  onValuePicked: (Country country) {
                                    setState(() {
                                      _selectedCountry = country;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val == null) {
                                      return "Phone Number cannot be empty";
                                    } else if (val.length != 10) {
                                      return 'Phone Number must be of 10 digit';
                                    }
                                  },
                                  controller: phoneNumber,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontFamily: 'Modernist',
                                        fontSize: 20.sp),
                                    counterText: '',
                                    hintText: "Phone Number",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  Spacer(),
                  BlocConsumer<FirebaseauthBloc, FirebaseauthState>(
                    listener: (context, state) {
                      if (state is FailedtoLinkedPhoneNumberEmail) {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(
                                    "${state.errorMessage}",
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          changePageWithoutBack(
                                              context: context,
                                              widget: ProfileDetailPage());
                                        },
                                        child: Text("Ok"))
                                  ],
                                ));
                      } else if (state is LinkedEmailWithPhoneNumber ||
                          state is LinkedPhoneNumberWithEmail) {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text("Message"),
                                  content: Text(
                                    "Successfully Linked Email and Phone Number",
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          changePageWithoutBack(
                                              context: context,
                                              widget: ProfileDetailPage());
                                        },
                                        child: Text("Ok"))
                                  ],
                                ));
                      }
                    },
                    builder: (context, state) {
                      if (state is OtpSent || state is OperationInProgress) {
                        return CircularProgressIndicator();
                      }
                      return CommonButton(
                          text: 'Continue',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              firebaseauthBloc.add(widget.connectWith == "email"
                                  ? LinkEmailWithPhoneNumberEvent(
                                      emailId: emailIdController.text,
                                      password: passwordController.text)
                                  : OtpSendRequested(
                                      codeAutoRetrievalTimeout: (id) {
                                        firebaseauthBloc
                                            .add(OtpRetrievalTimeOut());
                                      },
                                      verificationFailed: (exception) {
                                        firebaseauthBloc.add(
                                            OtpRetrievalFailure(
                                                errorMessage: exception.code));
                                        //throw Exception(exception);
                                      },
                                      codeSent: codeSent,
                                      phoneNumber:
                                          "+${_selectedCountry.phoneCode + phoneNumber.text}",
                                    ));

                              /* changePageTo(
                                            context: context, widget: ProfileDetailPage()); */
                            }
                          });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
