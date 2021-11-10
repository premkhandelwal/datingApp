import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:dating_app/arguments/otp_verification_arguments.dart';
import 'package:dating_app/arguments/phone_number_arguments.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/otp_verification_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({Key? key}) : super(key: key);

  static const routeName = '/phoneNumberPage';

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  Country _selectedCountry =
      Country(isoCode: "IN", iso3Code: 'IND', phoneCode: "91", name: 'India');

  final _formKey = GlobalKey<FormState>();
  late FirebaseauthBloc firebaseauthBloc;

  @override
  void initState() {
    firebaseauthBloc = BlocProvider.of<FirebaseauthBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PhoneNumberArguments;
    TextEditingController phoneNumber = new TextEditingController();
    int? _resendToken;
    void codeSent(String verificationId, int? forceResendingToken) {
      /* context.read<FirebaseauthBloc>().add(UserStateNone());
      phoneNumber.clear(); */
      _resendToken = forceResendingToken;
      changePageWithNamedRoutes(
          context: context,
          routeName: OTPVerificationPage.routeName,
          arguments: OtpVerificationArguments(
              authSide: args.authSide,
              verificationId: verificationId,
              issignUpWithEmail: false));
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

    return Form(
      key: _formKey,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0.sp),
            child: Column(
              children: [
                CustomAppBar(
                  context: context,
                  centerWidget: Container(),
                  trailingWidget: Container(),
                ),
                SizedBox(height: 40.h),
                Row(
                  children: [
                    Text(
                      'My Mobile',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 40.0.sp),
                  child: Text(
                    'Please enter your valid phone number. We will send you a 6-digit code to verify your account.',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(height: 40.h),
                Container(
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.w),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    children: <Widget>[
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
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
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
                    if (state is OtpRetrievalFailed) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text("${state.errorMessage}"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Ok"))
                          ],
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is OtpSent) {
                      return const CircularProgressIndicator();
                    }
                    if (state is OtpRetrievalTimedOut) {
                      phoneNumber.text = phoneNumber.text;
                    }
                    return CommonButton(
                        text: state is OtpRetrievalTimedOut
                            ? 'Resend OTP'
                            : 'Continue',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            firebaseauthBloc.add(OtpSendRequested(
                              codeAutoRetrievalTimeout: (id) {
                                print("Timed out");
                                if (mounted) {
                                  firebaseauthBloc.add(OtpRetrievalTimeOut());
                                }
                              },
                              verificationFailed: (exception) {
                                firebaseauthBloc.add(OtpRetrievalFailure(
                                    errorMessage: exception.code));
                                //throw Exception(exception);
                              },
                              resendToken: _resendToken,
                              codeSent: codeSent,
                              phoneNumber:
                                  "+${_selectedCountry.phoneCode + phoneNumber.text}",
                            ));
                          }
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
