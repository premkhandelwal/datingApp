import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.textController,
      required this.labelText,
      required this.icon,
      required this.validatorIsEmpty,
      required this.validatorError,
      this.isPassword = false,
      this.isEMail = false})
      : super(key: key);

  final TextEditingController textController;
  final String labelText;
  final IconData icon;
  final String validatorIsEmpty;
  final String validatorError;
  final bool isPassword;
  final bool isEMail;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focus = FocusNode();
  double _elevation = 0;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      setState(() {
        if (_focus.hasFocus) {
          _elevation = 5;
        } else {
          _elevation = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: _elevation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
        child: TextFormField(
          obscureText: widget.isPassword,
          controller: widget.textController,
          focusNode: _focus,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
              prefixIcon: Icon(
                widget.icon,
              ),
              labelText: widget.labelText,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).cardColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Theme.of(context).cardColor))),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (!widget.isPassword) {
              if (widget.isEMail) {
                if (value!.isEmpty) {
                  return widget.validatorIsEmpty;
                } else if (EmailValidator.validate(value.trim()) == false) {
                  return widget.validatorError;
                }
              } else {
                if (value!.isEmpty) {
                  return widget.validatorIsEmpty;
                }
              }
            } else {
              if (value!.isEmpty) {
                return 'Enter Password';
              } else if (value.length < 6) {
                return 'Password must be atleast 6 characters!';
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}
