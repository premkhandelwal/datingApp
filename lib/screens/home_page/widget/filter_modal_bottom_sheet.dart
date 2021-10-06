import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterModalBottomSheet extends StatefulWidget {
  FilterModalBottomSheet({
    Key? key,
  }) : super(key: key);
  @override
  _FilterModalBottomSheetState createState() => _FilterModalBottomSheetState();
}

RangeValues ageRange = const RangeValues(18, 22);
double distance = 5;

class _FilterModalBottomSheetState extends State<FilterModalBottomSheet> {
  String dropdownValue = location[0];
  var _selectedGender = GENDER.NotSelected;
 /*  void clearFilter() {
    _selectedGender = GENDER.NotSelected;
    distance = 5;
    ageRange = RangeValues(18, 22);
    dropdownValue = location[0];
  } */

  void applyFilters() {
    if (SessionConstants.appliedFilters != null) {
      ageRange = RangeValues(SessionConstants.appliedFilters!.minAge.toDouble(),
          SessionConstants.appliedFilters!.maxAge.toDouble());
      distance = SessionConstants.appliedFilters!.thresholdDist.toDouble();
      _selectedGender = SessionConstants.appliedFilters!.interestedIn;
    }
  }

  @override
  void initState() {
    applyFilters();
    super.initState();
  }

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
        child: BlocBuilder<UseractivityBloc, UseractivityState>(
          buildWhen: (previousState, currentState) {
            if (currentState is ClearedFiltersState) {
              applyFilters();
              return true;
            }
            return false;
          },
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 50),
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    InkWell(
                      onTap: () {
                        context
                            .read<UseractivityBloc>()
                            .add(ClearedFiltersEvent());
                      },
                      child: Container(
                        width: 50,
                        child: Text(
                          'Clear',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: AppColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SectionHeading(
                      text: 'Interested in',
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedGender = GENDER.female;
                              // SessionConstants.appliedFilters!.interestedIn = _selectedGender;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                topLeft: Radius.circular(15)),
                            child: AnimatedContainer(
                              width:
                                  _selectedGender == GENDER.female ? 120 : 90,
                              decoration: BoxDecoration(
                                  color: _selectedGender == GENDER.female
                                      ? AppColor
                                      : Colors.white),
                              padding: EdgeInsets.all(20),
                              duration: Duration(milliseconds: 200),
                              child: Center(
                                child: Text(
                                  'Girls',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                          color:
                                              _selectedGender == GENDER.female
                                                  ? Colors.white
                                                  : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedGender = GENDER.male;
                              /* SessionConstants.appliedFilters[
                                      GenderFilterChangedEvent(
                                          interestedIn: GENDER.male)] = true; */
                            });
                          },
                          child: AnimatedContainer(
                            width: _selectedGender == GENDER.male ? 120 : 90,
                            decoration: BoxDecoration(
                                color: _selectedGender == GENDER.male
                                    ? AppColor
                                    : Colors.white),
                            padding: EdgeInsets.all(20),
                            duration: Duration(milliseconds: 200),
                            child: Center(
                              child: Text(
                                'Boys',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: _selectedGender == GENDER.male
                                            ? Colors.white
                                            : Colors.black),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedGender = GENDER.both;
                              /*  SessionConstants.appliedFilters[
                                      GenderFilterChangedEvent(
                                          interestedIn: GENDER.both)] = true; */
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            child: AnimatedContainer(
                              width: _selectedGender == GENDER.other ? 120 : 90,
                              decoration: BoxDecoration(
                                  color: _selectedGender == GENDER.both
                                      ? AppColor
                                      : Colors.white),
                              padding: EdgeInsets.all(20),
                              duration: Duration(milliseconds: 200),
                              child: Center(
                                child: Text(
                                  'Both',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                          color: _selectedGender == GENDER.other
                                              ? Colors.white
                                              : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                /* SizedBox(height: 20),
                    Row(
                      children: [
                        SectionHeading(text: 'Location'),
                      ],
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      value: dropdownValue,
                      items: location.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          dropdownValue = val!;
                        });
                      },
                    ), */
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SectionHeading(text: 'Distance'),
                    Text(
                      distance < 80
                          ? '${(distance.toStringAsFixed(1))}km'
                          : 'Country',
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                ),
                Slider(
                    value: distance,
                    min: 1,
                    divisions: 80,
                    max: 90,
                    inactiveColor: Colors.grey,
                    activeColor: AppColor,
                    onChanged: (val) {
                      setState(() {
                        /*  SessionConstants.appliedFilters[
                                DistanceFilterChangedEvent(thresholdDist: val)] = true; */
                        distance = val;
                      });
                    }),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SectionHeading(text: 'Age'),
                    Text(
                      '${(ageRange.start.toStringAsFixed(0))} - ${(ageRange.end.toStringAsFixed(0))}',
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                ),
                RangeSlider(
                    values: ageRange,
                    min: 18,
                    max: 60,
                    inactiveColor: Colors.grey,
                    activeColor: AppColor,
                    onChanged: (val) {
                      setState(() {
                        /*   SessionConstants.appliedFilters[AgeFilterChangedEvent(
                                minAge: val.start, maxAge: val.end)] = true; */

                        ageRange = val;
                      });
                    }),
                Spacer(),
                CommonButton(
                    text: 'Continue',
                    onPressed: () {
                      print(_selectedGender);
                      print(distance);
                      print(ageRange);
                      print(dropdownValue);
                      SessionConstants.appliedFilters = FilterChangedEvent(
                          minAge: ageRange.start,
                          maxAge: ageRange.end,
                          interestedIn: _selectedGender,
                          thresholdDist: distance);
                      context.read<UseractivityBloc>().add(FilterChangedEvent(
                          minAge: ageRange.start,
                          maxAge: ageRange.end,
                          interestedIn: _selectedGender,
                          thresholdDist: distance));
                      /*  SessionConstants.appliedFilters.forEach((key, value) {
                            if (value) {
                              context.read<UseractivityBloc>().add(key);
                            }
                          });
         */
                      Navigator.of(context).pop();
                    })
              ],
            );
          },
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String text;
  const SectionHeading({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(fontWeight: FontWeight.bold));
  }
}
