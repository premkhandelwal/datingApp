import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/screens/home_page/chat/chat_bubble.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ChatModalBottomSheet extends StatelessWidget {
  const ChatModalBottomSheet({
    Key? key,
    required this.i,
  }) : super(key: key);

  final int i;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      height: 600.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 62.h,
                  width: 62.w,
                  child: IconsOutlinedButton(
                      icon: Icons.arrow_back,
                      size: Size(52.sp, 52.sp),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: Image.asset(
                        sampleImages[i],
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 50.w,
                    height: 50.h,
                  ),
                  SizedBox(width: 5.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 130.w,
                        child: Text(
                          name[i],
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          Container(
                            width: 130.w,
                            child: Text(
                              'online',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 62.h,
                width: 62.w,
                child: IconsOutlinedButton(
                  icon: Icons.more_vert,
                  size: Size(52.sp, 52.sp),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              reverse: true,
              children: [
                ChatBubble(
                  isMe: true,
                  messageTime: DateFormat('hh:mm a').format(
                    DateTime.now(),
                  ),
                  message:
                      'dkajnlsodiklansfdjoklsndfjklsnfdgmsvdkolncoldkjafnslkjdfmnsjolkdfnljksdnfdkajnlsodiklansfdjoklsndfjklsnfdgmsvdkolncoldkjafnslkjdfmnsjolkdfnljksdnfdkajnlsodiklansfdjoklsndfjklsnfdgmsvdkolncoldkjafnslkjdfmnsjolkdfnljksdnfdkajnlsodiklansfdjoklsndfjklsnfdgmsvdkolncoldkjafnslkjdfmnsjolkdfnljksdnfdkajnlsodiklansfdjoklsndfjklsnfdgmsvdkolncoldkjafnslkjdfmnsjolkdfnljksdnfdkajnlsodiklansfdjsasddfffdmfjvjvj',
                ),
                ChatBubble(
                  isMe: false,
                  messageTime: DateFormat('hh:mm a').format(
                    DateTime.now(),
                  ),
                  message:
                      'dkajnlsodiklansfdjoklsndfjklsnfdgmsvdkolncoldkjafnslkjdfmnsjolkdfnljksdnfdkajnlsodiklansfdjoklsndfjklsnfdgmsvdkolncoldkjafnslkjdfmnsjolkdfnljksdnfdkajnlsodiklansfdjoklsndfjklsnfdgmsvdkolncoldkjafnslkjdfmnsjolkdfnljksdnfdkajnlsodiklansfdjoklsndfjklsnfdgmsvdkolncoldkjafnslkjdfmnsjolkdfnljksdnfdkajnlsodiklansfdjoklsndfjklsnfdgmsvdkolncoldkjafnslkjdfmnsjolkdfnljksdnfdkajnlsodiklansfdjsasddfffdmfjvjvj',
                ),
                ChatBubble(
                  isMe: true,
                  messageTime: DateFormat('hh:mm a').format(
                    DateTime.now(),
                  ),
                  message: 'hello',
                ),
                ChatBubble(
                  isMe: false,
                  messageTime: DateFormat('hh:mm a').format(
                    DateTime.now(),
                  ),
                  message: 'hi',
                ),
              ],
            ),
          ),
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
                labelText: "Your Message",
                labelStyle: TextStyle(color: Colors.black45)),
          ),
        ],
      ),
    );
  }
}
