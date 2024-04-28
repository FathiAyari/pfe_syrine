import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/screens/activite/components/assigned_in_hold_activities.dart';
import 'package:pfe_syrine/screens/activite/components/assigned_in_progress.dart';
import 'package:pfe_syrine/screens/activite/components/finished_activities.dart';
import 'package:pfe_syrine/screens/activite/components/unassigned_activties.dart';
import 'package:pfe_syrine/screens/user/components/rounted_btn.dart';

import '../../constants.dart';
import '../../models/activite.dart';
import '../../services/activities_services.dart';
import '../planning/planning.dart';

class ActiviteScreen extends StatefulWidget {
  const ActiviteScreen({Key? key}) : super(key: key);

  @override
  State<ActiviteScreen> createState() => _ActiviteScreenState();
}

class _ActiviteScreenState extends State<ActiviteScreen> with TickerProviderStateMixin {
  List<Activite> activites = [];
  List nomactivite = [];

  getactivites() async {
    String myUrl = "http://192.168.43.189:8000/api/getactivites";
    http.Response response = await http.get(Uri.parse(myUrl));
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      activites = ll.map<Activite>((json) => Activite.fromJson(json)).toList();

      setState(() {
        nomactivite = activites.map((activites) => activites.name).toList();
      });

      nomactivite = activites.map((activites) => activites.name).toList();
    }
    print(nomactivite);
    return nomactivite;
  }

// create some values
  Color activityColor = Color(0xff443a49);

// ValueChanged<Color> ss
  void changeColor(Color color) {
    setState(() => activityColor = color);
  }

  List<Color> colors = [Color(0xffed6591), Colors.amber, Color(0xfff0a55f), Color(0xff69e5c8)];
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController description = TextEditingController();
  late TabController _tabController;
  int color = 0;

  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0)
      ..addListener(() {
        setState(() {
          color = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            addActivity(context, () {
              setState(() {});
            });
          },
          backgroundColor: const Color(0xff066163),
          child: const Icon(
            Icons.add,
            size: 25.0,
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );
            },
          ),
          title: const Text("Activities"),
          backgroundColor: const Color(0xff7ea4f3),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.01, horizontal: Constants.screenWidth * 0.01),
                child: Container(
                  child: TabBar(
                    splashBorderRadius: BorderRadius.circular(20),
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    unselectedLabelColor: Color(0xff7ea4f3),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: colors[color],
                    ),
                    controller: _tabController,
                    tabs: [
                      Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Constants.screenHeight * 0.009,
                          ),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                          child: Text("Unassigned", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                      Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Constants.screenHeight * 0.009,
                          ),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                          child: Text("In Hold", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                      Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Constants.screenHeight * 0.009,
                          ),
                          child: Text("In Progress", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                      Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Constants.screenHeight * 0.009,
                          ),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                          child: Text("Finished", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: [
                  UnAssignedActivities(
                    status: -1,
                  ),
                  AssignedInHoldActivities(
                    status: 0,
                  ),
                  AssignedInProgress(
                    status: 1,
                  ),
                  FinishedActivities(status: 2),
                ],
              ))
            ],
          ),
        ));
  }

  /*createactivite() async {
    final String code = 'ac-code' + Random().nextInt(1000).toString();
    var data = {
      'name': name.text,
      'description': description.text,
      'type': type.text,
      'code': code,
      'color': currentColor.value,
      'created_by': userData['id'],
    };

    print(data);
    http.Response res = await CallApi().postData(data, 'postactivites');
    var body = jsonDecode(res.body);

    print(body);
    if (body['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Success .. !"),
        duration: Duration(seconds: 2),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActiviteScreen(),
        ),
      );
    }
  }*/

  addActivity(BuildContext context, VoidCallback onPressed) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String? type;
    List types = [
      "High Emergency",
      "Emergency",
      "Medium Emergency",
      "Low Emergency",
    ];
    bool isLoading = false;

    bool isDone = false;

    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              color: Colors.transparent,
              child: Container(
                height: Constants.screenHeight * 0.8,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 10),
                  child: isDone
                      ? doneSupply(context)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 5,
                              width: Constants.screenWidth * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Add Activity", style: TextStyle(fontSize: 20, color: Color(0xff4d5251))),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required field";
                                        }
                                      },
                                      keyboardType: TextInputType.text,
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff69e5c8),
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        //
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff69e5c8),
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff69e5c8),
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        // OutlineInputBorder
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Name",
                                      ), // InputDecoration
                                    ),
                                  ),
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
                                      controller: descriptionController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff69e5c8),
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        //
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff69e5c8),
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff69e5c8),
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        // OutlineInputBorder
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Description",
                                      ), // InputDecoration
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<String>(
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
                                  hintText: "Select Type",
                                ),
                                items: types
                                    .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                        fontFamily: "NunitoBold",
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff7ea4f3)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                                    .toList(),
                                value: type,
                                onChanged: (value) {
                                  setState(() {
                                    type = value as String;
                                  });
                                },
                              ),
                            ),

                            RoundedButton(
                              color: activityColor,
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Pick a color!'),
                                        content: SingleChildScrollView(
                                          child: ColorPicker(
                                            pickerColor: activityColor,
                                            onColorChanged: changeColor,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: const Text('Got it'),
                                            onPressed: () {
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              title: 'color',
                            ),
                            isLoading
                                ? Lottie.asset(
                                    "assets/loading.json",
                                    height: Constants.screenWidth * 0.15,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: Text("Cancel"),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            padding: EdgeInsets.all(15),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              if (activityColor == 0xff443a49 || type == null) {
                                                Fluttertoast.showToast(
                                                    msg: "Missing Type or Color",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                ActivitiesServices().createActivity({
                                                  "name": nameController.text,
                                                  "description": descriptionController.text,
                                                  "type": type,
                                                  "color": activityColor.value
                                                }, () {
                                                  onPressed();
                                                }).then((value) {
                                                  setState(() {
                                                    isLoading = false;
                                                    isDone = true;
                                                  });
                                                });
                                              }
                                            }
                                          },
                                          child: Text("Confirm"))
                                    ],
                                  ),
                          ],
                        ),
                ),
              ),
            );
          });
        });
  }

  Column doneSupply(BuildContext context) {
    return Column(
      children: [
        Lottie.asset("assets/success.json", height: Constants.screenHeight * 0.1, repeat: false),
        Text(
          "",
          style: TextStyle(fontSize: Constants.screenHeight * 0.02),
        ),
        SizedBox(
          height: Constants.screenHeight * 0.08,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text("Close"),
            ))
      ],
    );
  }
}
