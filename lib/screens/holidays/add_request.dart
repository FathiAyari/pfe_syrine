import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/constants.dart';
import 'package:pfe_syrine/services/holidays_services.dart';

import '../../input_filed.dart';
import '../companies/components/input_field.dart';
import 'my_holidays.dart';

class AddRequestHoliday extends StatefulWidget {
  const AddRequestHoliday({Key? key}) : super(key: key);

  @override
  State<AddRequestHoliday> createState() => _AddRequestHolidayState();
}

class _AddRequestHolidayState extends State<AddRequestHoliday> {
  DateTime startDateTime = DateTime.now();
  bool startDateSelected = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController raisonController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  bool loadData = false;
  DateTime endDateTime = DateTime.now();
  bool endTimeSelected = false;
  var user = GetStorage().read('user');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyHolidays(),
                ));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Add Holiday Request"),
        centerTitle: true,
        backgroundColor: Color(0xff7ea4f3),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: SingleChildScrollView(
          child: Container(
            height: Constants.screenHeight * 0.87,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InputField("Label", labelController),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required field";
                            }
                          },
                          keyboardType: TextInputType.text,
                          controller: raisonController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff7ea4f3),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            //
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff7ea4f3),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff7ea4f3),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // OutlineInputBorder
                            filled: true,
                            fillColor: Colors.white,
                            label: Text("Request raison"),
                          ), // InputDecoration
                        ),
                      )
                    ],
                  ),
                ),
                MyInputfiled(
                  title: "First day ",
                  hint: DateFormat("yyyy-MM-dd").format(startDateTime),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      showDatePicker(
                              context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100))
                          .then((date) {
                        if (date == null) return;
                        setState(() {
                          startDateSelected = true;
                          startDateTime = DateTime(date.year, date.month, date.day);
                        });
                      });
                    },
                  ),
                ),
                MyInputfiled(
                  title: "Last day ",
                  hint: DateFormat("yyyy-MM-dd").format(endDateTime),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      showDatePicker(
                              context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100))
                          .then((date) {
                        if (date == null) return;
                        setState(() {
                          endTimeSelected = true;
                          endDateTime = DateTime(date.year, date.month, date.day);
                        });
                      });
                    },
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadData
                      ? Center(child: Lottie.asset("assets/loading.json", height: Constants.screenHeight * 0.1))
                      : Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                              icon: Icon(Icons.done_all),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.all(15),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (!startDateSelected) {
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
                                        msg: "Select an end date time",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else if (startDateTime.isAfter(endDateTime)) {
                                    Fluttertoast.showToast(
                                        msg: "Select a valid date",
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
                                    HolidaysServices().createRequest({
                                      "user_id": user['id'],
                                      "label": labelController.text,
                                      "raison": raisonController.text,
                                      "start": startDateTime.toString(),
                                      "end": endDateTime.toString(),
                                    }).then((value) {
                                      setState(() {
                                        loadData = false;
                                        labelController.text = "";
                                        raisonController.text = "";
                                        startDateTime = DateTime.now();
                                        endDateTime = DateTime.now();
                                      });
                                      if (value) {
                                        Fluttertoast.showToast(
                                            msg: "Request added successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.grey,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
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
                                  }
                                }
                              },
                              label: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text("Validate"),
                              )),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
