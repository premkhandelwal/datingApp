import 'dart:io';

import 'package:animations/animations.dart';
import 'package:dating_app/screens/home_page/swipeable_card_full_screen.dart';
import 'package:dating_app/screens/home_page/widget/swipeable_sigle_card.dart';
import 'package:flutter/material.dart';



class SwipeableCard extends StatefulWidget {
  final File? imageUrl;
  final String personName, personBio, personProfession;
  final int personAge;
  final Function swipeLeft, swipeRight;

  const SwipeableCard({
    Key? key,
    this.imageUrl,
    required this.personName,
    required this.personBio,
    required this.personProfession,
    required this.personAge,
    required this.swipeLeft,
    required this.swipeRight,
  }) : super(key: key);

  @override
  _SwipeableCardState createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant SwipeableCard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OpenContainer(
        openBuilder: (BuildContext context,
            void Function({Object? returnValue}) action) {
          return SwipeableCardFullScreen(
            image: widget.imageUrl,
            personProfession: widget.personProfession,
            personBio: widget.personBio,
            personName: widget.personName,
            personAge: widget.personAge,
            swipeRight: widget.swipeRight,
            swipeLeft: widget.swipeLeft,
          );
        },
        closedBuilder: (BuildContext context, void Function() action) {
          return SwipeableSingleCard(
              imageUrl: widget.imageUrl,
              personAge: widget.personAge,
              personName: widget.personName,
              personProfession: widget.personProfession);
        },
      ),
    );
  }
}
