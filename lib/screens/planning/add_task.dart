import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/button.dart';
import 'package:pfe_syrine/global.dart';
import 'package:pfe_syrine/input_filed.dart';
import 'package:pfe_syrine/screens/planning/planning.dart';
import 'package:pfe_syrine/services/planning_services.dart';

import '../../constants.dart';
import '../../models/activite.dart';
import '../../models/user.dart';
import '../../services/callapi.dart';
import '../companies/components/input_field.dart';

final GlobalKey<BarcodeState> barcodeKey = GlobalKey();

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  bool endTimeSelected = false;
  DateTime endDateTime = DateTime.now();
  DateTime startDateTime = DateTime.now();
  bool startDateSelected = false;

  int? userId;
  int? actId;
  List<Activite> acts = [];
  List<User> users = [];
  bool loading = false;
  bool loadData = false;
  Future getActivities() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getData('activities/-1');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      List<Activite> data = ll.map<Activite>((json) => Activite.fromJson(json)).toList();
      setState(() {
        acts = data;
        print(acts);
      });
    }
  }

  getUsers() async {
    var user = GetStorage().read("user");
    var response = await CallApi().getData('getusers/${user['id']}');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      List<User> data = ll.map<User>((json) => User.fromJson(json)).toList();
      setState(() {
        users = data;
        loading = false;
      });
    }
  }

  TextEditingController note = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getActivities().then((value) {
      getUsers();
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Planning"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CalendarPage(),
                ));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color(0xff7ea4f3),
      ),
      body: loading
          ? Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1))
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  getUsers().then((value) {
                    getActivities();
                  });
                });
              },
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Select User",
                              ),
                              items: users
                                  .map((item) => DropdownMenuItem<int>(
                                        value: item.id,
                                        child: Text(
                                          "${item.firstname.toUpperCase()} ${item.lastname.toUpperCase()}",
                                          style: TextStyle(
                                              fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: userId,
                              onChanged: (value) {
                                setState(() {
                                  userId = value as int;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Select Activity",
                              ),
                              items: acts
                                  .map((item) => DropdownMenuItem<int>(
                                        value: item.id,
                                        child: Text(
                                          "${item.name} ",
                                          style: TextStyle(
                                              fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: actId,
                              onChanged: (value) {
                                setState(() {
                                  actId = value as int;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        MyInputfiled(
                          title: "Start Time ",
                          hint: DateFormat("yyyy-MM-dd HH:mm").format(startDateTime),
                          widget: IconButton(
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100))
                                  .then((date) {
                                if (date == null) return;
                                showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
                                  if (time == null) return;
                                  setState(() {
                                    startDateSelected = true;
                                    startDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                                  });
                                });
                              });
                            },
                          ),
                        ),
                        MyInputfiled(
                          title: "End Time ",
                          hint: DateFormat("yyyy-MM-dd HH:mm").format(endDateTime),
                          widget: IconButton(
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100))
                                  .then((date) {
                                if (date == null) return;
                                showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
                                  if (time == null) return;
                                  setState(() {
                                    endTimeSelected = true;
                                    endDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                                  });
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: InputField("Note", note),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        loadData
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                padding: EdgeInsets.only(top: 10, bottom: 5),
                                child: MyButton(
                                    label: "Create Planning",
                                    ontap: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (userId == null) {
                                          Fluttertoast.showToast(
                                              msg: "Select a user",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else if (actId == null) {
                                          Fluttertoast.showToast(
                                              msg: "Select an activity ",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else if (!startDateSelected) {
                                          Fluttertoast.showToast(
                                              msg: "Select a start date time",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else if (!endTimeSelected) {
                                          Fluttertoast.showToast(
                                              msg: "Select an end date time ",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else if (startDateTime.isAfter(endDateTime)) {
                                          Fluttertoast.showToast(
                                              msg: "End time can't be before start time ",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else {
                                          setState(() {
                                            loadData = true;
                                          });
                                          PlanningServices().createPlanning({
                                            "user_id": userId,
                                            "activity_id": actId,
                                            "start_time": startDateTime.toString(),
                                            "end_time": endDateTime.toString(),
                                            "note": note.text
                                          }, () {
                                            setState(() {});
                                          }).then((value) {
                                            setState(() {
                                              loadData = false;
                                              userId = null;
                                              actId = null;
                                              note.text = "";

                                              Fluttertoast.showToast(
                                                  msg: "Planning added successfully",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Barcode(
                                                        value: "${value.id}",
                                                        key: Global.barcodeKey,
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                              PlanningServices().renderPdf(value);
                                                            },
                                                            child: Text("Download Qr Code"))
                                                      ],
                                                    );
                                                  });
                                            });
                                          });
                                        }
                                      }
                                    }),
                              )
                      ],
                    ),
                  ],
                )),
              ),
            ),
    );
  }
}
