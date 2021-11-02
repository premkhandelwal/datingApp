import 'package:dating_app/logic/data/user.dart';

class ChatScreenArguments {
  String chatid;
  CurrentUser? user;
  String? uid;

  ChatScreenArguments({this.user, required this.chatid, this.uid});
}
