import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    Key? key,
    required this.latestMessageCount,
    required this.personName,
    required this.lastTextMessage,
    required this.time,
    required this.imageUrl,
    required this.index,
  }) : super(key: key);

  final int latestMessageCount;
  final String personName;
  final String lastTextMessage;
  final String time;
  final String imageUrl;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.red,
                  border: Border.all(
                    color: Colors.green,
                    width: latestMessageCount > 0 ? 3 : 0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                width: 60,
                height: 60,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 170,
                    child: Text(
                      personName,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 200,
                    child: Text(
                      lastTextMessage,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.grey),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 50,
                    child: Text(
                      time,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 5),
                  if (latestMessageCount > 0)
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColor,
                      child: Text(
                        latestMessageCount.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: Colors.white),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
        if (index < name.length - 1)
          Divider(
            indent: 70,
            endIndent: 20,
            thickness: 2,
          )
      ],
    );
  }
}
