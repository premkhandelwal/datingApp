import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseauth_bloc.dart';
import 'package:dating_app/screens/choose_page/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/otp_verification_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneNumberPage extends StatelessWidget {
  final String authSide;

  const PhoneNumberPage({Key? key, required this.authSide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneNumber = new TextEditingController();
    void codeSent(String verificationId, int? forceResendingToken) {
      changePageTo(
          context: context,
          widget: OTPVerificationPage(
            authSide: authSide,
            verificationId: verificationId,
          ));
    }

    return BlocBuilder<FirebaseauthBloc, FirebaseauthState>(
        builder: (context, state) {
      if (state is PhoneVerficationRequested) {
        context.read<FirebaseauthBloc>().add(
              OtpSendRequested(
                codeSent: codeSent,
                phoneNumber: phoneNumber.text,
                phoneVerificationFailed: (e) {},
              ),
            );
        return CircularProgressIndicator();
      } else if (state is PhoneNumberVerificationCompleted) {
        context.read<FirebaseauthBloc>().add(
              OtpSendRequested(
                codeSent: codeSent,
                phoneNumber: phoneNumber.text,
                phoneVerificationFailed: (e) {},
              ),
            );
        // Add event sendOtp here.
        return Container(color: Colors.amber,);
      } else {
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

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TopBarForSignUpAndSignIn(
                    context: context,
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        'My Mobile',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: Text(
                      'Please enter your valid phone number. We will send you a 4-digit code to verify your account.',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: CountryPickerDropdown(
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
                              print("${country.isoCode}");
                              print("${country.iso3Code}");
                              print("${country.phoneCode}");
                              print("${country.name}");
                            },
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: phoneNumber,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: "Phone Number",
                            ),
                            onChanged: (value) {
                              // this.phoneNo=value;
                              print(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  CommonButton(
                      text: 'Continue',
                      onPressed: () {
                        context.read<FirebaseauthBloc>().add(
                            SignInWithPhoneNumberRequested(
                                phoneNumber: phoneNumber.text));
                      }),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
