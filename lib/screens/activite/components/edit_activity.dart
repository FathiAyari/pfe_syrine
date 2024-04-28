import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pfe_syrine/models/activite.dart';
import 'package:pfe_syrine/screens/activite/activite.dart';
import 'package:pfe_syrine/screens/user/components/rounted_btn.dart';
import 'package:pfe_syrine/services/activities_services.dart';

import '../../../constants.dart';
import '../../companies/components/input_field.dart';

class EditActivity extends StatefulWidget {
  final Activite activite;

  const EditActivity({Key? key, required this.activite}) : super(key: key);

  @override
  State<EditActivity> createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final _formKey = GlobalKey<FormState>();

// create some values
  Color activityColor = Colors.red;
  bool isLoading = false;

// ValueChanged<Color> ss
  void changeColor(Color color) {
    setState(() => activityColor = color);
  }

  TextEditingController activityNameController = TextEditingController();
  TextEditingController activiteTypeController = TextEditingController();
  TextEditingController activityDescController = TextEditingController();

  fetchData() {
    setState(() {
      activityNameController.text = widget.activite.name;
      activiteTypeController.text = widget.activite.type;
      activityDescController.text = widget.activite.description;
      activityColor = Color(widget.activite.color);
    });

    for (var tp in types) {
      if (tp == widget.activite.type) {
        setState(() {
          type = tp;
        });
      }
    }
  }

  String? type;
  List types = [
    "High Emergency",
    "Emergency",
    "Medium Emergency",
    "Low Emergency",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ActiviteScreen()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text("Edit Activity"),
        backgroundColor: const Color(0xff7ea4f3),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputField("Activity Name", activityNameController),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 16,
                          color: Color(0xff7ea4f3),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            "Select Type",
                            style: TextStyle(fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: types
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(fontFamily: "NunitoBold", fontWeight: FontWeight.bold, color: Color(0xff7ea4f3)),
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
                    customButton: const Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required field";
                    }
                  },
                  keyboardType: TextInputType.text,
                  controller: activityDescController,
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
                    hintText: "Description",
                  ), // InputDecoration
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
                                setState(() {
                                  isLoading = true;
                                });

                                ActivitiesServices.updateActivity({
                                  "name": activityNameController.text,
                                  "type": activiteTypeController.text,
                                  "description": activityDescController.text,
                                  "color": activityColor.value,
                                  "type": type,
                                }, widget.activite.id)
                                    .then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (value) {
                                    Fluttertoast.showToast(
                                        msg: "Activity updated successfully",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else {
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
                              }
                            },
                            child: Text("Confirm"))
                      ],
                    ),
            ],
          ),
        ),
      ),
    ));
  }
}
