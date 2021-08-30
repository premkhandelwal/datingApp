
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _date = "Choose birthday date";
  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Profile Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 180,
                height: 150,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: firstName,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 5,
                      borderSide: BorderSide(color: Colors.black45),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45)),
                    labelText: "First Name",
                    labelStyle: TextStyle(color: Colors.black45)),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: lastName,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 5,
                      borderSide: BorderSide(color: Colors.black45),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45)),
                    labelText: "Last Name",
                    labelStyle: TextStyle(color: Colors.black45)),
              ),
              SizedBox(height:10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[50],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (date) {
                    
                    _date = '${date.day}/${date.month}/${date.year}';
                    setState(() {});
                  }, currentTime: DateTime.now());
                  setState(() {});
                },
                child: Container(
                  
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        
                        children: <Widget>[
                        Icon(Icons.calendar_today,color: Colors.red,),
                        SizedBox(width: 20,),
                          Text(
                            " $_date",
                            style: TextStyle(
                                color: Colors.red,
                                
                                fontSize: 15.0),
                          )
                        ],
                      ),
                    ],
                  ),
                  color: Colors.red[50],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                child: Text("Confirm"),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  fixedSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(
                      
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
