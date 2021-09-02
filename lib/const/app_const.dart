import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color AppColor = Color(0xffE94057);
enum GENDER { NotSelected, male, female, other }

void changePageTo({required BuildContext context, required Widget widget}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => widget));
}
