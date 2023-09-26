import 'package:flutter/material.dart';
import 'package:health_app/app_colors.dart';
import 'package:health_app/constant.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime givenDate;
  const CustomCalendar({Key? key, required this.givenDate}) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final List<String> daysOfWeek = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    "SUN"
  ];

  late DateTime dateGiven;
  late DateTime dateSelected;

  DateTime nextDate({required DateTime currentDate}) {
    return currentDate.add(const Duration(days: 1));
  }

  DateTime nextMonth({required DateTime currentDate}) {
    return DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
  }

  DateTime prevDate({required DateTime currentDate}) {
    return currentDate.subtract(const Duration(days: 1));
  }

  DateTime prevMonth({required DateTime currentDate}) {
    return DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
  }

  DateTime moveToSelectedDay({required int day}) {
    return DateTime(dateSelected.year, dateSelected.month, day);
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateSelected,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != dateSelected) {
      setState(() {
        dateSelected = picked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    dateGiven = widget.givenDate;
    dateSelected = dateGiven;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return Expanded(
      flex: 3,
      child: buildACalendarPage(),
    );
  }

  Container buildACalendarPage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: d.pSH(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        dateSelected = prevMonth(currentDate: dateSelected);
                      });
                    },
                    icon: Icon(Icons.arrow_back_ios, size: d.pSH(15))),
                GestureDetector(
                  onTap: () {
                    pickDate(context);
                  },
                  child: Text(
                    '${getMonth(dateSelected)} / ${getYear(dateSelected)}',
                    style: TextStyle(
                        fontSize: d.pSH(14), fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        dateSelected = nextMonth(currentDate: dateSelected);
                      });
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: d.pSH(15),
                    )),
              ],
            ),
          ),
          // SizedBox(height: d.pSH(5)),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: d.pSH(5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        // padding: EdgeInsets.symmetric(horizontal: d.pSH(5)),
                        shrinkWrap: false,
                        itemCount: getNumberOfDays(
                                year: dateSelected.year,
                                month: dateSelected.month) +
                            getFirstDayOfWeek(
                                dateSelected.year, dateSelected.month) -
                            1 +
                            daysOfWeek.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: d.pSH(1),
                            childAspectRatio: 4 / 3,
                            crossAxisCount: 7),
                        itemBuilder: (context, index) {
                          if (index < daysOfWeek.length) {
                            return Center(
                              child: Text(
                                daysOfWeek[index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            final dayNumber = index -
                                daysOfWeek.length +
                                2 -
                                getFirstDayOfWeek(
                                    dateSelected.year, dateSelected.month);

                            if (dayNumber >= 1 &&
                                dayNumber <=
                                    getNumberOfDays(
                                        year: dateSelected.year,
                                        month: dateSelected.month)) {
                              if (int.tryParse(getDay(index)) ==
                                  dateSelected.day) {
                                return Center(
                                  child: Card(
                                    shape: const CircleBorder(),
                                    margin: EdgeInsets.zero,
                                    child: Container(
                                      height: d.pSH(30),
                                      width: d.pSH(30),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(d.pSH(30))),
                                      child: Text(
                                        dayNumber.toString(),
                                        style: TextStyle(
                                            color: AppColors.whiteColorOne,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      dateSelected = moveToSelectedDay(
                                          day:
                                              int.tryParse(getDay(index)) ?? 1);
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      dayNumber.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Container();
                            }
                            // Display the day number or an empty cell if before the first day of the month
                          }
                        },
                      ),
                    ),
                  ),
                  Divider(
                    thickness: d.pSH(1.5),
                    color: AppColors.blackColorOne,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(CustomCalendar oldWidget) {
    if (oldWidget.givenDate != widget.givenDate) {
      setState(() {
        dateSelected = widget.givenDate;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  String getMonth(DateTime date) => DateFormat.MMMM().format(date);
  String getYear(DateTime date) => DateFormat.y().format(date);

  String getDay(int index) {
    if (index == 0) {
      return 'MON';
    }
    if (index == 1) {
      return 'TUE';
    }
    if (index == 2) {
      return 'WED';
    }
    if (index == 3) {
      return 'THU';
    }
    if (index == 4) {
      return 'FRI';
    }
    if (index == 5) {
      return 'SAT';
    }
    if (index == 6) {
      return 'SUN';
    }
    return "${index - 7 + 1}";
  }

  int getNumberOfDays({required int year, required int month}) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month should be between 1 and 12.');
    }

    return DateTime(year, month + 1, 0).day;
  }

  int getFirstDayOfWeek(int year, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month should be between 1 and 12.');
    }

    return DateTime(year, month, 1).weekday;
  }
}
