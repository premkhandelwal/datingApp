import 'package:dating_app/arguments/chat_screen_arguments.dart';
import 'package:dating_app/logic/data/conversations.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/main.dart';
import 'package:dating_app/services/db_services.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({Key? key}) : super(key: key);

  static const routeName = '/conversationsScreen';

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  late DbServices db = DbServices();
  List<CurrentUser?>? conversationUsers;
  late List<CurrentUser?> users;
  List<Conversations?>? conversations;

  Future<void> getDeviceTokens() async {
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await db.saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(db.saveTokenToDatabase);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Conversations?>?>.value(
          value: db.getConversations(),
          initialData: null,
        ),
      ],
      child: Builder(
        builder: (context) {
          List<Conversations?>? conversations =
              Provider.of<List<Conversations?>?>(context) ?? [];
          users = Provider.of<List<CurrentUser>?>(context) ?? [];
          conversationUsers = getConversationUsers(users, conversations);

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.0.sp),
                child: Center(
                  child: Column(
                    children: [
                      CustomAppBar(
                        context: context,
                        canGoBack: false,
                        centerWidget: Container(
                          child: Column(
                            children: [
                              Text(
                                'Messages',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                        trailingWidget: IconsOutlinedButton(
                            icon: Icons.tune,
                            size: Size(52.sp, 52.sp),
                            onPressed: () {}),
                      ),
                      ListView.builder(
                          itemCount: conversations.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 0,
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pushNamed(
                                    myContext,
                                    ChatScreen.routeName,
                                    arguments: ChatScreenArguments(
                                        user: conversationUsers![index]!,
                                        chatid: conversations[index]!.chatid!),
                                  );
                                  await db.updateSeenStatus(
                                      conversations[index]!.userId!);
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.pink,
                                        maxRadius: 30,
                                        backgroundImage:
                                            conversationUsers?[index]?.image ==
                                                    null
                                                ? null
                                                : FileImage(
                                                    conversationUsers![index]!
                                                        .image!),
                                        child:
                                            conversationUsers?[index]?.image ==
                                                    null
                                                ? Text(
                                                    conversationUsers?[index]
                                                            ?.name![0]
                                                            .toUpperCase() ??
                                                        '',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  )
                                                : Container(),
                                      ),
                                      title: Text(
                                        conversationUsers?[index]?.name! ?? '',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        conversations[index]!.message!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                conversations[index]!.status ==
                                                        'unseen'
                                                    ? Colors.blue
                                                    : Colors.grey.shade600,
                                            fontWeight:
                                                conversations[index]!.status ==
                                                        'unseen'
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                      ),
                                      trailing: Text(
                                        DateFormat('yy/MM/dd hh:mm').format(
                                            DateTime.parse(conversations[index]!
                                                .sendTime!)),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                conversations[index]!.status ==
                                                        'unseen'
                                                    ? Colors.blue
                                                    : Colors.grey.shade600,
                                            fontWeight:
                                                conversations[index]!.status ==
                                                        'unseen'
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
