import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/models/planning.dart';
import 'package:pfe_syrine/services/planning_services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../constants.dart';
import '../../../services/callapi.dart';
import '../planning.dart';
import 'my_plannings.dart';

class PlanningDetails extends StatefulWidget {
  final Appointment appointment;
  const PlanningDetails({Key? key, required this.appointment}) : super(key: key);

  @override
  State<PlanningDetails> createState() => _PlanningDetailsState();
}

class _PlanningDetailsState extends State<PlanningDetails> {
  bool loading = false;
  late Planning planning;

  getPlanning() async {
    setState(() {
      loading = true;
    });
    http.Response response = await CallApi().getData('getplanning/${int.parse(widget.appointment.notes!)}');
    var jsondata = jsonDecode(response.body);
    var data = Planning.fromJson(jsondata);

    setState(() {
      planning = data;
      loading = false;
    });
  }

  var user = GetStorage().read('user');
  String getStatus(int index) {
    if (index == 2) {
      return "Done";
    } else if (index == 0) {
      return "In Hold";
    } else {
      return "In Progress";
    }
  }

  Widget getFloatingActionButton() {
    if (user['role'] == "Super Admin" || user['role'] == "Super Admin") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          child: ElevatedButton.icon(
              icon: Icon(Icons.delete),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.all(15),
              ),
              onPressed: () async {
                PlanningServices().deletePlanning(planning.id, () {
                  setState(() {});
                }).then((value) {
                  if (value) {
                    Fluttertoast.showToast(
                        msg: "Planning deleted successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => CalendarPage(),
                        ));
                  } else {
                    Fluttertoast.showToast(
                        msg: "Error has been occured",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                });
              },
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("Delete"),
              )),
        ),
      );
    } else if (planning.status == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          child: ElevatedButton.icon(
              icon: Icon(Icons.document_scanner_rounded),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.all(15),
              ),
              onPressed: (DateTime.now().isAfter(planning.start_time.subtract(Duration(minutes: 5))) &&
                      (DateTime.now().isBefore(planning.end_time)))
                  ? () async {
                      try {
                        String scanResult = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
                        try {
                          PlanningServices().startPlanning(int.parse(scanResult), () {
                            setState(() {
                              getPlanning();
                            });
                          }).then((value) {
                            if (value) {
                              Get.snackbar(
                                "Cura Shape",
                                "Planning Started Successfully",
                                icon: Icon(Icons.done, color: Colors.green),
                                snackPosition: SnackPosition.TOP,
                              );
                            } else {
                              Get.snackbar(
                                "Cura Shape",
                                "Qr Code not validzz",
                                icon: Icon(Icons.qr_code, color: Colors.red),
                                snackPosition: SnackPosition.TOP,
                              );
                            }
                          });
                          // etc.
                        } on FormatException {
                          Get.snackbar(
                            "Cura Shape",
                            "Qr Code not validss",
                            icon: Icon(Icons.qr_code, color: Colors.white),
                            snackPosition: SnackPosition.TOP,
                          );
                        }
                      } on PlatformException {}
                    }
                  : null,
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("Start"),
              )),
        ),
      );
    } else if (planning.status == 1) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          child: ElevatedButton.icon(
              icon: Icon(Icons.document_scanner_rounded),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.all(15),
              ),
              onPressed: DateTime.now().isAfter(planning.end_time)
                  ? () async {
                      try {
                        String scanResult = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
                        try {
                          PlanningServices().finishPlanning(int.parse(scanResult), () {
                            setState(() {
                              getPlanning();
                            });
                          }).then((value) {
                            if (value) {
                              Get.snackbar(
                                "Cura Shape",
                                "Planning finished Successfully",
                                icon: Icon(Icons.done, color: Colors.green),
                                snackPosition: SnackPosition.TOP,
                              );
                            } else {
                              Get.snackbar(
                                "Cura Shape",
                                "Qr Code not valids",
                                icon: Icon(Icons.qr_code, color: Colors.red),
                                snackPosition: SnackPosition.TOP,
                              );
                            }
                          });
                          // etc.
                        } on FormatException {
                          Get.snackbar(
                            "Cura Shape",
                            "Qr Code not valid",
                            icon: Icon(Icons.qr_code, color: Colors.white),
                            snackPosition: SnackPosition.TOP,
                          );
                        }
                      } on PlatformException {}
                    }
                  : null,
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("Finish"),
              )),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlanning();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text("Planning details"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (user['role'] == "Super Admin" || user['role'] == "Super Admin") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CalendarPage(),
                  ));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyPlannings(),
                  ));
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color(0xff7ea4f3),
      ),
      body: loading
          ? Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  detail("Planning Activity : ${planning.activity.name} "),
                  detail("Activity Type : ${planning.activity.type} "),
                  detail("Employee : ${planning.user.firstname.toUpperCase()} ${planning.user.lastname.toUpperCase()}"),
                  detail("Start Date Time  : ${DateFormat('yyyy-MM-dd HH:mm').format(planning.start_time)} "),
                  detail("End date time : ${DateFormat('yyyy-MM-dd HH:mm').format(widget.appointment.endTime)} "),
                  detail("Status :  ${getStatus(planning.status)} "),
                  detail("Description :  ${planning.activity.description} "),
                  Spacer(),
                  getFloatingActionButton()
                ],
              ),
            ),
    ));
  }

  detail(String content) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Color(0xff7ea4f3), borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            content,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white, height: 1.7),
          ),
        ),
      ),
    );
  }
}
