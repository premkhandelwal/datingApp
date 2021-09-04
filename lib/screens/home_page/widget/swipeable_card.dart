import 'package:animations/animations.dart';
import 'package:dating_app/screens/home_page/swipeable_card_full_screen.dart';
import 'package:dating_app/screens/home_page/widget/swipeable_sigle_card.dart';
import 'package:flutter/material.dart';

class SwipeableCard extends StatelessWidget {
  final String imageUrl;
  final String personName, personBio, personProfession;
  final int personAge;
  final Function swipeLeft, swipeRight;

  const SwipeableCard({
    Key? key,
    required this.imageUrl,
    required this.personName,
    required this.personBio,
    required this.personProfession,
    required this.personAge,
    required this.swipeLeft,
    required this.swipeRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OpenContainer(
        openBuilder: (BuildContext context,
            void Function({Object? returnValue}) action) {
          return SwipeableCardFullScreen(
            imageUrl: imageUrl,
            personProfession: personProfession,
            personBio: personBio,
            personName: personName,
            personAge: personAge,
            swipeRight: swipeRight,
            swipeLeft: swipeLeft,
          );
        },
        closedBuilder: (BuildContext context, void Function() action) {
          return SwipeableSingleCard(
              imageUrl: imageUrl,
              personAge: personAge,
              personName: personName,
              personProfession: personProfession);
        },
      ),
    );
  }
}