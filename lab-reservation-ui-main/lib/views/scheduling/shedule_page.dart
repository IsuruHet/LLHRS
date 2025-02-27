import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reserv/services/session_service.dart';
import 'package:reserv/views/widgets/calendar_items.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _scroll = ScrollController();
  late DateTime _focusedDay;
  DateTime _selectedDay = DateTime.now();
  // bool isScrolling = false;
  // bool isDowning = false;
  // bool isUpping = false;

  @override
  void initState() {
    _focusedDay = DateTime.now();
    super.initState();
    // _scroll.addListener(_listener);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  // void _listener() {
  //   if (_scroll.position.userScrollDirection == ScrollDirection.reverse &&
  //       isDowning == false) {
  //     isDowning = true;
  //     isUpping = false;
  //     setState(() {
  //       isScrolling = true;
  //     });
  //   }
  //   if (_scroll.position.userScrollDirection == ScrollDirection.forward &&
  //       isUpping == false) {
  //     isUpping = true;
  //     isDowning = false;
  //     setState(() {
  //       isScrolling = false;
  //     });
  //   }
  // }
  CalendarFormat _calendarFormat = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: TableCalendar(
                headerStyle: const HeaderStyle(
                  formatButtonVisible: true,
                ),
                calendarStyle: const CalendarStyle(
                  cellMargin: EdgeInsets.all(5),
                ),
                calendarFormat: _calendarFormat,
                rowHeight: 40,
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FutureBuilder(
                      future: context
                          .read<SessionService>()
                          .getSessionsByDate(date: _selectedDay),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: SpinKitThreeBounce(
                              color: Theme.of(context)
                                  .progressIndicatorTheme
                                  .color,
                              size: 30.0,
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty) {
                            return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10,
                              ),
                              itemBuilder: (context, index) {
                                return CalendarItems(
                                  session: snapshot.data![index],
                                );
                              },
                              itemCount: snapshot.data!.length,
                              controller: _scroll,
                            );
                          }
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.warning,
                                  size: 35,
                                  color: Colors.amber,
                                ),
                                Text("No schedules for the selected date.")
                              ],
                            ),
                          );
                        }

                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wifi_off,
                                color: Colors.red,
                                size: 35,
                              ),
                              Text("Please check your internet conncetion")
                            ],
                          ),
                        );
                      },
                    )))
          ],
        ),
      ),
    );
  }
}
