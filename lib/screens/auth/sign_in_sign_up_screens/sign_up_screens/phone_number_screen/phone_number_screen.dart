import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/sign_in_sign_up_screens/sign_up_screens/phone_number_screen/otp_verification_screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneNumberPage extends StatefulWidget {
  final String authSide;

  const PhoneNumberPage({Key? key, required this.authSide}) : super(key: key);

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  Country _selectedCountry =
      Country(isoCode: "IN", iso3Code: 'IND', phoneCode: "91", name: 'India');

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController phoneNumber = new TextEditingController();
    void codeSent(String verificationId, int? forceResendingToken) {
      /* context.read<FirebaseauthBloc>().add(UserStateNone());
      phoneNumber.clear(); */
      changePageTo(
          context: context,
          widget: OTPVerificationPage(
            issignUpWithEmail: false,
            verificationId: verificationId,
            authSide: widget.authSide,
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomAppBar(
                  context: context,
                  centerWidget: Container(),
                  trailingWidget: Container(),
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
                    'Please enter your valid phone number. We will send you a 6-digit code to verify your account.',
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
                    }else if(state is OtpRetrievalTimedOut){
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Error"),
                          content: Text("Otp retrieval timed out"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: Text("Ok"))
                          ],
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is OtpSent) {
                      return CircularProgressIndicator();
                    } 
                    return CommonButton(
                        text: 'Continue',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<FirebaseauthBloc>()
                                .add(OtpSendRequested(
                                  codeAutoRetrievalTimeout: (id) {
                                    context
                                        .read<FirebaseauthBloc>()
                                        .add(OtpRetrievalTimeOut());
                                  },
                                  verificationFailed: (exception) {
                                    context.read<FirebaseauthBloc>().add(
                                        OtpRetrievalFailure(
                                            errorMessage: exception.code));
                                    //throw Exception(exception);
                                  },
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
