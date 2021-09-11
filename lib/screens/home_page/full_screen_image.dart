import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  final List image;
  final int currentIndex;
  const FullScreenImage(
      {Key? key, required this.image, required this.currentIndex})
      : super(key: key);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  int _current = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _current = widget.currentIndex;
  }

  final _controller = ScrollController();
  void _animateToIndex(i) => _controller.animateTo(55.0 * i,
      duration: Duration(milliseconds: 350), curve: Curves.fastOutSlowIn);
  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    print('int changes');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomAppBar(
                  context: context,
                  centerWidget: Container(),
                  trailingWidget: Container()),
            ),
            CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                  viewportFraction: 0.9,
                  initialPage: _current,
                  height: 550,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                      _animateToIndex(index);
                    });
                  }),
              items: widget.image.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: AssetImage('$i'),
                            fit: BoxFit.contain,
                            alignment: Alignment.topRight),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Container(
              width: 300,
              height: 55,
              child: ListView(
                controller: _controller,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.image.asMap().entries.map((entry) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _current = entry.key;
                            buttonCarouselController.animateToPage(entry.key);
                          });
                        },
                        child: Container(
                          width: 50.0,
                          height: 55.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                Colors.grey
                                    .withOpacity(_current == entry.key ? 0 : 1),
                                BlendMode.saturation,
                              ),
                              image: AssetImage('${entry.value}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          // decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: AppColor.withOpacity(
                          //         _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
