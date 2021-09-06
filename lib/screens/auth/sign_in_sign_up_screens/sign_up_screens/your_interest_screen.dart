import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/screens/search_friends_screen/search_friends_Screen.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';

class YourInterestScreen extends StatefulWidget {
  YourInterestScreen({Key? key}) : super(key: key);

  @override
  _YourInterestScreenState createState() => _YourInterestScreenState();
}

class _YourInterestScreenState extends State<YourInterestScreen> {
  List<IconData> iconsList = [
    Icons.camera,
    Icons.shopping_bag_outlined,
    Icons.mic_none_outlined,
    Icons.fitness_center,
    Icons.outdoor_grill,
    Icons.sports_tennis,
    Icons.directions_run,
    Icons.pool,
    Icons.color_lens,
    Icons.travel_explore,
    Icons.paragliding,
    Icons.library_music,
    Icons.local_bar,
    Icons.videogame_asset
  ];
  List<String> _selectedInterests = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomAppBar(
                centerWidget: Container(),
                trailingWidget: Container(),
                context: context,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Your interests',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Select a few of your interests and let everyone know what you’re passionate about.',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1,
                      childAspectRatio: 3 / 1),
                  itemCount: interests.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(2.0),
                      child: ChoiceChip(
                          avatar: Icon(
                            iconsList[index],
                            color: _selectedInterests.contains(interests[index])
                                ? Colors.white
                                : AppColor,
                          ),
                          backgroundColor: Colors.white,
                          label: Row(children: [
                            Text(interests[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: _selectedInterests
                                                .contains(interests[index])
                                            ? Colors.white
                                            : Colors.black)),
                          ]),
                          pressElevation: 8,
                          elevation:
                              _selectedInterests.contains(interests[index])
                                  ? 5
                                  : 0,
                          labelPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          selectedColor: AppColor,
                          selected:
                              _selectedInterests.contains(interests[index]),
                          onSelected: (selected) {
                            _selectedInterests.contains(interests[index])
                                ? _selectedInterests.remove(interests[index])
                                : _selectedInterests.add(interests[index]);
                            setState(() {});
                          }),
                    );
                  },
                ),
              ),
              Text(
                'Selected $_selectedInterests',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              CommonButton(
                  text: 'Continue',
                  onPressed: () {
                    changePageTo(
                        context: context, widget: SearchFriendsScreen());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
