import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pfe_syrine/models/notifications.dart';
import 'package:pfe_syrine/models/planning.dart';
import 'package:pfe_syrine/services/notifications_services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../components/drawer.dart';
import '../../components/will_pop.dart';
import '../../constants.dart';
import '../../services/callapi.dart';
import 'add_task.dart';
import 'components/notifications.dart';
import 'components/planning_details.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var userData = GetStorage().read("user");

  List<Planning> plannings = [];

  bool loading = false;
  getPlannings() async {
    setState(() {
      loading = true;
    });
    http.Response response = await CallApi().getData('getplannings');
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

  final CalendarController _controller = CalendarController();

  Future<bool> avoidReturnButton() async {
    NAlertDialog(
      title: WillPopTitle("You want to exit?", context),
      actions: [
        Negative(),
        Positive(() {
          exit(0);
        })
      ],
      blur: 2,
    ).show(context, transitionType: DialogTransitionType.Bubble);
    return true;
  }

  List<Appointment>? appointmentDetails = <Appointment>[];
  int unssenNotif = 0;
  getCount() {
    NotifServices().getNotifs().then((value) {
      List<Notif> notifs = [];
      value.map((json) {
        if (json.status == 0) {
          notifs.add(json);
        }
      }).toList();
      setState(() {
        unssenNotif = notifs.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCount();
    getPlannings();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: avoidReturnButton,
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: AppBar(
                backgroundColor: Color.fromRGBO(238, 238, 238, 1),
                title: Row(
                  children: [
                    Text(
                      userData != null
                          ? '${userData['firstname'].toString().toUpperCase()} ${userData['lastname'].toString().toUpperCase()}'
                          : '',
                      style: TextStyle(color: Color.fromRGBO(1, 60, 77, 30), fontSize: 25),
                    ),
                  ],
                ),
                iconTheme: const IconThemeData(
                  color: Color.fromRGBO(112, 112, 112, 1),
                ),
              )),
          endDrawer: Mydrawer(),
          floatingActionButton: Visibility(
            visible: userData['role'] == 'Admin' || userData['role'] == 'Super Admin',
            child: FloatingActionButton(
              child: Icon(Icons.add),
              elevation: 8,
              onPressed: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AddTaskPage(),
                    ));
              }),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                getPlannings();
                getCount();
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
                            height: Constants.screenHeight * 0.89,
                            child: Column(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.topRight,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration:
                                            BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(15)),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  NotifServices().seeNotif().then((value) {
                                                    if (value) {
                                                      Get.to(Notifications());
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: "Error has been occured",
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Color(0xff69e5c8),
                                                          textColor: Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.notifications,
                                                  color: Colors.white,
                                                )),
                                            Positioned(
                                              top: -3,
                                              left: -3,
                                              child: CircleAvatar(
                                                radius: 10,
                                                child: Text(
                                                  unssenNotif > 9 ? "+9" : "$unssenNotif",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
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
                                                          'Start Date time : ${DateFormat('yyyy-MM-dd HH:mm').format(appointmentDetails![index].startTime)}',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w600, color: Colors.white, height: 1.7),
                                                        ),
                                                        Text(
                                                          'End Date time : ${DateFormat('yyyy-MM-dd HH:mm').format(appointmentDetails![index].endTime)}',
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

  getColor(Planning planning) {
    if (planning.status == 0) {
      return Colors.red;
    } else if (planning.status == 1) {
      return Colors.amber;
    } else {
      return Colors.green;
    }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
