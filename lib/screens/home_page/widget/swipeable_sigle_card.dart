import 'dart:ui';

import 'package:dating_app/const/app_const.dart';
import 'package:flutter/material.dart';

class SwipeableSingleCard extends StatelessWidget {
  const SwipeableSingleCard({
    Key? key,
    required this.imageUrl,
    required this.personName,
    required this.personAge,
    required this.personProfession,
  }) : super(key: key);

  final String imageUrl, personName, personProfession;
  final int personAge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 700,
          width: 400,
          child: imageUrl.startsWith("assets")? Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ): Image.network(
            imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        Positioned(
          left: 8,
          top: 8,
          child: Container(
            height: 40,
            width: 61,
            decoration: BoxDecoration(
                color: AppColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      .copyWith(color: Colors.white, fontSize: 12),
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
              height: 70,
              width: 400,
              child: BackdropFilter(
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
                            .copyWith(color: Colors.white, fontSize: 24),
                      ),
                      Text(
                        '$personProfession',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                filter: ImageFilter.blur(
                    sigmaX: 20.0, sigmaY: 20.0, tileMode: TileMode.clamp),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
