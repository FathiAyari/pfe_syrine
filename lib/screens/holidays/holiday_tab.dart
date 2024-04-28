import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';

import '../../components/will_pop.dart';
import '../../constants.dart';
import '../../models/holiday.dart';
import '../../services/holidays_services.dart';

class HolidayTab extends StatefulWidget {
  final int status;
  const HolidayTab({Key? key, required this.status}) : super(key: key);

  @override
  State<HolidayTab> createState() => _AcceptedHolidaysState();
}

class _AcceptedHolidaysState extends State<HolidayTab> {
  var user = GetStorage().read('user');
  Color getColor(int status) {
    if (status == -1) {
      return Color(0xffed6591);
    } else if (status == 0) {
      return Color(0xfff0a55f);
    } else {
      return Color(0xff69e5c8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder(
          future: HolidaysServices().getHolidays({'status': widget.status, "user_id": user['id']}),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Holiday> holidays = [];
              snapshot.data.map((json) {
                holidays.add(json);
              }).toList();

              if (holidays.length != 0) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.02, vertical: Constants.screenHeight * 0.01),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: getColor(widget.status),
                          boxShadow: [
                            BoxShadow(
                              color: getColor(widget.status).withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Request Label : ${holidays[index].label}",
                                  style: TextStyle(
                                      fontFamily: "NunitoBold", color: Colors.white, fontSize: Constants.screenHeight * 0.02),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Container(
                              child: ListTile(
                                title: Text(
                                  "Request's start date :${DateFormat('yyyy-MM-dd').format(holidays[index].start)}",
                                  style: TextStyle(
                                      fontFamily: "NunitoBold", color: Colors.white, fontSize: Constants.screenHeight * 0.02),
                                ),
                              ),
                            ),
                            Container(
                              child: ListTile(
                                title: Text(
                                  "Request's end date :${DateFormat('yyyy-MM-dd').format(holidays[index].end)}",
                                  style: TextStyle(
                                      fontFamily: "NunitoBold", color: Colors.white, fontSize: Constants.screenHeight * 0.02),
                                ),
                              ),
                            ),
                            Container(
                              child: ListTile(
                                title: Text(
                                  "Request's raison :${holidays[index].raison}",
                                  style: TextStyle(
                                      fontFamily: "NunitoBold", color: Colors.white, fontSize: Constants.screenHeight * 0.02),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  /*      if (widget.status == 0) ...[
                                    ElevatedButton.icon(
                                        onPressed: () {
                                          */ /*Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => EditActivity(
                                                  activite: acts[index],
                                                )));*/ /*
                                        },
                                        icon: Icon(Icons.edit),
                                        label: Text("Edit")),
                                  ],*/
                                  if (widget.status != 1) ...[
                                    ElevatedButton.icon(
                                        onPressed: () {
                                          NAlertDialog(
                                            title: WillPopTitle("You want to delete this request ?", context),
                                            actions: [
                                              Negative(),
                                              Positive(() {
                                                HolidaysServices().deleteRequest(holidays[index].id, () {
                                                  setState(() {});
                                                }).then((value) {
                                                  if (value) {
                                                    Navigator.pop(context);
                                                    Fluttertoast.showToast(
                                                        msg: "Request deleted successfully",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Color(0xff69e5c8),
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  } else {
                                                    Navigator.pop(context);
                                                    Fluttertoast.showToast(
                                                        msg: "Error has been occured",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  }
                                                });
                                              })
                                            ],
                                            blur: 2,
                                          ).show(context, transitionType: DialogTransitionType.Bubble);
                                        },
                                        icon: Icon(Icons.delete),
                                        label: Text("Delete")),
                                  ]
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: holidays.length,
                );
              } else {
                return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Center(
                          child: Column(
                        children: [
                          Lottie.asset("assets/empty.json"),
                          Text(
                            "There is no holiday request here yet ",
                            style: TextStyle(fontSize: 20, fontFamily: "NunitoBold", color: Colors.black.withOpacity(0.5)),
                          )
                        ],
                      ));
                    });
              }
            } else {
              return Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1));
            }
          }),
    );
  }
}
