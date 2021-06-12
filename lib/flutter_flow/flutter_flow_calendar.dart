import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

DateTime kFirstDay = DateTime(1970, 1, 1);
DateTime kLastDay = DateTime(2100, 1, 1);

extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59);
}

bool isSameDay(DateTime a, DateTime b) {
  if (a == null || b == null) {
    return false;
  }
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isSameMonth(DateTime a, DateTime b) {
  if (a == null || b == null) {
    return false;
  }
  return a.year == b.year && a.month == b.month;
}

class FlutterFlowCalendar extends StatefulWidget {
  const FlutterFlowCalendar({
    @required this.color,
    this.onChange,
    this.runMode = false,
    this.weekFormat = false,
    this.weekStartsMonday = false,
    Key key,
  }) : super(key: key);

  final bool runMode;
  final bool weekFormat;
  final bool weekStartsMonday;
  final Color color;
  final void Function(DateTimeRange) onChange;

  static const Cubic pageAnimationCurve = Curves.easeInOut;
  static const Duration pageAnimationDuration = Duration(milliseconds: 350);

  @override
  State<StatefulWidget> createState() => _FlutterFlowCalendarState();
}

class _FlutterFlowCalendarState extends State<FlutterFlowCalendar> {
  DateTime focusedDay;
  DateTimeRange selectedDay;
  CalendarController calendarController;

  @override
  void initState() {
    super.initState();
    focusedDay = DateTime.now();
    selectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    calendarController = CalendarController();
  }

  CalendarFormat get calendarFormat =>
      widget.weekFormat ? CalendarFormat.week : CalendarFormat.month;

  StartingDayOfWeek get startingDayOfWeek => widget.weekStartsMonday
      ? StartingDayOfWeek.monday
      : StartingDayOfWeek.sunday;

  Color get color => widget.color;

  Color get lightColor => widget.color.withOpacity(0.85);

  Color get lighterColor => widget.color.withOpacity(0.60);

  void setSelectedDay(
    DateTime newSelectedDay, [
    DateTime newSelectedEnd,
  ]) {
    final newRange = newSelectedDay == null
        ? null
        : DateTimeRange(
            start: newSelectedDay,
            end: newSelectedEnd ?? newSelectedDay,
          );
    setState(() {
      selectedDay = newRange;
      calendarController.setSelectedDay(newSelectedDay);
      widget.onChange?.call(newRange);
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CalendarHeader(
            focusedDay: focusedDay,
            onLeftChevronTap: () {
              calendarController.previousPage();
            },
            onRightChevronTap: () {
              calendarController.nextPage();
            },
            onTodayButtonTap: () {
              if (!calendarController.visibleDays.any(
                calendarController.isToday,
              )) {
                setState(() {
                  calendarController.setFocusedDay(DateTime.now());
                  focusedDay = DateTime.now();
                });
              }
            },
          ),
          TableCalendar(
            calendarController: calendarController,
            startDay: kFirstDay,
            endDay: kLastDay,
            initialCalendarFormat: calendarFormat,
            headerVisible: false,
            calendarStyle: CalendarStyle(
              weekdayStyle: const TextStyle(),
              weekendStyle: const TextStyle(),
              holidayStyle: const TextStyle(),
              outsideWeekendStyle: const TextStyle(color: Color(0xFF9E9E9E)),
              outsideHolidayStyle: const TextStyle(color: Color(0xFF9E9E9E)),
              eventDayStyle: const TextStyle(),
              selectedColor: color,
              todayColor: lighterColor,
              markersColor: lightColor,
              canEventMarkersOverflow: true,
            ),
            availableGestures: AvailableGestures.horizontalSwipe,
            startingDayOfWeek: startingDayOfWeek,
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Color(0xFF616161)),
              weekendStyle: TextStyle(color: Color(0xFF616161)),
            ),
            holidays: const {},
            onDaySelected: (newSelectedDay, _, __) {
              if (!isSameDay(selectedDay?.start, newSelectedDay)) {
                setSelectedDay(newSelectedDay);
                if (!isSameMonth(focusedDay, newSelectedDay)) {
                  setState(() {
                    newSelectedDay.isAfter(focusedDay)
                        ? calendarController.nextPage()
                        : calendarController.previousPage();
                    focusedDay = newSelectedDay;
                    calendarController.setFocusedDay(newSelectedDay);
                  });
                }
              }
            },
            onVisibleDaysChanged: (start, end, format) {
              setState(() {
                focusedDay = start.add(end.difference(start) ~/ 2);
                calendarController.setFocusedDay(focusedDay);
              });
            },
          ),
        ],
      );
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    @required this.focusedDay,
    @required this.onLeftChevronTap,
    @required this.onRightChevronTap,
    @required this.onTodayButtonTap,
    this.clearButtonVisible = false,
    this.onClearButtonTap,
    Key key,
  }) : super(key: key);

  final bool clearButtonVisible;
  final DateTime focusedDay;
  final VoidCallback onClearButtonTap;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onTodayButtonTap;

  @override
  Widget build(BuildContext context) {
    final String text = DateFormat.yMMMM().format(focusedDay);
    return Container(
      decoration: const BoxDecoration(),
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 17)),
          ),
          if (clearButtonVisible)
            CustomIconButton(
              icon: Icons.clear,
              onTap: onClearButtonTap,
            ),
          CustomIconButton(
            icon: Icons.calendar_today,
            onTap: onTodayButtonTap,
          ),
          CustomIconButton(
            icon: Icons.chevron_left,
            onTap: onLeftChevronTap,
          ),
          CustomIconButton(
            icon: Icons.chevron_right,
            onTap: onRightChevronTap,
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    @required this.icon,
    @required this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    this.padding = const EdgeInsets.all(10),
    Key key,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: padding,
          child: Icon(icon),
        ),
      ),
    );
  }
}
