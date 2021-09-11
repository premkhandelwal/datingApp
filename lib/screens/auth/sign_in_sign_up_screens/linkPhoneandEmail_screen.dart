import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/otp_verification_screen.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/profile_detail_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LinkPhoneEmailScreen extends StatefulWidget {
  final String connectWith;
  LinkPhoneEmailScreen({Key? key, required this.connectWith}) : super(key: key);

  @override
  _LinkPhoneEmailScreenState createState() => _LinkPhoneEmailScreenState();
}

class _LinkPhoneEmailScreenState extends State<LinkPhoneEmailScreen> {
  final TextEditingController emailIdController = new TextEditingController();

  final TextEditingController passwordController = new TextEditingController();

  final TextEditingController phoneNumber = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                width: 5.0,
              ),
              Text("+${country.phoneCode}(${country.isoCode})"),
            ],
          ),
        );

    return Form(
      key: _formKey,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomAppBar(
                      context: context,
                      centerWidget: Container(),
                      trailingWidget: Container(),
                    ),
                    GestureDetector(
                        onTap: () {
                          changePageTo(context: context, widget: ProfileDetailPage());
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Modernist',
                              color: Colors.red),
                        ))
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "What's your ${widget.connectWith}?",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Don't lose access to your account. connect it with ${widget.connectWith}",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                SizedBox(
                  height: 25,
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
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontFamily: 'Modernist', fontSize: 20),
                              counterText: '',
                              hintText: "Email ID",
                            ),
                          ),
                          SizedBox(
                            height: 25,
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
                                  fontFamily: 'Modernist', fontSize: 20),
                              counterText: '',
                              hintText: "Password",
                            ),
                          ),
                        ],
                      )
                    : Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(15),
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
                                  print("${country.isoCode}");
                                  print("${country.iso3Code}");
                                  print("${country.phoneCode}");
                                  print("${country.name}");
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
                                      fontFamily: 'Modernist', fontSize: 20),
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
                                  "Failed to link email-id and phone number",
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
                    } else {
                      changePageWithoutBack(
                          context: context, widget: ProfileDetailPage());
                    }
                  },
                  listenWhen: (previousState, currentState) {
                    if ((currentState is LinkedEmailWithPhoneNumber &&
                            previousState is OperationInProgress) ||
                        currentState is OtpVerified ||
                        currentState is FailedtoLinkedPhoneNumberEmail) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    print(state);
                    if (state is OtpSent || state is OperationInProgress) {
                      return CircularProgressIndicator();
                    }
                    return CommonButton(
                        text: 'Continue',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<FirebaseauthBloc>().add(
                                widget.connectWith == "email"
                                    ? LinkEmailWithPhoneNumberEvent(
                                        emailId: emailIdController.text,
                                        password: passwordController.text)
                                    : OtpSendRequested(
                                        codeAutoRetrievalTimeout: (id) {
                                          context
                                              .read<FirebaseauthBloc>()
                                              .add(OtpRetrievalTimeOut());
                                        },
                                        verificationFailed: (exception) {
                                          context.read<FirebaseauthBloc>().add(
                                              OtpRetrievalFailure(
                                                  errorMessage:
                                                      exception.code));
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
    );
  }
}
