import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          'Discover',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          'Chicago, II',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                  trailingWidget: IconButton(
                    icon: Icon(
                      Icons.filter_alt,
                      color: AppColor,
                    ),
                    onPressed: () {},
                  ),
                ),
                Text('This is a home page'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
