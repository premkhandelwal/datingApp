import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/screens/home_page/chat/chat_bubble.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';
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
      padding: EdgeInsets.all(20),
      height: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 62,
                  width: 62,
                  child: IconsOutlinedButton(
                      icon: Icons.arrow_back,
                      size: Size(52, 52),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        sampleImages[i],
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 130,
                        child: Text(
                          name[i],
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 130,
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
                height: 62,
                width: 62,
                child: IconsOutlinedButton(
                  icon: Icons.more_vert,
                  size: Size(52, 52),
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
                  borderRadius: BorderRadius.circular(15),
                  gapPadding: 5,
                  borderSide: BorderSide(color: Colors.black45),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black45)),
                labelText: "Your Message",
                labelStyle: TextStyle(color: Colors.black45)),
          ),
        ],
      ),
    );
  }
}
