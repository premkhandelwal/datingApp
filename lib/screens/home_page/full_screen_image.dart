import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating_app/arguments/full_screen_image_arguments.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage({Key? key}) : super(key: key);

  static const routeName = '/fullScreenImage';

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  int _current = -1;
  @override
  void initState() {
    super.initState();
  }

  final _controller = ScrollController();
  void _animateToIndex(i) => _controller.animateTo(55.0 * i,
      duration: const Duration(milliseconds: 350), curve: Curves.fastOutSlowIn);
  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as FullScreenImageArguments;
    if (_current == -1) {
      _current = args.currentIndex;
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.sp),
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
                  height: 550.h,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                      _animateToIndex(index);
                    });
                  }),
              items: args.image.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
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
            SizedBox(
              width: 300.w,
              height: 55.h,
              child: ListView(
                controller: _controller,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: args.image.asMap().entries.map((entry) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _current = entry.key;
                            buttonCarouselController.animateToPage(entry.key);
                          });
                        },
                        child: Container(
                          width: 50.0.w,
                          height: 55.0.h,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0.sp, horizontal: 4.0.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
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
