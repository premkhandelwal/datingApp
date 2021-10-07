import 'dart:math';

import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/screens/home_page/chat/chat_full_screen.dart';
import 'package:dating_app/screens/home_page/chat/single_chat_list_tile.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String imageUrl = '', personName = '', lastTextMessage = '', time = '';
  int latestMessageCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(20.0.sp),
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
                      icon: Icons.tune, size: Size(52.sp, 52.sp), onPressed: () {}),
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        gapPadding: 5.sp,
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide(color: Colors.black45)),
                      labelText: "Search",
                      labelStyle: TextStyle(color: Colors.black45)),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: ListView.builder(
                      itemCount: name.length,
                      itemBuilder: (ctx, i) {
                        imageUrl = sampleImages[i];
                        personName = name[i];
                        lastTextMessage = biography[i];
                        time = DateTime.now().toString();
                        latestMessageCount = Random().nextInt(5);
                        return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                enableDrag: true,
                                isScrollControlled: true,
                                context: context,
                                backgroundColor: Colors.white.withOpacity(0),
                                builder: (ctx) {
                                  return ChatModalBottomSheet(
                                    i: i,
                                  );
                                });
                          },
                          child: ChatListTile(
                            imageUrl: imageUrl,
                            latestMessageCount: latestMessageCount,
                            personName: personName,
                            lastTextMessage: lastTextMessage,
                            time: time,
                            index: i,
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
