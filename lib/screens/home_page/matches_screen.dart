import 'dart:ui';

import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  @override
  Widget build(BuildContext context) {
    void removeItem(int i) {
      setState(() {
        sampleImages.removeAt(i);
      });
    }

    List<Widget> cards = List.generate(
      sampleImages.length,
      (int index) {
        String personName = name.elementAt(index);
        int personAge = age.elementAt(index);
        String imageUrl = sampleImages.elementAt(index);
        return Container(
            padding: EdgeInsets.all(7),
            child: ClipRRect(
              child: Container(
                height: 350,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 350,
                        width: 200,
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$personName, $personAge',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: Container(
                          height: 50,
                          width: 170,
                          child: BackdropFilter(
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      removeItem(index);
                                      print('cancel');
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 2,
                                  color: Colors.white,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      print('like');
                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            filter: ImageFilter.blur(
                                sigmaX: 10.0,
                                sigmaY: 10.0,
                                tileMode: TileMode.clamp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              borderRadius: BorderRadius.circular(20),
            ));
      },
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                          'Matches',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                  trailingWidget: IconsOutlinedButton(
                      icon: Icons.filter_list,
                      size: Size(52, 52),
                      onPressed: () {}),
                ),
                SizedBox(height: 10),
                Text(
                  'This is a list of people who have liked you and your matches.',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 2 / 3),
                        itemCount: sampleImages.length,
                        itemBuilder: (context, index) {
                          return cards.elementAt(index);
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
