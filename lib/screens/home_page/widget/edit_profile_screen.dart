import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final CurrentUser user;
  const EditProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> _selectedInterests = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  File? _image;

  @override
  void initState() {
    _fillFields();
    super.initState();
  }

  void _fillFields() {
    if (widget.user.name != null) {
      nameController.text = widget.user.name!;
    }
    if (widget.user.profession != null) {
      professionController.text = widget.user.profession!;
    }
    if (widget.user.bio != null) {
      bioController.text = widget.user.bio!;
    }
    if (widget.user.image != null) {
      _image = widget.user.image;
    }
    if (widget.user.interests != null) {
      _selectedInterests = widget.user.interests!;
    }
  }

  Future<File?> _addImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    return null;
  }

  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.75, //set this as you want
        maxChildSize: 1, //set this as you want
        minChildSize: 0.75, //set this as you want
        expand: true,
        builder: (context, controller) => Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    children: [
                      CustomAppBar(
                          context: context,
                          centerWidget: Text('Your Profile'),
                          trailingWidget: Container()),
                      Container(
                        height: MediaQuery.of(context).size.height + 10,
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  ClipOval(
                                      child: _image != null
                                          ? Image.file(
                                              _image!,
                                              height: 150,
                                              width: 150,
                                              alignment: Alignment.topCenter,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Colors.amber,
                                            )
                                      // backgroundImage: AssetImage(sampleImages[0]),
                                      ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: _addImage,
                                          icon: Icon(
                                            Icons.add_a_photo,
                                            size: 30,
                                            color: AppColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      gapPadding: 5,
                                      borderSide:
                                          BorderSide(color: Colors.black45),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide:
                                            BorderSide(color: Colors.black45)),
                                    labelText: "Name",
                                    labelStyle:
                                        TextStyle(color: Colors.black45)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: professionController,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      gapPadding: 5,
                                      borderSide:
                                          BorderSide(color: Colors.black45),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide:
                                            BorderSide(color: Colors.black45)),
                                    labelText: "Profession",
                                    labelStyle:
                                        TextStyle(color: Colors.black45)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: bioController,
                                maxLines: 5,
                                maxLength: 399,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      gapPadding: 5,
                                      borderSide:
                                          BorderSide(color: Colors.black45),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide:
                                            BorderSide(color: Colors.black45)),
                                    labelText: "Bio",
                                    labelStyle:
                                        TextStyle(color: Colors.black45)),
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 300,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
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
                                                        color: _selectedInterests
                                                                .contains(
                                                                    interests[
                                                                        index])
                                                            ? Colors.white
                                                            : Colors.black)),
                                          ]),
                                          pressElevation: 8,
                                          elevation: _selectedInterests
                                                  .contains(interests[index])
                                              ? 5
                                              : 0,
                                          labelPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8.0),
                                          selectedColor: AppColor,
                                          selected: _selectedInterests
                                              .contains(interests[index]),
                                          onSelected: (selected) {
                                            _selectedInterests
                                                    .contains(interests[index])
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
                              SizedBox(
                                height: 20,
                              ),
                              BlocConsumer<ProfiledetailsBloc,
                                  ProfiledetailsState>(
                                listener: (context, state) {
                                  if (state is UpdatedInfoState) {
                                    Navigator.pop(context);
                                  }
                                },
                                builder: (context, state) {
                                  if (state is UpdatingInfoState) {
                                    return CircularProgressIndicator(
                                      backgroundColor: Colors.yellow,
                                    );
                                  }
                                  return CommonButton(
                                      text: 'Continue',
                                      onPressed: () {
                                        context.read<ProfiledetailsBloc>().add(
                                            UpdateInfoEvent(
                                                user: CurrentUser(
                                                    locationCoordinates: widget
                                                        .user
                                                        .locationCoordinates,
                                                    age: widget.user.age,
                                                    name: nameController.text,
                                                    bio: bioController.text,
                                                    profession:
                                                        professionController
                                                            .text,
                                                    image: _image,
                                                    interests:
                                                        _selectedInterests)));
                                      });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
