import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomAppBar(
                context: context,
                centerWidget: Text('Your Profile'),
                trailingWidget: Container()),
            Container(
              height: 420,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage(sampleImages[0]),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: AppColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
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
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(
                      height: 20,
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
                          labelText: "Profession",
                          labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLines: 5,
                      maxLength: 399,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            gapPadding: 5,
                            borderSide: BorderSide(color: Colors.black45),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.black45)),
                          labelText: "About",
                          labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 100,
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
                                  color: _selectedInterests
                                          .contains(interests[index])
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
                                              color:
                                                  _selectedInterests.contains(
                                                          interests[index])
                                                      ? Colors.white
                                                      : Colors.black)),
                                ]),
                                pressElevation: 8,
                                elevation: _selectedInterests
                                        .contains(interests[index])
                                    ? 5
                                    : 0,
                                labelPadding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                selectedColor: AppColor,
                                selected: _selectedInterests
                                    .contains(interests[index]),
                                onSelected: (selected) {
                                  _selectedInterests.contains(interests[index])
                                      ? _selectedInterests
                                          .remove(interests[index])
                                      : _selectedInterests
                                          .add(interests[index]);
                                  setState(() {});
                                }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            CommonButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }
}
