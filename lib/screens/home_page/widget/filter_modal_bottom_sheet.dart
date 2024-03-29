import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/logic/data/applied_filters.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterModalBottomSheet extends StatefulWidget {
  const FilterModalBottomSheet({
    Key? key,
  }) : super(key: key);
  @override
  _FilterModalBottomSheetState createState() => _FilterModalBottomSheetState();
}

RangeValues ageRange = const RangeValues(18, 22);
double distance = 5;

class _FilterModalBottomSheetState extends State<FilterModalBottomSheet> {
  String dropdownValue = location[0];
  var _selectedGender = GENDER.notSelected;
  late UseractivityBloc useractivityBloc;
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
    super.initState();
    useractivityBloc = BlocProvider.of<UseractivityBloc>(context);
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0.sp),
        child: BlocBuilder<UseractivityBloc, UseractivityState>(
          buildWhen: (previousState, currentState) {
            if (currentState is ClearedFiltersState) {
              ageRange = RangeValues(
                  SessionConstants.defaultFilters!.minAge.toDouble(),
                  SessionConstants.defaultFilters!.maxAge.toDouble());
              distance =
                  SessionConstants.defaultFilters!.thresholdDist.toDouble();
              _selectedGender = SessionConstants.defaultFilters!.interestedIn;
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
                    Container(width: 50.w),
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    InkWell(
                      onTap: () {
                        useractivityBloc.add(ClearedFiltersEvent());
                      },
                      child: SizedBox(
                        width: 50.w,
                        child: Text(
                          'Clear',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: appColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: const [
                    SectionHeading(
                      text: 'Interested in',
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(15.0.sp),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
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
                                bottomLeft: Radius.circular(15.r),
                                topLeft: Radius.circular(15.r)),
                            child: AnimatedContainer(
                              width: _selectedGender == GENDER.female
                                  ? 120.w
                                  : 90.w,
                              decoration: BoxDecoration(
                                  color: _selectedGender == GENDER.female
                                      ? appColor
                                      : Colors.white),
                              padding: EdgeInsets.all(20.sp),
                              duration: const Duration(milliseconds: 200),
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
                            width:
                                _selectedGender == GENDER.male ? 120.w : 90.w,
                            decoration: BoxDecoration(
                                color: _selectedGender == GENDER.male
                                    ? appColor
                                    : Colors.white),
                            padding: EdgeInsets.all(20.sp),
                            duration: const Duration(milliseconds: 200),
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
                                bottomRight: Radius.circular(15.r),
                                topRight: Radius.circular(15.r)),
                            child: AnimatedContainer(
                              width: _selectedGender == GENDER.both
                                  ? 120.w
                                  : 90.w,
                              decoration: BoxDecoration(
                                  color: _selectedGender == GENDER.both
                                      ? appColor
                                      : Colors.white),
                              padding: EdgeInsets.all(20.sp),
                              duration: const Duration(milliseconds: 200),
                              child: Center(
                                child: Text(
                                  'Both',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                          color:
                                              _selectedGender == GENDER.both
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
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionHeading(text: 'Distance'),
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
                    activeColor: appColor,
                    onChanged: (val) {
                      setState(() {
                        /*  SessionConstants.appliedFilters[
                                DistanceFilterChangedEvent(thresholdDist: val)] = true; */
                        distance = val;
                      });
                    }),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionHeading(text: 'Age'),
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
                    activeColor: appColor,
                    onChanged: (val) {
                      setState(() {
                        /*   SessionConstants.appliedFilters[AgeFilterChangedEvent(
                                minAge: val.start, maxAge: val.end)] = true; */

                        ageRange = val;
                      });
                    }),
                const Spacer(),
                CommonButton(
                    text: 'Continue',
                    onPressed: () {
                      SessionConstants.appliedFilters = AppliedFilters(
                          minAge: ageRange.start,
                          maxAge: ageRange.end,
                          interestedIn: _selectedGender,
                          thresholdDist: distance);
                      useractivityBloc.add(FilterChangedEvent(
                          minAge: ageRange.start,
                          maxAge: ageRange.end,
                          interestedIn: _selectedGender,
                          thresholdDist: distance));
                    
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
