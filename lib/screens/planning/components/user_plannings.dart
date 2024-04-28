import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/screens/planning/components/planning_details.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../constants.dart';
import '../../../models/planning.dart';
import '../../../models/user.dart';
import '../../../services/callapi.dart';

class UserPlannings extends StatefulWidget {
  final User user;
  const UserPlannings({Key? key, required this.user}) : super(key: key);

  @override
  State<UserPlannings> createState() => _UserPlanningsState();
}

class _UserPlanningsState extends State<UserPlannings> {
  List<Planning> plannings = [];

  bool loading = false;
  getPlannings() async {
    setState(() {
      loading = true;
    });
    http.Response response = await CallApi().getData('myplans/${widget.user.id}');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      List<Planning> data = ll.map<Planning>((json) => Planning.fromJson(json)).toList();

      setState(() {
        plannings = data;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPlannings();
  }

  final CalendarController _controller = CalendarController();

  List<Appointment>? appointmentDetails = <Appointment>[];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Planning details"),
            centerTitle: true,
            backgroundColor: Color(0xff7ea4f3),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                getPlannings();
                appointmentDetails = <Appointment>[];
              });
            },
            child: loading
                ? Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1))
                : Container(
                    height: Constants.screenHeight,
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Container(
                            height: Constants.screenHeight * 0.9,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: SfCalendar(
                                    appointmentTimeTextFormat: 'HH:mm',
                                    view: CalendarView.month,
                                    allowedViews: const [
                                      CalendarView.month,
                                      CalendarView.week,
                                      CalendarView.day,
                                    ],
                                    onTap: calendarTapped,
                                    controller: _controller,
                                    dataSource: getCalendarDataSource(),
                                    monthViewSettings: MonthViewSettings(),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      color: Colors.black12,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.all(2),
                                        itemCount: appointmentDetails!.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                        PlanningDetails(appointment: appointmentDetails![index]),
                                                  ));
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: appointmentDetails![index].color,
                                                    borderRadius: BorderRadius.circular(15)),
                                                child: Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Start Date time : ${DateFormat('yyyy-MM-dd hh:mm').format(appointmentDetails![index].startTime)}',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w600, color: Colors.white, height: 1.7),
                                                        ),
                                                        Text(
                                                          'End Date time : ${DateFormat('yyyy-MM-dd hh:mm').format(appointmentDetails![index].endTime)}',
                                                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                                                        ),
                                                        Container(
                                                            child: Text('${appointmentDetails![index].subject}',
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          );
                                        },
                                        separatorBuilder: (BuildContext context, int index) => const Divider(
                                          height: 5,
                                        ),
                                      )),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
          )),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        appointmentDetails = calendarTapDetails.appointments!.cast<Appointment>();
      });
    }
  }

  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    for (int i = 0; i < plannings.length; i++) {
      appointments.add(Appointment(
          notes: plannings[i].id.toString(),
          startTime: plannings[i].start_time,
          endTime: plannings[i].end_time,
          color: getColor(plannings[i]),
          subject:
              "Activity:${plannings[i].activity.name.toUpperCase()}\nEmployee : ${plannings[i].user.firstname} ${plannings[i].user.firstname.toUpperCase()}"));
    }
    return _DataSource(appointments);
  }
}

getColor(Planning planning) {
  if (planning.status == 0) {
    return Colors.red;
  } else if (planning.status == 1) {
    return Colors.amber;
  } else {
    return Colors.green;
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
