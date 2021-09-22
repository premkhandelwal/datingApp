import 'dart:io';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/screens/home_page/full_screen_image.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';

class SwipeableCardFullScreen extends StatelessWidget {
  const SwipeableCardFullScreen({
    Key? key,
    required this.image,
    required this.personName,
    required this.personBio,
    required this.personProfession,
    required this.personAge,
    required this.swipeLeft,
    required this.swipeRight,
  }) : super(key: key);
  final Function? swipeLeft, swipeRight;
  final File? image;
  final String? personName, personBio, personProfession;
  final int? personAge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Container(
                height: 500,
                width: double.infinity,
                child: image != null ? Image.file(
                  image!,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ) : Container(),
              ),
              Container(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomAppBar(
                          context: context,
                          centerWidget: Container(),
                          trailingWidget: Container()),
                    ),
                    SizedBox(height: 280),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('$personName, $personAge',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!),
                                      Text('$personProfession',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!),
                                    ],
                                  ),
                                  IconsOutlinedButton(
                                    onPressed: () {},
                                    iconSize: 30,
                                    size: Size(20, 60),
                                    icon: Icons.near_me,
                                  )
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Location',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!),
                                      Text('Chicago, IL United States',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!),
                                    ],
                                  ),
                                  Container(
                                    height: 40,
                                    width: 61,
                                    decoration: BoxDecoration(
                                        color: AppColor.withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        Text(
                                          '1 KM',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Text(
                                'Bio',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                '$personBio',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              SizedBox(height: 30),
                              Text(
                                'Interests',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Container(
                                height: 100,
                                child: GridView.builder(
                                  itemCount: interests.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 1,
                                          childAspectRatio: 3 / 1),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            interests[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Gallery',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  Text(
                                    'See all',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            color: AppColor,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Container(
                                height: 400,
                                child: GridView.builder(
                                  itemCount: sampleImages.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 2,
                                          crossAxisSpacing: 5,
                                          childAspectRatio: 1),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FullScreenImage(
                                              image: sampleImages,
                                              currentIndex: index,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          sampleImages[index],
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.topCenter,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -25,
                          left: 50,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 40,
                            child: Center(
                              child: IconButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await Future.delayed(
                                        Duration(milliseconds: 200));
                                    print('hi');
                                    swipeLeft!;
                                    print('hi');
                                  },
                                  iconSize: 60,
                                  color: Color(0xffF27121),
                                  icon: Icon(Icons.close)),
                            ),
                          ),
                        ),
                        Positioned(
                            top: -25,
                            right: 50,
                            child: CircleAvatar(
                              backgroundColor: AppColor,
                              radius: 40,
                              child: Center(
                                child: IconButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await Future.delayed(
                                          Duration(milliseconds: 200));
                                      swipeRight!;
                                    },
                                    iconSize: 60,
                                    color: Colors.white,
                                    icon: Icon(Icons.favorite)),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   top: 10,
              //   left: 10,
              //   child,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
